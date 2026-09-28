package com.bondcircle.service;

import com.bondcircle.dto.CircleDto;
import com.bondcircle.dto.UserCirclesResponse;
import com.bondcircle.entity.Circle;
import com.bondcircle.entity.User;
import com.bondcircle.entity.UserCircle;
import com.bondcircle.repository.CircleRepository;
import com.bondcircle.repository.UserCircleRepository;
import com.bondcircle.repository.UserRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class CircleService {

    private final CircleRepository circleRepository;
    private final UserCircleRepository userCircleRepository;
    private final UserRepository userRepository;

    public CircleService(
            CircleRepository circleRepository,
            UserCircleRepository userCircleRepository,
            UserRepository userRepository
    ) {
        this.circleRepository = circleRepository;
        this.userCircleRepository = userCircleRepository;
        this.userRepository = userRepository;
    }

    @PostConstruct
    @Transactional
    public void initDefaultCircles() {
        List<CircleSeed> seeds = List.of(
                new CircleSeed("Coffee Explorers", "Find hidden cafés, try new brews and plan relaxed coffee dates.", "Lifestyle"),
                new CircleSeed("Gaming", "Co-op adventures, favourite games and friendly competition.", "Social"),
                new CircleSeed("Fitness", "Share your favourite workouts and active routines.", "Active"),
                new CircleSeed("Readers & Stories", "Books, bookstores and conversations that go beyond small talk.", "Creative"),
                new CircleSeed("Weekend Trekkers", "Easy trails, sunrise walks and active weekends with good company.", "Active"),
                new CircleSeed("Indie Music Club", "Share playlists, discover artists and meet at small live gigs.", "Creative"),
                new CircleSeed("Food Trail", "Street food, brunch spots and honest recommendations around town.", "Lifestyle"),
                new CircleSeed("Builders & Dreamers", "Startups, side projects and ambitious conversations without pitching.", "Social")
        );

        for (CircleSeed seed : seeds) {
            if (!circleRepository.existsByNameIgnoreCase(seed.name)) {
                circleRepository.save(new Circle(seed.name, seed.description, seed.category));
            }
        }
    }

    @Transactional(readOnly = true)
    public UserCirclesResponse getUserCircles(User user) {
        if (user == null || user.getId() == null) {
            return new UserCirclesResponse(Collections.emptyList());
        }
        List<UserCircle> memberships = userCircleRepository.findByUserId(user.getId());
        List<String> names = memberships.stream()
                .map(uc -> uc.getCircle().getName())
                .collect(Collectors.toList());
        return new UserCirclesResponse(names);
    }

    @Transactional
    public UserCirclesResponse updateUserCircles(User user, List<String> requestedCircleNames) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("Authenticated user is required");
        }

        User managedUser = userRepository.findById(user.getId())
                .orElseThrow(() -> new IllegalArgumentException("User not found: " + user.getId()));

        List<String> targetNames = requestedCircleNames != null
                ? requestedCircleNames.stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .distinct()
                .collect(Collectors.toList())
                : Collections.emptyList();

        List<UserCircle> currentMemberships = userCircleRepository.findByUserId(managedUser.getId());
        Map<String, UserCircle> currentMap = new HashMap<>();
        for (UserCircle uc : currentMemberships) {
            currentMap.put(uc.getCircle().getName().toLowerCase(), uc);
        }

        Set<String> targetLower = targetNames.stream().map(String::toLowerCase).collect(Collectors.toSet());

        // Delete memberships no longer selected
        for (UserCircle uc : currentMemberships) {
            if (!targetLower.contains(uc.getCircle().getName().toLowerCase())) {
                userCircleRepository.delete(uc);
            }
        }

        // Add new memberships without creating duplicate circles
        for (String targetName : targetNames) {
            if (!currentMap.containsKey(targetName.toLowerCase())) {
                Circle circle = circleRepository.findByNameIgnoreCase(targetName)
                        .orElseGet(() -> circleRepository.save(new Circle(targetName, "Community for " + targetName, "General")));
                UserCircle newMembership = new UserCircle(managedUser, circle);
                userCircleRepository.save(newMembership);
            }
        }

        // Flush and return updated
        List<UserCircle> updatedMemberships = userCircleRepository.findByUserId(managedUser.getId());
        List<String> resultNames = updatedMemberships.stream()
                .map(uc -> uc.getCircle().getName())
                .collect(Collectors.toList());

        return new UserCirclesResponse(resultNames);
    }

    @Transactional(readOnly = true)
    public List<CircleDto> getAllCircles() {
        return circleRepository.findAll().stream()
                .map(CircleDto::fromEntity)
                .collect(Collectors.toList());
    }

    private static class CircleSeed {
        final String name;
        final String description;
        final String category;

        CircleSeed(String name, String description, String category) {
            this.name = name;
            this.description = description;
            this.category = category;
        }
    }
}

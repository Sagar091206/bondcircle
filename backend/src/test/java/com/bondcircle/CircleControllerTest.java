package com.bondcircle;

import com.bondcircle.dto.UpdateCirclesRequest;
import com.bondcircle.entity.Circle;
import com.bondcircle.entity.User;
import com.bondcircle.repository.CircleRepository;
import com.bondcircle.repository.UserCircleRepository;
import com.bondcircle.repository.UserRepository;
import com.bondcircle.security.JwtService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class CircleControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CircleRepository circleRepository;

    @Autowired
    private UserCircleRepository userCircleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtService jwtService;

    private User testUser;
    private String jwtToken;

    @BeforeEach
    void setUp() {
        userCircleRepository.deleteAll();
        userRepository.deleteAll();

        testUser = new User("Sagar Kewat", "circles_user@example.com", passwordEncoder.encode("Password123!"));
        testUser.setEmailVerified(true);
        testUser = userRepository.save(testUser);

        jwtToken = jwtService.generateToken(testUser.getEmail(), testUser.getId());
    }

    @Test
    void testGetCirclesUnauthenticated() throws Exception {
        mockMvc.perform(get("/api/circles/me"))
                .andExpect(status().isForbidden());
    }

    @Test
    void testGetInitialUserCirclesIsEmpty() throws Exception {
        mockMvc.perform(get("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(0)));
    }

    @Test
    void testUpdateAndRetrieveUserCircles() throws Exception {
        UpdateCirclesRequest request = new UpdateCirclesRequest(
                List.of("Coffee Explorers", "Readers & Stories", "Fitness")
        );

        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(3)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Readers & Stories", "Fitness")));

        // Verify in PostgreSQL database
        assertEquals(3, userCircleRepository.findByUserId(testUser.getId()).size());

        // Verify retrieval on GET
        mockMvc.perform(get("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(3)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Readers & Stories", "Fitness")));
    }

    @Test
    void testUpdateCirclesDoesNotCreateDuplicateCircleRecords() throws Exception {
        long initialCircleCount = circleRepository.count();

        // Join circles
        UpdateCirclesRequest req1 = new UpdateCirclesRequest(List.of("Coffee Explorers", "Gaming"));
        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req1)))
                .andExpect(status().isOk());

        // Join again with overlapping circle
        UpdateCirclesRequest req2 = new UpdateCirclesRequest(List.of("Coffee Explorers", "Fitness"));
        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req2)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(2)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Fitness")));

        // Total Circle definitions in the system did not duplicate
        assertEquals(initialCircleCount, circleRepository.count());
    }

    @Test
    void testUserIsolationForCircles() throws Exception {
        User otherUser = new User("Other User", "other_circle@example.com", passwordEncoder.encode("Password123!"));
        otherUser.setEmailVerified(true);
        otherUser = userRepository.save(otherUser);
        String otherToken = jwtService.generateToken(otherUser.getEmail(), otherUser.getId());

        // User A joins Coffee Explorers & Gaming
        UpdateCirclesRequest userARequest = new UpdateCirclesRequest(List.of("Coffee Explorers", "Gaming"));
        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(userARequest)))
                .andExpect(status().isOk());

        // User B joins Weekend Trekkers
        UpdateCirclesRequest userBRequest = new UpdateCirclesRequest(List.of("Weekend Trekkers"));
        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + otherToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(userBRequest)))
                .andExpect(status().isOk());

        // Check user A
        mockMvc.perform(get("/api/circles/me")
                        .header("Authorization", "Bearer " + jwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(2)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Gaming")));

        // Check user B
        mockMvc.perform(get("/api/circles/me")
                        .header("Authorization", "Bearer " + otherToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(1)))
                .andExpect(jsonPath("$.circles", contains("Weekend Trekkers")));
    }
}

package com.bondcircle.controller;

import com.bondcircle.dto.CircleDto;
import com.bondcircle.dto.UpdateCirclesRequest;
import com.bondcircle.dto.UserCirclesResponse;
import com.bondcircle.entity.User;
import com.bondcircle.service.CircleService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/circles")
public class CircleController {

    private final CircleService circleService;

    public CircleController(CircleService circleService) {
        this.circleService = circleService;
    }

    @GetMapping("/me")
    public ResponseEntity<UserCirclesResponse> getMyCircles(@AuthenticationPrincipal User user) {
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        UserCirclesResponse response = circleService.getUserCircles(user);
        return ResponseEntity.ok(response);
    }

    @RequestMapping(value = "/me", method = {RequestMethod.POST, RequestMethod.PUT})
    public ResponseEntity<UserCirclesResponse> updateMyCircles(
            @AuthenticationPrincipal User user,
            @RequestBody UpdateCirclesRequest request
    ) {
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        UserCirclesResponse response = circleService.updateUserCircles(user, request != null ? request.getCircles() : null);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<List<CircleDto>> getAllCircles() {
        return ResponseEntity.ok(circleService.getAllCircles());
    }
}

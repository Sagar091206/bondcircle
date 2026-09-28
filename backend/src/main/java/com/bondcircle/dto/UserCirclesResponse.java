package com.bondcircle.dto;

import java.util.ArrayList;
import java.util.List;

public class UserCirclesResponse {

    private List<String> circles = new ArrayList<>();

    public UserCirclesResponse() {
    }

    public UserCirclesResponse(List<String> circles) {
        this.circles = circles != null ? new ArrayList<>(circles) : new ArrayList<>();
    }

    public List<String> getCircles() {
        return circles;
    }

    public void setCircles(List<String> circles) {
        this.circles = circles != null ? new ArrayList<>(circles) : new ArrayList<>();
    }
}

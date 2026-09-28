package com.bondcircle.dto;

import java.util.List;

public class UpdateCirclesRequest {

    private List<String> circles;

    public UpdateCirclesRequest() {
    }

    public UpdateCirclesRequest(List<String> circles) {
        this.circles = circles;
    }

    public List<String> getCircles() {
        return circles;
    }

    public void setCircles(List<String> circles) {
        this.circles = circles;
    }
}

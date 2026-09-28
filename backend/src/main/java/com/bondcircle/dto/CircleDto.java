package com.bondcircle.dto;

import com.bondcircle.entity.Circle;

public class CircleDto {

    private Long id;
    private String name;
    private String description;
    private String category;

    public CircleDto() {
    }

    public CircleDto(Long id, String name, String description, String category) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.category = category;
    }

    public static CircleDto fromEntity(Circle circle) {
        if (circle == null) return null;
        return new CircleDto(
                circle.getId(),
                circle.getName(),
                circle.getDescription(),
                circle.getCategory()
        );
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
}

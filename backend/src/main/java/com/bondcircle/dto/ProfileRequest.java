package com.bondcircle.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;

public class ProfileRequest {

    @NotBlank(message = "Gender is required")
    private String gender;

    @NotBlank(message = "Orientation is required")
    private String orientation;

    @NotBlank(message = "Connection intention is required")
    private String connectionIntention;

    @NotBlank(message = "Relationship style is required")
    private String relationshipStyle;

    @NotEmpty(message = "At least one interest is required")
    private List<@NotBlank(message = "Interest cannot be blank") String> interests;

    private Integer age;
    private String city;
    private String bio;
    private List<String> datingPreferences;
    private String childrenPlan;
    private String religion;
    private String politics;
    private String drinking;
    private String smoking;

    public ProfileRequest() {
    }

    public ProfileRequest(String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests) {
        this.gender = gender;
        this.orientation = orientation;
        this.connectionIntention = connectionIntention;
        this.relationshipStyle = relationshipStyle;
        this.interests = interests;
    }

    public ProfileRequest(String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests,
                          Integer age, String city, String bio, List<String> datingPreferences, String childrenPlan,
                          String religion, String politics, String drinking, String smoking) {
        this.gender = gender;
        this.orientation = orientation;
        this.connectionIntention = connectionIntention;
        this.relationshipStyle = relationshipStyle;
        this.interests = interests;
        this.age = age;
        this.city = city;
        this.bio = bio;
        this.datingPreferences = datingPreferences;
        this.childrenPlan = childrenPlan;
        this.religion = religion;
        this.politics = politics;
        this.drinking = drinking;
        this.smoking = smoking;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getOrientation() {
        return orientation;
    }

    public void setOrientation(String orientation) {
        this.orientation = orientation;
    }

    public String getConnectionIntention() {
        return connectionIntention;
    }

    public void setConnectionIntention(String connectionIntention) {
        this.connectionIntention = connectionIntention;
    }

    public String getRelationshipStyle() {
        return relationshipStyle;
    }

    public void setRelationshipStyle(String relationshipStyle) {
        this.relationshipStyle = relationshipStyle;
    }

    public List<String> getInterests() {
        return interests;
    }

    public void setInterests(List<String> interests) {
        this.interests = interests;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public List<String> getDatingPreferences() {
        return datingPreferences;
    }

    public void setDatingPreferences(List<String> datingPreferences) {
        this.datingPreferences = datingPreferences;
    }

    public String getChildrenPlan() {
        return childrenPlan;
    }

    public void setChildrenPlan(String childrenPlan) {
        this.childrenPlan = childrenPlan;
    }

    public String getReligion() {
        return religion;
    }

    public void setReligion(String religion) {
        this.religion = religion;
    }

    public String getPolitics() {
        return politics;
    }

    public void setPolitics(String politics) {
        this.politics = politics;
    }

    public String getDrinking() {
        return drinking;
    }

    public void setDrinking(String drinking) {
        this.drinking = drinking;
    }

    public String getSmoking() {
        return smoking;
    }

    public void setSmoking(String smoking) {
        this.smoking = smoking;
    }
}

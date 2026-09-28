package com.bondcircle.dto;

import com.bondcircle.entity.UserProfile;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ProfileResponse {

    private Long id;
    private String gender;
    private String orientation;
    private String connectionIntention;
    private String relationshipStyle;
    private List<String> interests;
    private Integer age;
    private String city;
    private String bio;
    private List<String> datingPreferences;
    private String childrenPlan;
    private String religion;
    private String politics;
    private String drinking;
    private String smoking;
    private LocalDateTime updatedAt;

    public ProfileResponse() {
    }

    public ProfileResponse(Long id, String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests, LocalDateTime updatedAt) {
        this.id = id;
        this.gender = gender;
        this.orientation = orientation;
        this.connectionIntention = connectionIntention;
        this.relationshipStyle = relationshipStyle;
        this.interests = interests != null ? new ArrayList<>(interests) : new ArrayList<>();
        this.updatedAt = updatedAt;
    }

    public ProfileResponse(Long id, String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests,
                           Integer age, String city, String bio, List<String> datingPreferences, String childrenPlan,
                           String religion, String politics, String drinking, String smoking, LocalDateTime updatedAt) {
        this.id = id;
        this.gender = gender;
        this.orientation = orientation;
        this.connectionIntention = connectionIntention;
        this.relationshipStyle = relationshipStyle;
        this.interests = interests != null ? new ArrayList<>(interests) : new ArrayList<>();
        this.age = age;
        this.city = city;
        this.bio = bio;
        this.datingPreferences = datingPreferences != null ? new ArrayList<>(datingPreferences) : new ArrayList<>();
        this.childrenPlan = childrenPlan;
        this.religion = religion;
        this.politics = politics;
        this.drinking = drinking;
        this.smoking = smoking;
        this.updatedAt = updatedAt;
    }

    public static ProfileResponse fromEntity(UserProfile profile) {
        if (profile == null) {
            return null;
        }
        return new ProfileResponse(
                profile.getId(),
                profile.getGender(),
                profile.getOrientation(),
                profile.getConnectionIntention(),
                profile.getRelationshipStyle(),
                profile.getInterests(),
                profile.getAge(),
                profile.getCity(),
                profile.getBio(),
                profile.getDatingPreferences(),
                profile.getChildrenPlan(),
                profile.getReligion(),
                profile.getPolitics(),
                profile.getDrinking(),
                profile.getSmoking(),
                profile.getUpdatedAt()
        );
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

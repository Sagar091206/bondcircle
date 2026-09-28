package com.bondcircle.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "user_profiles")
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    @org.hibernate.annotations.OnDelete(action = org.hibernate.annotations.OnDeleteAction.CASCADE)
    private User user;

    @Column(name = "gender", nullable = false)
    private String gender;

    @Column(name = "orientation", nullable = false)
    private String orientation;

    @Column(name = "connection_intention", nullable = false)
    private String connectionIntention;

    @Column(name = "relationship_style", nullable = false)
    private String relationshipStyle;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(
            name = "user_profile_interests",
            joinColumns = @JoinColumn(name = "profile_id")
    )
    @Column(name = "interest", nullable = false)
    @org.hibernate.annotations.Fetch(org.hibernate.annotations.FetchMode.SUBSELECT)
    private List<String> interests = new ArrayList<>();

    @Column(name = "age")
    private Integer age;

    @Column(name = "city")
    private String city;

    @Column(name = "bio", length = 1000)
    private String bio;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(
            name = "user_profile_dating_preferences",
            joinColumns = @JoinColumn(name = "profile_id")
    )
    @Column(name = "dating_preference", nullable = false)
    @org.hibernate.annotations.Fetch(org.hibernate.annotations.FetchMode.SUBSELECT)
    private List<String> datingPreferences = new ArrayList<>();

    @Column(name = "children_plan")
    private String childrenPlan;

    @Column(name = "religion")
    private String religion;

    @Column(name = "politics")
    private String politics;

    @Column(name = "drinking")
    private String drinking;

    @Column(name = "smoking")
    private String smoking;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public UserProfile() {
    }

    public UserProfile(User user) {
        this.user = user;
    }

    public UserProfile(User user, String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests) {
        this.user = user;
        this.gender = gender;
        this.orientation = orientation;
        this.connectionIntention = connectionIntention;
        this.relationshipStyle = relationshipStyle;
        this.interests = interests != null ? new ArrayList<>(interests) : new ArrayList<>();
    }

    public UserProfile(User user, String gender, String orientation, String connectionIntention, String relationshipStyle, List<String> interests,
                       Integer age, String city, String bio, List<String> datingPreferences, String childrenPlan,
                       String religion, String politics, String drinking, String smoking) {
        this.user = user;
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
    }

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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
        this.interests = interests != null ? new ArrayList<>(interests) : new ArrayList<>();
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
        this.datingPreferences = datingPreferences != null ? new ArrayList<>(datingPreferences) : new ArrayList<>();
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

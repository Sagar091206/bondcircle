package com.bondcircle;

import com.bondcircle.dto.LoginRequest;
import com.bondcircle.dto.ProfileRequest;
import com.bondcircle.entity.EmailVerification;
import com.bondcircle.entity.User;
import com.bondcircle.entity.UserProfile;
import com.bondcircle.repository.EmailVerificationRepository;
import com.bondcircle.repository.UserProfileRepository;
import com.bondcircle.repository.UserRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDateTime;
import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class ProfileRealFlowTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserProfileRepository userProfileRepository;

    @Autowired
    private com.bondcircle.repository.UserCircleRepository userCircleRepository;

    @Autowired
    private EmailVerificationRepository emailVerificationRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private static final String TEST_EMAIL = "realuser@bondcircle.com";
    private static final String TEST_PASSWORD = "StrongPassword123!";

    @BeforeEach
    void setUp() {
        userCircleRepository.deleteAll();
        userProfileRepository.deleteAll();
        userRepository.deleteAll();
        emailVerificationRepository.deleteAll();

        // Create verified user
        User user = new User("Sagar Kewat", TEST_EMAIL, passwordEncoder.encode(TEST_PASSWORD));
        user.setEmailVerified(true);
        userRepository.save(user);
    }

    @Test
    @DisplayName("Test real complete flow: Sign In -> Profile Setup -> Enter all biodata & lifestyle -> Save -> Verify in PostgreSQL -> Restart -> Sign In again -> Retrieve Profile -> Confirm all fields -> Select Circles -> Save Circles -> Restart -> Confirm Circles retrieved")
    void testRealEndToEndProfileFlow() throws Exception {
        // Step 1: Sign In
        LoginRequest loginRequest = new LoginRequest(TEST_EMAIL, TEST_PASSWORD);
        MvcResult loginResult = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token", notNullValue()))
                .andReturn();

        JsonNode loginJson = objectMapper.readTree(loginResult.getResponse().getContentAsString());
        String jwtToken = loginJson.get("token").asText();
        assertNotNull(jwtToken);
        assertFalse(jwtToken.isEmpty());

        // Step 2: Profile Setup - Enter all fields
        ProfileRequest profileRequest = new ProfileRequest(
                "Woman",
                "Queer",
                "Long-term relationship",
                "Monogamy",
                List.of("Coffee", "Books", "Fitness"),
                26,
                "Kolkata",
                "Passionate about storytelling, art, and quiet Sunday mornings.",
                List.of("Men", "Nonbinary people"),
                "Open to children",
                "Spiritual",
                "Moderate",
                "Socially",
                "Never"
        );

        // Step 3: Save to Spring Boot API
        mockMvc.perform(put("/api/profile/me")
                        .header("Authorization", "Bearer " + jwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(profileRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.gender", is("Woman")))
                .andExpect(jsonPath("$.orientation", is("Queer")))
                .andExpect(jsonPath("$.connectionIntention", is("Long-term relationship")))
                .andExpect(jsonPath("$.relationshipStyle", is("Monogamy")))
                .andExpect(jsonPath("$.interests", containsInAnyOrder("Coffee", "Books", "Fitness")))
                .andExpect(jsonPath("$.age", is(26)))
                .andExpect(jsonPath("$.city", is("Kolkata")))
                .andExpect(jsonPath("$.bio", is("Passionate about storytelling, art, and quiet Sunday mornings.")))
                .andExpect(jsonPath("$.datingPreferences", containsInAnyOrder("Men", "Nonbinary people")))
                .andExpect(jsonPath("$.childrenPlan", is("Open to children")))
                .andExpect(jsonPath("$.religion", is("Spiritual")))
                .andExpect(jsonPath("$.politics", is("Moderate")))
                .andExpect(jsonPath("$.drinking", is("Socially")))
                .andExpect(jsonPath("$.smoking", is("Never")));

        // Step 4: Verify data exists in PostgreSQL
        User persistentUser = userRepository.findByEmail(TEST_EMAIL).orElseThrow();
        UserProfile persistentProfile = userProfileRepository.findByUserId(persistentUser.getId()).orElse(null);
        assertNotNull(persistentProfile, "Profile must be saved in PostgreSQL");
        assertEquals("Woman", persistentProfile.getGender());
        assertEquals("Queer", persistentProfile.getOrientation());
        assertEquals("Long-term relationship", persistentProfile.getConnectionIntention());
        assertEquals("Monogamy", persistentProfile.getRelationshipStyle());
        assertEquals(3, persistentProfile.getInterests().size());
        assertTrue(persistentProfile.getInterests().containsAll(List.of("Coffee", "Books", "Fitness")));
        assertEquals(26, persistentProfile.getAge());
        assertEquals("Kolkata", persistentProfile.getCity());
        assertEquals("Passionate about storytelling, art, and quiet Sunday mornings.", persistentProfile.getBio());
        assertEquals(2, persistentProfile.getDatingPreferences().size());
        assertTrue(persistentProfile.getDatingPreferences().containsAll(List.of("Men", "Nonbinary people")));
        assertEquals("Open to children", persistentProfile.getChildrenPlan());
        assertEquals("Spiritual", persistentProfile.getReligion());
        assertEquals("Moderate", persistentProfile.getPolitics());
        assertEquals("Socially", persistentProfile.getDrinking());
        assertEquals("Never", persistentProfile.getSmoking());

        // Step 5: Restart / reload app (discard old token, simulate app restart)
        jwtToken = null;

        // Step 6: Sign In again
        MvcResult reLoginResult = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token", notNullValue()))
                .andReturn();

        JsonNode reLoginJson = objectMapper.readTree(reLoginResult.getResponse().getContentAsString());
        String newJwtToken = reLoginJson.get("token").asText();
        assertNotNull(newJwtToken);

        // Step 7 & 8: Retrieve profile & Confirm all fields are still present
        mockMvc.perform(get("/api/profile/me")
                        .header("Authorization", "Bearer " + newJwtToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.gender", is("Woman")))
                .andExpect(jsonPath("$.orientation", is("Queer")))
                .andExpect(jsonPath("$.connectionIntention", is("Long-term relationship")))
                .andExpect(jsonPath("$.relationshipStyle", is("Monogamy")))
                .andExpect(jsonPath("$.interests", hasSize(3)))
                .andExpect(jsonPath("$.interests", containsInAnyOrder("Coffee", "Books", "Fitness")))
                .andExpect(jsonPath("$.age", is(26)))
                .andExpect(jsonPath("$.city", is("Kolkata")))
                .andExpect(jsonPath("$.bio", is("Passionate about storytelling, art, and quiet Sunday mornings.")))
                .andExpect(jsonPath("$.datingPreferences", containsInAnyOrder("Men", "Nonbinary people")))
                .andExpect(jsonPath("$.childrenPlan", is("Open to children")))
                .andExpect(jsonPath("$.religion", is("Spiritual")))
                .andExpect(jsonPath("$.politics", is("Moderate")))
                .andExpect(jsonPath("$.drinking", is("Socially")))
                .andExpect(jsonPath("$.smoking", is("Never")));

        // Step 9: Interest Circles - Select circles & Save
        com.bondcircle.dto.UpdateCirclesRequest circlesRequest = new com.bondcircle.dto.UpdateCirclesRequest(
                List.of("Coffee Explorers", "Readers & Stories", "Weekend Trekkers")
        );
        mockMvc.perform(put("/api/circles/me")
                        .header("Authorization", "Bearer " + newJwtToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(circlesRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(3)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Readers & Stories", "Weekend Trekkers")));

        // Step 10: Verify Circle memberships in PostgreSQL
        assertEquals(3, userCircleRepository.findByUserId(persistentUser.getId()).size());

        // Step 11: Restart app & Sign In again with third fresh token
        MvcResult thirdLoginResult = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();
        String thirdToken = objectMapper.readTree(thirdLoginResult.getResponse().getContentAsString()).get("token").asText();

        // Step 12: Confirm circles retrieved on reload
        mockMvc.perform(get("/api/circles/me")
                        .header("Authorization", "Bearer " + thirdToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.circles", hasSize(3)))
                .andExpect(jsonPath("$.circles", containsInAnyOrder("Coffee Explorers", "Readers & Stories", "Weekend Trekkers")));
    }
}

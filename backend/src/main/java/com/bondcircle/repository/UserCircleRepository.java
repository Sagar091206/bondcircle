package com.bondcircle.repository;

import com.bondcircle.entity.UserCircle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserCircleRepository extends JpaRepository<UserCircle, Long> {

    List<UserCircle> findByUserId(Long userId);

    List<UserCircle> findByUserEmail(String email);

    Optional<UserCircle> findByUserIdAndCircleId(Long userId, Long circleId);

    boolean existsByUserIdAndCircleId(Long userId, Long circleId);

    void deleteByUserId(Long userId);

    void deleteByUserIdAndCircleId(Long userId, Long circleId);
}

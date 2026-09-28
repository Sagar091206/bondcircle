package com.bondcircle.repository;

import com.bondcircle.entity.Circle;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface CircleRepository extends JpaRepository<Circle, Long> {

    Optional<Circle> findByName(String name);

    Optional<Circle> findByNameIgnoreCase(String name);

    boolean existsByNameIgnoreCase(String name);
}

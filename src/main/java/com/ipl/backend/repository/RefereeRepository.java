package com.ipl.backend.repository;

import com.ipl.backend.entity.Referee;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RefereeRepository extends JpaRepository<Referee, Long> {
}

package com.ipl.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ipl.backend.entity.Team;

public interface TeamRepository extends JpaRepository<Team, Long> {

	
}

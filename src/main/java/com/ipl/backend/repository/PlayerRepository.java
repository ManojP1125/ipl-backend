package com.ipl.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ipl.backend.entity.Player;

public interface PlayerRepository extends JpaRepository<Player, Long> {
}

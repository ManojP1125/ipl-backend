package com.ipl.backend.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.ipl.backend.entity.Player;
import com.ipl.backend.repository.PlayerRepository;

@Service
public class PlayerService {
	private final PlayerRepository playerRepository;

	public PlayerService(PlayerRepository playerRepository) {
		this.playerRepository = playerRepository;
	}

	public List<Player> getAllPlayers() {
		return playerRepository.findAll();
	}

	public Player savePlayer(Player player) {
		return playerRepository.save(player);
	}

	public void deletePlayer(Long id) {
		playerRepository.deleteById(id);
	}

}
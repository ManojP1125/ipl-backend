package com.ipl.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ipl.backend.entity.Player;
import com.ipl.backend.service.PlayerService;

@RestController
@RequestMapping("/api/players")
@CrossOrigin
public class PlayerController {

	private final PlayerService playerService;

	public PlayerController(PlayerService playerService) {
		this.playerService = playerService;
	}

	@GetMapping
	public List<Player> getAllPlayers() {
		return playerService.getAllPlayers();
	}

	@PostMapping
	public Player savePlayer(@RequestBody Player player) {
		return playerService.savePlayer(player);
	}

	@DeleteMapping("/{id}")
	public void deletePlayer(@PathVariable Long id) {
		playerService.deletePlayer(id);
	}

}

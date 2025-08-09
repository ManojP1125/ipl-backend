package com.ipl.backend.entity;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "match_players")
@IdClass(MatchPlayerId.class)
public class MatchPlayer {
    @Id
    @ManyToOne
    @JoinColumn(name = "match_id")
    private Match match;

    @Id
    @ManyToOne
    @JoinColumn(name = "player_id")
    private Player player;

    @ManyToOne
    @JoinColumn(name = "team_id")
    private Team team;

    @Column(name = "role_in_match", length = 50)
    private String roleInMatch; // STARTING, SUB

    // getters and setters
}

class MatchPlayerId implements Serializable {
    private Long match;
    private Long player;

    // equals() and hashCode()
}

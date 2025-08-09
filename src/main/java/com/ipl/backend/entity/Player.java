package com.ipl.backend.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "players")
public class Player {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", length = 100)
    private String lastName;

    @Column(name = "full_name", length = 200)
    private String fullName;

    @Column(length = 100)
    private String nationality;

    @Column(name = "player_type", length = 50)
    private String playerType; // BATSMAN, BOWLER, ALLROUNDER, WICKETKEEPER

    @Column(name = "batting_style", length = 100)
    private String battingStyle;

    @Column(name = "bowling_style", length = 100)
    private String bowlingStyle;

    private Integer matches = 0;
    private Integer innings = 0;
    private Integer runs = 0;
    private Integer wickets = 0;
    private Integer fifties = 0;
    private Integer hundreds = 0;

    @Column(name = "strike_rate", precision = 6, scale = 2)
    private BigDecimal strikeRate;

    @Column(precision = 6, scale = 2)
    private BigDecimal average;

    @Column(name = "photo_url", columnDefinition = "TEXT")
    private String photoUrl;

    @ManyToOne
    @JoinColumn(name = "team_id")
    private Team team;

    // getters and setters
}

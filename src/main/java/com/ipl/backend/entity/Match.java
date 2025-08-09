package com.ipl.backend.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "matches")
public class Match {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "scheduled_at", nullable = false)
    private LocalDateTime scheduledAt;

    @ManyToOne
    @JoinColumn(name = "stadium_id")
    private Stadium stadium;

    @ManyToOne
    @JoinColumn(name = "team_a_id")
    private Team teamA;

    @ManyToOne
    @JoinColumn(name = "team_b_id")
    private Team teamB;

    @ManyToOne
    @JoinColumn(name = "umpire1_id")
    private Umpire umpire1;

    @ManyToOne
    @JoinColumn(name = "umpire2_id")
    private Umpire umpire2;

    @ManyToOne
    @JoinColumn(name = "referee_id")
    private Referee referee;

    @Column(length = 50)
    private String status = "SCHEDULED";

    @Column(columnDefinition = "TEXT")
    private String result;

    // getters and setters
}

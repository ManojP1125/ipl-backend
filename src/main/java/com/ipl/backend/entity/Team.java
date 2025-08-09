package com.ipl.backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "teams")
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String name;

    @Column(name = "short_name", length = 20)
    private String shortName;

    @Column(name = "logo_url", columnDefinition = "TEXT")
    private String logoUrl;

    @Column(length = 200)
    private String owner;

    @ManyToOne
    @JoinColumn(name = "home_stadium_id")
    private Stadium homeStadium;

    @Column(length = 100)
    private String city;

    // getters and setters
}

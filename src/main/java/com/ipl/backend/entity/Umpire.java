package com.ipl.backend.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "umpires")
public class Umpire {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(length = 100)
    private String nationality;

    @Column(name = "experience_years")
    private Integer experienceYears;

    @Column(name = "photo_url", columnDefinition = "TEXT")
    private String photoUrl;

    // getters and setters
}

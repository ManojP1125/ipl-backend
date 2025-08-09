package com.ipl.backend.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "stadiums")
public class Stadium {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 200)
    private String name;

    @Column(length = 100)
    private String city;

    @Column(length = 100)
    private String state;

    @Column(name = "seating_capacity")
    private Integer seatingCapacity;

    @Column(name = "inauguration_date")
    private LocalDate inaugurationDate;

    @Column(name = "photo_url", columnDefinition = "TEXT")
    private String photoUrl;

    // getters and setters
}

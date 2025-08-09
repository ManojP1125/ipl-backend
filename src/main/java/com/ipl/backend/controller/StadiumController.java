package com.ipl.backend.controller;

import com.ipl.backend.entity.Stadium;
import com.ipl.backend.service.StadiumService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stadiums")
@CrossOrigin
public class StadiumController {

    private final StadiumService stadiumService;

    public StadiumController(StadiumService stadiumService) {
        this.stadiumService = stadiumService;
    }

    @GetMapping
    public List<Stadium> getAllStadiums() {
        return stadiumService.getAllStadiums();
    }

    @PostMapping
    public Stadium saveStadium(@RequestBody Stadium stadium) {
        return stadiumService.saveStadium(stadium);
    }

    @DeleteMapping("/{id}")
    public void deleteStadium(@PathVariable Long id) {
        stadiumService.deleteStadium(id);
    }
}

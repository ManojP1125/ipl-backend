package com.ipl.backend.service;

import com.ipl.backend.entity.Stadium;
import com.ipl.backend.repository.StadiumRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StadiumService {
    private final StadiumRepository stadiumRepository;

    public StadiumService(StadiumRepository stadiumRepository) {
        this.stadiumRepository = stadiumRepository;
    }

    public List<Stadium> getAllStadiums() {
        return stadiumRepository.findAll();
    }

    public Stadium saveStadium(Stadium stadium) {
        return stadiumRepository.save(stadium);
    }

    public void deleteStadium(Long id) {
        stadiumRepository.deleteById(id);
    }
}

package com.ipl.backend.controller;

import com.ipl.backend.entity.User;
import com.ipl.backend.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestParam String username, @RequestParam String password) {
        String token = authService.login(username, password);
        return ResponseEntity.ok().body("{\"token\": \"" + token + "\"}");
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody User user) {
        authService.register(user);
        return ResponseEntity.ok("User registered successfully");
    }
}

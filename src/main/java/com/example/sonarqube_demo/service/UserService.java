package com.example.sonarqube_demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.sonarqube_demo.model.User;
import com.example.sonarqube_demo.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    
    public Optional<User> getUserById(Long id) {
        return userRepository.findById(id);
    }
    
    public User createUser(User user) {
        // Code volontairement problématique pour démo SonarQube
        // String password = "hardcoded_password"; // Security Hotspot
        
        if (user.getEmail() == null) { // Peut être simplifié
            throw new IllegalArgumentException("Email cannot be null");
        }
        
        return userRepository.save(user);
    }
    
    public User updateUser(Long id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        user.setName(userDetails.getName());
        user.setEmail(userDetails.getEmail());
        user.setPhone(userDetails.getPhone());
        
        return userRepository.save(user);
    }
    
    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
    
    // Méthode avec code dupliqué (Code Smell)
    public String formatUserInfo(User user) {
        String info = "Name: " + user.getName();
        info = info + ", Email: " + user.getEmail();
        return info;
    }
    
    // Autre méthode avec code similaire
    public String formatUserDetails(User user) {
        String details = "Name: " + user.getName();
        details = details + ", Email: " + user.getEmail();
        return details;
    }
}
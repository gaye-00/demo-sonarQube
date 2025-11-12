package com.example.sonarqube_demo;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import com.example.sonarqube_demo.model.User;
import com.example.sonarqube_demo.repository.UserRepository;
import com.example.sonarqube_demo.service.UserService;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class UserServiceTest {
    
    @Mock
    private UserRepository userRepository;
    
    @InjectMocks
    private UserService userService;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }
    
    @Test
    void getAllUsers_ShouldReturnListOfUsers() {
        // Arrange
        User user1 = new User(1L, "John Doe", "john@example.com", "123456789");
        User user2 = new User(2L, "Jane Doe", "jane@example.com", "987654321");
        when(userRepository.findAll()).thenReturn(Arrays.asList(user1, user2));
        
        // Act
        List<User> users = userService.getAllUsers();
        
        // Assert
        assertEquals(2, users.size());
        verify(userRepository, times(1)).findAll();
    }
    
    @Test
    void getUserById_ShouldReturnUser_WhenUserExists() {
        // Arrange
        User user = new User(1L, "John Doe", "john@example.com", "123456789");
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        
        // Act
        Optional<User> foundUser = userService.getUserById(1L);
        
        // Assert
        assertTrue(foundUser.isPresent());
        assertEquals("John Doe", foundUser.get().getName());
    }
    
    @Test
    void createUser_ShouldSaveAndReturnUser() {
        // Arrange
        User user = new User(null, "John Doe", "john@example.com", "123456789");
        User savedUser = new User(1L, "John Doe", "john@example.com", "123456789");
        when(userRepository.save(any(User.class))).thenReturn(savedUser);
        
        // Act
        User result = userService.createUser(user);
        
        // Assert
        assertNotNull(result.getId());
        assertEquals("John Doe", result.getName());
        verify(userRepository, times(1)).save(user);
    }
    
    @Test
    void createUser_ShouldThrowException_WhenEmailIsNull() {
        // Arrange
        User user = new User(null, "John Doe", null, "123456789");
        
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> userService.createUser(user));
    }
}
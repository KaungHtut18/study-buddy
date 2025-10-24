package com.mfu.studybuddy.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.mfu.studybuddy.service.UserService;

@Component
public class DataInitializer implements CommandLineRunner {
    
    @Autowired
    private UserService userService;
    
    @Override
    public void run(String... args) throws Exception {
        // Check if users already exist to avoid duplicates
        if (userService.getUserByEmail("john@example.com").isEmpty()) {
            // Create dummy users with simple password "password123"
            userService.createDummyUser("john@example.com", "john_doe", "password123");
            userService.createDummyUser("jane@example.com", "jane_smith", "password123");
            userService.createDummyUser("bob@example.com", "bob_wilson", "password123");
            userService.createDummyUser("alice@example.com", "alice_brown", "password123");
            userService.createDummyUser("charlie@example.com", "charlie_davis", "password123");
            
            System.out.println("Dummy users created successfully!");

            userService.addInterestedUser(1L, 2L);
            userService.addInterestedUser(2L, 1L);
            userService.addInterestedUser(3L, 1L);
            userService.addInterestedUser(4L, 1L);

            System.out.println("created dummy matches");
        } else {
            System.out.println("Users already exist, skipping dummy data creation.");
        }
    }
}

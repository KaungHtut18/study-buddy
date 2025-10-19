package com.mfu.studybuddy.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mfu.studybuddy.DTO.ApiResponse;
import com.mfu.studybuddy.model.User;
import com.mfu.studybuddy.service.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
@RequestMapping("/api")
public class CoreController {

    private static final Logger logger = LoggerFactory.getLogger(CoreController.class);

    @Autowired
    UserService userService;

    @PatchMapping("/interested-users")
    public ResponseEntity<?> addInterestedUser(@RequestHeader("User-ID") Long interestedUserId, 
    @RequestBody Map<String,Long> data)
    {
        logger.info("Received request to add interested user. InterestedUserId: {}, RequestBody: {}", 
                   interestedUserId, data);
        
        Long targetUserId = data.get("targetUserId");
        logger.info("Extracted targetUserId: {}", targetUserId);

        //check if the user with id exists
        Optional<User> userOpt = userService.getUserById(targetUserId);
        if (userOpt.isEmpty())
        {
            logger.warn("Target user with ID {} does not exist", targetUserId);
            ApiResponse<String> response = new ApiResponse<>();
            response.setStatus("error");
            response.setData("User does not exist");

            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }

        logger.info("Target user found. Processing interest from user {} to user {}", 
                   interestedUserId, targetUserId);
        
        try {
            userService.addInterestedUser(targetUserId, interestedUserId);
            logger.info("Successfully processed interest from user {} to user {}", 
                       interestedUserId, targetUserId);
            
            ApiResponse<String> response = new ApiResponse<>();
            response.setStatus("success");
            response.setData(null);
            return new ResponseEntity<>(response, HttpStatus.OK);
            
        } catch (Exception e) {
            logger.error("Error processing interest from user {} to user {}: {}", 
                        interestedUserId, targetUserId, e.getMessage(), e);
            
            ApiResponse<String> response = new ApiResponse<>();
            response.setStatus("error");
            response.setData("Failed to process request");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/users")
    public ResponseEntity<?> getUsers(@RequestParam(required = false) Long lastId, 
    @RequestParam(defaultValue = "5") int count) {
        logger.info("Received request to get users. LastId: {}, Count: {}", lastId, count);
        
        try {
            List<User> users = userService.getUsersPaginated(lastId, count);
            logger.info("Successfully retrieved {} users", users.size());
            
            ApiResponse<List<User>> response = new ApiResponse<>();
            response.setStatus("success");
            response.setData(users);
            
            return new ResponseEntity<>(response, HttpStatus.OK);
            
        } catch (Exception e) {
            logger.error("Error retrieving users: {}", e.getMessage(), e);
            
            ApiResponse<String> response = new ApiResponse<>();
            response.setStatus("error");
            response.setData("Failed to retrieve users");
            
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
}

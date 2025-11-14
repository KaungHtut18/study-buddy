package com.mfu.studybuddy.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

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
import com.mfu.studybuddy.DTO.UserDto;
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

    @GetMapping("/matched-users")
    public ResponseEntity<?> getMethodName(@RequestParam Long id) {
        ApiResponse<List<User>> response = new ApiResponse<>();
        List<User> matchedUsers = userService.getMatchedUsers(id);
        response.setData(matchedUsers);
        response.setStatus("success");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
    
    @GetMapping("/interested-users")
    public ResponseEntity<?> getInterestedUsers(@RequestParam Long id) {
        ApiResponse<List<User>> response = new ApiResponse<>();
        List<User> interstedUsers = userService.getInterestedUsers(id);
        response.setData(interstedUsers);
        response.setStatus("Success");
        return new ResponseEntity<>(response,HttpStatus.OK);
    }
    

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
    public ResponseEntity<?> getUsers(@RequestHeader("User-Id") Long id,@RequestParam(required = false) Long lastId, 
    @RequestParam(defaultValue = "5") int count) {
        logger.info("Received request to get users. LastId: {}, Count: {}", lastId, count);
        
        try {
            List<User> users = userService.getUsersPaginated(lastId, count,id);
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
    
    @PatchMapping("/users")
    public ResponseEntity<?> updateUser(
        @RequestHeader("User-ID") Long userId,
        @RequestBody Map<String, Object> updates
    ) {
        logger.info("Received request to update user. UserId: {}, Updates: {}", userId, updates);
        ApiResponse<?> response = new ApiResponse<>();

        try {
            Optional<User> userOpt = userService.getUserById(userId);
            if (userOpt.isEmpty()) {
                logger.warn("User with ID {} does not exist", userId);
                response.setStatus("error: User does not exist");
                response.setData(null);
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
            }

            User user = userOpt.get();

            if (updates.containsKey("email")) {
                Object v = updates.get("email");
                if (v == null || v instanceof String) user.setEmail((String) v);
            }
            if (updates.containsKey("userName")) {
                Object v = updates.get("userName");
                if (v == null || v instanceof String) user.setUserName((String) v);
            }
            if (updates.containsKey("description")) {
                Object v = updates.get("description");
                if (v == null || v instanceof String) user.setDescription((String) v);
            }
            if (updates.containsKey("skills")) {
                Object v = updates.get("skills");
                if (v instanceof List<?>) {
                    @SuppressWarnings("unchecked")
                    List<Object> raw = (List<Object>) v;
                    user.setSkills(raw.stream().map(String::valueOf).collect(Collectors.toList()));
                }
            }
            if (updates.containsKey("interests")) {
                Object v = updates.get("interests");
                if (v instanceof List<?>) {
                    @SuppressWarnings("unchecked")
                    List<Object> raw = (List<Object>) v;
                    user.setInterests(raw.stream().map(String::valueOf).collect(Collectors.toList()));
                }
            }

            // Persist changes
            // Assumes userService has a saveUser(User user) method.
            userService.saveUser(user);

            logger.info("Successfully updated user {}", userId);
            ApiResponse<User> ok = new ApiResponse<>();
            ok.setStatus("success");
            ok.setData(user);
            return new ResponseEntity<>(ok, HttpStatus.OK);

        } catch (Exception e) {
            logger.error("Error updating user {}: {}", userId, e.getMessage(), e);
            response.setStatus("error");
            response.setData(null);
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}

package com.mfu.studybuddy.controller;
import com.mfu.studybuddy.service.UserService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mfu.studybuddy.model.User;


@RestController
@RequestMapping("/security")
public class SecurityContoller {

    private final UserService userService;

    SecurityContoller(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        System.out.println(user.getPassword());
        return new ResponseEntity<User>(
            userService.registerUser(user.getEmail(), user.getUserName(), user.getPassword()
            ), HttpStatus.CREATED);
    }
    
}

package com.mfu.studybuddy.controller;
import com.mfu.studybuddy.service.UserService;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mfu.studybuddy.DTO.ApiResponse;
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
        User savedUser = userService.registerUser(user.getEmail(), user.getUserName(), user.getPassword());
        ApiResponse<User> response = new ApiResponse<User>();
        response.setStatus("success");
        response.setData(savedUser);
        return new ResponseEntity<ApiResponse<User>>(
            response
            , HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody Map<String,String> credentials)
    {
        String email = credentials.get("email");
        String password = credentials.get("password");
        //check if both fields are present
        if (email == null || password == null)
        {
            ApiResponse<String> response = new ApiResponse<>();
            response.setStatus("error");
            response.setData("Missing credentials");
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }

        boolean isUserValid = userService.validateUser(email,password);
        if(isUserValid)
        {
            User user = userService.getUserByEmail(email).get();
            ApiResponse<User> response = new ApiResponse<>();
            response.setStatus("success");
            response.setData(user);

            return new ResponseEntity<>(response, HttpStatus.OK);
        }

        return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
    }
}

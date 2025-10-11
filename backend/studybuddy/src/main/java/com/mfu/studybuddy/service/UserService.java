package com.mfu.studybuddy.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mfu.studybuddy.model.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.mfu.studybuddy.repository.UserRepository;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User registerUser(String email,String username, String password){
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
        String encryptedPassword = encoder.encode(password);

        return userRepository.save(new User(email,username,encryptedPassword)) ; 
    }

    public boolean validateUser(String email, String password)
    {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
        try{
            Optional<User> userOpt = userRepository.findByEmail(email);
            if(userOpt.isPresent())
            {
                User user = userOpt.get();
                return encoder.matches(password, user.getPassword());
            }
            return false;
        }catch(Exception e)
        {
            return false;
        }
        
    }
}

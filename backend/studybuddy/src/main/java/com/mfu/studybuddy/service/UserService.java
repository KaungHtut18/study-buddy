package com.mfu.studybuddy.service;

import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Pageable;

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

    public List<User> getMatchedUsers(Long id)
    {
        User user = userRepository.findById(id).get();
        List<User> matchedUsers = user.getMatchedUsers();
        return matchedUsers;
    }

    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public Optional<User> getUserById(Long id){
        return userRepository.findById(id);
    }

    @Transactional
    public void addInterestedUser(Long targetUserId, Long interestedUserId)
    {
       
        User targetUser = userRepository.findById(targetUserId).get();
        User interestedUser = userRepository.findById(interestedUserId).get();
         //Check if the targetUser already have the interestedUser in their interested list
        boolean isAlreadyIntersted = userRepository.existsByIdAndInterestedUsers_Id(targetUserId, interestedUserId);
        if (isAlreadyIntersted){
            //TRUE: remove the interestedUser from interested list and put it in matched list for the target user
            //skip putting target user in interested list and  put it in matched list of interested user directly
            targetUser.getInterestedUsers().removeIf(user -> user.getId().equals(interestedUserId));

            targetUser.getMatchedUsers().add(interestedUser);
            interestedUser.getMatchedUsers().add(targetUser);
        }
        else{
            //FALSE:
            interestedUser.getInterestedUsers().add(targetUser);
        }
        // Update both users
        userRepository.save(targetUser);
        userRepository.save(interestedUser);       
    }

    public List<User> getUsersPaginated(Long lastId, int count) {
        Pageable pageable = Pageable.ofSize(count);
        
        // Debug: Log total user count
        long totalUsers = userRepository.count();
        System.out.println("Total users in database: " + totalUsers);
        System.out.println("Requested count: " + count + ", lastId: " + lastId);
        
        List<User> result;
        if (lastId == null) {
            // First request - get first 'count' users ordered by ID
            result = userRepository.findAllByOrderByIdAsc(pageable);
        } else {
            // Subsequent requests - get 'count' users with ID greater than lastId
            result = userRepository.findByIdGreaterThanOrderByIdAsc(lastId, pageable);
        }
        
        System.out.println("Returned " + result.size() + " users");
        for (User user : result) {
            System.out.println("User ID: " + user.getId() + ", Username: " + user.getUserName());
        }
        return result;
    }

    // Method for creating dummy users with known passwords
    public User createDummyUser(String email, String username, String plainPassword) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);
        String encryptedPassword = encoder.encode(plainPassword);
        
        User user = new User(email, username, encryptedPassword);
        return userRepository.save(user);
    }
}

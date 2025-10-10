package com.mfu.studybuddy.model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class User{
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String email;
    private String password;
    private String description;

    @ElementCollection
    private List<String> skills = new ArrayList<>();
    
    @ElementCollection
    private List<String> interests = new ArrayList<>();
    
    @ManyToMany
    @JoinTable(
        name = "user_matches",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "matched_user_id")
    )
    private List<User> matchedUsers = new ArrayList<>();
    
    @ManyToMany
    @JoinTable(
        name = "user_interests_relation", 
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "interested_user_id")
    )
    private List<User> interestedUsers = new ArrayList<>();
}

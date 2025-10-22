package com.mfu.studybuddy.model;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.mfu.studybuddy.DTO.UserDto;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "app_user", 
    indexes ={
        @Index(name = "idx_userName", columnList = "userName"),
        @Index(name = "idx_email", columnList = "email")
    })
public class User{
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String email;
    private String userName;
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;
    private String description = "";

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

    public User(String email,String userName,String password)
    {
        this.email = email;
        this.userName = userName;
        this.password = password;
    }

    public User(String email,String userName,String password, List<String> skills, List<String> interests, String description)
    {
        this.email = email;
        this.userName = userName;
        this.password = password;
        this.skills = skills;
        this.interests = interests;
        this.description = description;
    }

    public UserDto toDto(){
        return new UserDto(this.id, this.userName,this.email);
    }

    @JsonGetter("interestedUsers")
    public List<UserDto> getInterestedUsersJson()
    {
        return this.interestedUsers.stream()
        .map(user -> user.toDto())
        .collect(Collectors.toList());
    }
    
    @JsonGetter("matchedUsers")
    public List<UserDto> getMatchedUsersJson()
    {
        return this.matchedUsers.stream()
        .map(user-> user.toDto())
        .collect(Collectors.toList());
    }

}

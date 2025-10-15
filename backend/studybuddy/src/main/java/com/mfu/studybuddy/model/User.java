package com.mfu.studybuddy.model;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

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

    @OneToMany(mappedBy = "user1", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<ChatRoom> chatRoomsAsUser1 = new ArrayList<>();
    
    @OneToMany(mappedBy = "user2", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<ChatRoom> chatRoomsAsUser2 = new ArrayList<>();

    public User(String email,String userName,String password)
    {
        this.email = email;
        this.userName = userName;
        this.password = password;
    }

}

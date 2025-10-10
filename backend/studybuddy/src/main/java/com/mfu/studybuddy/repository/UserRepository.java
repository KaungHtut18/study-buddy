package com.mfu.studybuddy.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.mfu.studybuddy.model.User;

@Repository
public interface UserRepository extends JpaRepository<User,Long>{
    
}

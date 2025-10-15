package com.mfu.studybuddy.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.mfu.studybuddy.model.ChatRoom;
import com.mfu.studybuddy.model.User;

@Repository
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long> {
    
    @Query("SELECT c FROM ChatRoom c WHERE (c.user1 = :user1 AND c.user2 = :user2) OR (c.user1 = :user2 AND c.user2 = :user1)")
    Optional<ChatRoom> findByUsers(@Param("user1") User user1, @Param("user2") User user2);
    
    @Query("SELECT c FROM ChatRoom c WHERE c.user1 = :user OR c.user2 = :user ORDER BY c.lastMessageAt DESC")
    List<ChatRoom> findByUserOrderByLastMessageAtDesc(@Param("user") User user);
}

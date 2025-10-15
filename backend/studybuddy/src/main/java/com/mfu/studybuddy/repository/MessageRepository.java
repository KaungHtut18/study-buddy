package com.mfu.studybuddy.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.mfu.studybuddy.model.ChatRoom;
import com.mfu.studybuddy.model.Message;

@Repository
public interface MessageRepository extends JpaRepository<Message, Long> {
    
    List<Message> findByChatRoomOrderBySentAtAsc(ChatRoom chatRoom);
    
    @Query("SELECT COUNT(m) FROM Message m WHERE m.chatRoom = :chatRoom AND m.sender.id != :userId AND m.isRead = false")
    Long countUnreadMessages(@Param("chatRoom") ChatRoom chatRoom, @Param("userId") Long userId);
}

package com.mfu.studybuddy.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.mfu.studybuddy.model.ChatRoom;
import com.mfu.studybuddy.model.Message;
import com.mfu.studybuddy.service.ChatService;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin(origins = "*")
public class ChatController {
    
    @Autowired
    private ChatService chatService;
    
    @PostMapping("/room")
    public ResponseEntity<ChatRoom> createOrGetChatRoom(@RequestParam Long user1Id, @RequestParam Long user2Id) {
        ChatRoom chatRoom = chatService.createOrGetChatRoom(user1Id, user2Id);
        return ResponseEntity.ok(chatRoom);
    }
    
    @GetMapping("/rooms/{userId}")
    public ResponseEntity<List<ChatRoom>> getUserChatRooms(@PathVariable Long userId) {
        List<ChatRoom> chatRooms = chatService.getUserChatRooms(userId);
        return ResponseEntity.ok(chatRooms);
    }
    
    @GetMapping("/messages/{chatRoomId}")
    public ResponseEntity<List<Message>> getChatRoomMessages(@PathVariable Long chatRoomId) {
        List<Message> messages = chatService.getChatRoomMessages(chatRoomId);
        return ResponseEntity.ok(messages);
    }
    
    @PutMapping("/messages/{messageId}/read")
    public ResponseEntity<Void> markMessageAsRead(@PathVariable Long messageId) {
        chatService.markMessageAsRead(messageId);
        return ResponseEntity.ok().build();
    }
}

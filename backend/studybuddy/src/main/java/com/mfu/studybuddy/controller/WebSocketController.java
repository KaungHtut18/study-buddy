package com.mfu.studybuddy.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.mfu.studybuddy.DTO.ChatMessageDto;
import com.mfu.studybuddy.model.Message;
import com.mfu.studybuddy.service.ChatService;

@Controller
public class WebSocketController {
    
    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    
    @Autowired
    private ChatService chatService;
    
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload ChatMessageDto chatMessage) {
        Message savedMessage = chatService.saveMessage(chatMessage);
        
        // Send to specific chat room topic
        messagingTemplate.convertAndSend("/topic/chatroom/" + chatMessage.getChatRoomId(), savedMessage);
    }
}

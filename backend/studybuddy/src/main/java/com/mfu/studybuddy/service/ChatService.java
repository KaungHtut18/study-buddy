package com.mfu.studybuddy.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mfu.studybuddy.DTO.ChatMessageDto;
import com.mfu.studybuddy.model.ChatRoom;
import com.mfu.studybuddy.model.Message;
import com.mfu.studybuddy.model.User;
import com.mfu.studybuddy.repository.ChatRoomRepository;
import com.mfu.studybuddy.repository.MessageRepository;
import com.mfu.studybuddy.repository.UserRepository;

@Service
public class ChatService {
    
    @Autowired
    private ChatRoomRepository chatRoomRepository;
    
    @Autowired
    private MessageRepository messageRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public ChatRoom createOrGetChatRoom(Long user1Id, Long user2Id) {
        User user1 = userRepository.findById(user1Id).orElseThrow();
        User user2 = userRepository.findById(user2Id).orElseThrow();
        
        Optional<ChatRoom> existingRoom = chatRoomRepository.findByUsers(user1, user2);
        
        if (existingRoom.isPresent()) {
            return existingRoom.get();
        }
        
        ChatRoom newRoom = new ChatRoom(user1, user2);
        return chatRoomRepository.save(newRoom);
    }
    
    public List<ChatRoom> getUserChatRooms(Long userId) {
        User user = userRepository.findById(userId).orElseThrow();
        return chatRoomRepository.findByUserOrderByLastMessageAtDesc(user);
    }
    
    public List<Message> getChatRoomMessages(Long chatRoomId) {
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId).orElseThrow();
        return messageRepository.findByChatRoomOrderBySentAtAsc(chatRoom);
    }
    
    public Message saveMessage(ChatMessageDto chatMessageDto) {
        ChatRoom chatRoom = chatRoomRepository.findById(chatMessageDto.getChatRoomId()).orElseThrow();
        User sender = userRepository.findById(chatMessageDto.getSenderId()).orElseThrow();
        
        Message message = new Message(chatRoom, sender, chatMessageDto.getContent());
        Message savedMessage = messageRepository.save(message);
        
        // Update last message time in chat room
        chatRoom.setLastMessageAt(LocalDateTime.now());
        chatRoomRepository.save(chatRoom);
        
        return savedMessage;
    }
    
    public void markMessageAsRead(Long messageId) {
        Message message = messageRepository.findById(messageId).orElseThrow();
        message.setRead(true);
        messageRepository.save(message);
    }
}

package com.mfu.studybuddy.DTO;

import lombok.Data;

@Data
public class ChatMessageDto {
    private Long chatRoomId;
    private Long senderId;
    private String content;
}

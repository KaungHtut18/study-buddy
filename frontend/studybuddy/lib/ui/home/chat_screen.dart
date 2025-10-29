import 'package:flutter/material.dart';
import 'package:studybuddy/ui/home/chat_interface.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatInterface(),
                  ),
                );
              },
              child: ChatListItem(
                name: 'AI Tutor',
                message: 'Hey! How can I help you today?',
                time: '9:59 PM',
                avatar: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                showPin: true,
              ),
            ),
            ChatListItem(
              name: 'Alex Johnson',
              message: 'Hey, are you free to study...',
              time: '10:30 PM',
              avatar: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.grey[600], size: 32),
              ),
            ),
            ChatListItem(
              name: 'John',
              message: 'Ok lets work on the project',
              time: '10:30 PM',
              avatar: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.grey[600], size: 32),
              ),
            ),
            ChatListItem(
              name: 'Maya',
              message: 'Can you explain this topic for me?',
              time: '10:30 PM',
              avatar: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.grey[600], size: 32),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final Widget avatar;
  final bool showPin;

  const ChatListItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.showPin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: SizedBox(width: 60, height: 60, child: avatar),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            message,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            if (showPin)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  Icons.push_pin_outlined,
                  size: 18,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

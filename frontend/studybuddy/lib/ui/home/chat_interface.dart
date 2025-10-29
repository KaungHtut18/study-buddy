import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:studybuddy/services/service_provider.dart';

class ChatInterface extends StatefulWidget {
  const ChatInterface({super.key});

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: 'AIzaSyCdvyteh9tZ9foi0ZlbnoWVR39Ch8w3bK0',
  );

  Future<String> generateResponse(
    String question,
    int wordCount,
    BuildContext bContext,
  ) async {
    final serviceProvider = Provider.of<ServiceProvider>(
      bContext,
      listen: false,
    );
    print(serviceProvider.inDetail);
    print(serviceProvider.inDetail);
    print('Word count: $wordCount');
    String prompt =
        serviceProvider.inDetail
            ? '''Act as an AI tutor to help students with their studies.For this chat, 
    please provide detailed explanations, which are not less than than $wordCount words, on various subjects. Do not include any greetings and extra words. Just focus on answering the question.
    This is the student's question: $question'''
            : '''Act as an AI tutor to help students with their studies.For this chat, 
    please provide short, clear and concise explanations, which are not more than $wordCount words, on various subjects.
    This is the student's question: $question''';
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text!;
    } catch (e) {
      return 'Error: $e';
    }
  }

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hey! How can I help you today?',
      isMe: false,
      time: '10:30 AM',
    ),
  ];

  void _sendMessage() async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text,
            isMe: true,
            time: _formatTime(DateTime.now()),
          ),
        );
      });
      scrollToBottom();
      setState(() {
        _isTyping = true;
      });
      String question = _messageController.text;
      int wordCount = serviceProvider.inDetail ? 200 : 50;
      _messageController.clear();
      String responseText = await generateResponse(
        question,
        wordCount,
        context,
      );
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: responseText,
            isMe: false,
            time: _formatTime(DateTime.now()),
          ),
        );
      });
      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tutor',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Online',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const TypingAnimation();
                }

                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        serviceProvider.setInDetail(!serviceProvider.inDetail);
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          serviceProvider.inDetail ? Colors.blue : Colors.white,
                      backgroundColor:
                          serviceProvider.inDetail
                              ? Colors.blue[50]
                              : Colors.grey[300],
                    ),
                    child: const Text('Detail'),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}

class TypingAnimation extends StatefulWidget {
  const TypingAnimation({super.key});

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.2;
        final animationValue = (_controller.value - delay) % 1.0;
        final scale =
            1.0 +
            Curves.easeOutSine.transform(
                  animationValue > 0.5 ? 1.0 - animationValue : animationValue,
                ) *
                0.4;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Transform.scale(
            scale: scale,
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Colors.grey.shade400,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 16,
            child: Icon(Icons.person, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Essential to wrap the content
              children: <Widget>[buildDot(0), buildDot(1), buildDot(2)],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.blue,
                size: 20,
              ),
            ),
          if (!message.isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  message.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: message.isMe ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                      bottomRight: Radius.circular(message.isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12, right: 12),
                  child: Text(
                    message.time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
          if (message.isMe)
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              radius: 16,
              child: const Icon(Icons.person, size: 18, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}

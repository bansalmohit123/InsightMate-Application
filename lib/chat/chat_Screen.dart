import 'package:flutter/material.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/utils.dart';

/// A model for chat messages.
class ChatMessage {
  final String sender;
  final String message;
  ChatMessage({required this.sender, required this.message});
}

/// A responsive chat screen where users can interact with the chatbot.
class ChatScreen extends StatefulWidget {
  final String sessionTitle; // Title of the session to display in the app bar
   static const String routeName = '/chat-screen';
   const ChatScreen({super.key, required this.sessionTitle});
 

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(sender: "bot", message: "Hello! How can I help you today?"),
  ];
  final TextEditingController _controller = TextEditingController();
 ChatService chatService = ChatService();
  /// Simulates sending a message by the user and a dummy response from the chatbot.
  void _sendMessage() {
    String text = _controller.text.trim();
    chatService.QueryFile(
      context: context,
      question: text,
      fileId: 3,
    );
    if (text.isNotEmpty) {
      
      setState(() {
        _messages.add(ChatMessage(sender: "user", message: text));
        // Simulated bot response for illustration.
        _messages.add(ChatMessage(
            sender: "bot", message: "This is a response from the chatbot."));
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sessionTitle),
        backgroundColor: color3,
      ),
      body: GradientBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Limit the width of the chat container on large screens (web) to keep it readable.
            double maxWidth = constraints.maxWidth < 800 ? constraints.maxWidth : 600;
            return Center(
              child: Container(
                width: maxWidth,
                child: Column(
                  children: [
                    // Chat messages list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          ChatMessage msg = _messages[index];
                          bool isUser = msg.sender == "user";
                          return Align(
                            alignment:
                                isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              constraints: BoxConstraints(maxWidth: maxWidth * 0.8),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? color1.withOpacity(0.7)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                msg.message,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Message input field and send button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: "Type your message...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send, color: color3),
                            onPressed: _sendMessage,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

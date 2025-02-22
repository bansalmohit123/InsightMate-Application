import 'package:flutter/material.dart';
import 'package:insightmate/forms/chat_service.dart';
import 'package:insightmate/providers/web.dart';
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
  final String id; // ID of the session to fetch messages from
  final String option; // Type of chatbot session
   static const String routeName = '/chat-screen';
   const ChatScreen({super.key, required this.sessionTitle,required this.id , required this.option});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(sender: "bot", message: "Hello! How can I help you today?"),
  ];
  final TextEditingController _controller = TextEditingController();
 ChatService chatService = ChatService();
 @override
  void initState() {
    super.initState();
   
    print(widget.id);
    print(widget.option); 
   
    
  }

  /// Simulates sending a message by the user and a dummy response from the chatbot.
  void _sendMessage() {
    String text = _controller.text.trim();

    if(widget.option=='Document Chatbot'){
       chatService.QueryFile(
      context: context,
      question: text,
      // webId: widget.id,
      // youtubeId:'c8365ed1-74b5-4d3f-9eb1-e1b3d355bf17',
      documentId: widget.id,
      callback: (String response) {
        setState(() {
          _messages.add(ChatMessage(sender: "bot", message: response));
        });
        _controller.clear();
      },
    );
    }
    else if(widget.option=='Webpage Extraction Chatbot'){
      chatService.queryWeb(
      context: context,
      question: text,
      webId: widget.id,
      callback : (String response) {
        setState(() {
          _messages.add(ChatMessage(sender: "bot", message: response));
        });
        _controller.clear();
      },
    );
    }
    else{
      chatService.queryYoutube(
      context: context,
      question: text,
      youtubeId: widget.id,
      callback : (String response) {
        setState(() {
          _messages.add(ChatMessage(sender: "bot", message: response));
        });
        _controller.clear();
      },
    );
    }
   
   
    if (text.isNotEmpty) {
      
      setState(() {
        _messages.add(ChatMessage(sender: "user", message: text));
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

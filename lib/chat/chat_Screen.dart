// import 'package:flutter/material.dart';
// import 'package:insightmate/forms/chat_service.dart';
// import 'package:insightmate/utils.dart';

// /// A model for chat messages.
// class ChatMessage {
//   final String sender;
//   final String message;

//   ChatMessage({required this.sender, required this.message});
// }

// /// A responsive chat screen where users can interact with the chatbot.
// class ChatScreen extends StatefulWidget {
//   final String sessionTitle; // Title of the session to display in the app bar
//   final String id; // ID of the chatbot session
//   final String option; // Type of chatbot session
//   final String sessionID; // ID for tracking chat history

//   static const String routeName = '/chat-screen';

//   const ChatScreen({
//     super.key,
//     required this.sessionTitle,
//     required this.id,
//     required this.option,
//     required this.sessionID,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<ChatMessage> _messages = [];
//   final TextEditingController _controller = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final ScrollController _scrollController = ScrollController(); // ✅ Added Scroll Controller
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     print(widget.id);
//     print(widget.option);
//     print(widget.sessionID);
//     _loadChatHistory();
//   }

//   /// ✅ Scrolls to the bottom of the chat when a new message arrives.
//   void scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   /// Loads previous messages from the database.
//   Future<void> _loadChatHistory() async {
//     List<Map<String, dynamic>> chatHistory = await _chatService.getMessages(widget.sessionID);

//     setState(() {
//       _messages = chatHistory.map((msg) {
//         return ChatMessage(sender: msg["sender"], message: msg["message"]);
//       }).toList();
//       _isLoading = false;
//     });

//     scrollToBottom(); // ✅ Scroll to the bottom after loading messages
//   }

//   /// Sends a message and saves it in the database.
//   void _sendMessage() async {
//     String text = _controller.text.trim();
//     if (text.isEmpty) return;

//     // Add user's message to UI & save in DB
//     setState(() {
//       _messages.add(ChatMessage(sender: "user", message: text));
//     });

//     await _chatService.sendMessage(
//       sessionId: widget.sessionID,
//       sender: "user",
//       message: text,
//     );

//     _controller.clear();
//     scrollToBottom(); // ✅ Scroll after user message

//     // Call chatbot based on type
//     if (widget.option == 'Document Chatbot') {
//       _queryDocumentChatbot(text);
//     } else if (widget.option == 'Webpage Extraction Chatbot') {
//       _queryWebChatbot(text);
//     } else {
//       _queryYouTubeChatbot(text);
//     }
//   }

//   /// Queries Document Chatbot and saves bot's response.
//   void _queryDocumentChatbot(String text) {
//     _chatService.QueryFile(
//       context: context,
//       question: text,
//       documentId: widget.id,
//       callback: (String response) async {
//         _addBotMessage(response);
//       },
//     );
//   }

//   /// Queries Webpage Chatbot and saves bot's response.
//   void _queryWebChatbot(String text) {
//     _chatService.queryWeb(
//       context: context,
//       question: text,
//       webId: widget.id,
//       callback: (String response) async {
//         _addBotMessage(response);
//       },
//     );
//   }

//   /// Queries YouTube Chatbot and saves bot's response.
//   void _queryYouTubeChatbot(String text) {
//     _chatService.queryYoutube(
//       context: context,
//       question: text,
//       youtubeId: widget.id,
//       callback: (String response) async {
//         _addBotMessage(response);
//       },
//     );
//   }

//   /// Adds a bot response message to UI & saves in DB.
//   void _addBotMessage(String response) async {
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         _messages.add(ChatMessage(sender: "bot", message: response));
//       });

//       _chatService.sendMessage(
//         sessionId: widget.sessionID,
//         sender: "bot",
//         message: response,
//       );

//       scrollToBottom(); // ✅ Scroll after bot message
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.sessionTitle),
//         backgroundColor: color3,
//       ),
//       body: GradientBackground(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             double maxWidth = constraints.maxWidth < 800 ? constraints.maxWidth : 600;

//             return Center(
//               child: Container(
//                 width: maxWidth,
//                 child: Column(
//                   children: [
//                     // Chat messages list
//                     Expanded(
//                       child: _isLoading
//                           ? const Center(child: CircularProgressIndicator())
//                           : ListView.builder(
//                               controller: _scrollController, // ✅ Added Scroll Controller
//                               padding: const EdgeInsets.all(8.0),
//                               itemCount: _messages.length,
//                               itemBuilder: (context, index) {
//                                 ChatMessage msg = _messages[index];
//                                 bool isUser = msg.sender == "user";

//                                 return Align(
//                                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(12),
//                                     margin: const EdgeInsets.symmetric(vertical: 4),
//                                     constraints: BoxConstraints(maxWidth: maxWidth * 0.8),
//                                     decoration: BoxDecoration(
//                                       color: isUser ? color1.withOpacity(0.7) : Colors.white,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(
//                                       msg.message,
//                                       style: TextStyle(
//                                         color: isUser ? Colors.white : Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                     // Message input field and send button
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                       color: Colors.white,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _controller,
//                               decoration: InputDecoration(
//                                 hintText: "Type your message...",
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           IconButton(
//                             icon: Icon(Icons.send, color: color3),
//                             onPressed: _sendMessage,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
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
  final String id; // ID of the chatbot session
  final String option; // Type of chatbot session
  final String sessionID; // ID for tracking chat history

  static const String routeName = '/chat-screen';

  const ChatScreen({
    super.key,
    required this.sessionTitle,
    required this.id,
    required this.option,
    required this.sessionID,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  /// ✅ Scrolls to the bottom of the chat when a new message arrives.
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Loads previous messages from the database.
  Future<void> _loadChatHistory() async {
    List<Map<String, dynamic>> chatHistory = await _chatService.getMessages(widget.sessionID);

    setState(() {
      _messages = chatHistory.map((msg) {
        return ChatMessage(sender: msg["sender"], message: msg["message"]);
      }).toList();
      _isLoading = false;
    });

    scrollToBottom();
  }

  /// Sends a message and saves it in the database.
  void _sendMessage() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(sender: "user", message: text));
    });

    await _chatService.sendMessage(
      sessionId: widget.sessionID,
      sender: "user",
      message: text,
    );

    _controller.clear();
    scrollToBottom();

    if (widget.option == 'Document Chatbot') {
      _queryDocumentChatbot(text);
    } else if (widget.option == 'Webpage Extraction Chatbot') {
      _queryWebChatbot(text);
    } else {
      _queryYouTubeChatbot(text);
    }
  }

  void _queryDocumentChatbot(String text) {
    _chatService.QueryFile(
      context: context,
      question: text,
      documentId: widget.id,
      callback: (String response) async {
        _addBotMessage(response);
      },
    );
  }

  void _queryWebChatbot(String text) {
    _chatService.queryWeb(
      context: context,
      question: text,
      webId: widget.id,
      callback: (String response) async {
        _addBotMessage(response);
      },
    );
  }

  void _queryYouTubeChatbot(String text) {
    _chatService.queryYoutube(
      context: context,
      question: text,
      youtubeId: widget.id,
      callback: (String response) async {
        _addBotMessage(response);
      },
    );
  }

  void _addBotMessage(String response) async {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(sender: "bot", message: response));
      });

      _chatService.sendMessage(
        sessionId: widget.sessionID,
        sender: "bot",
        message: response,
      );

      scrollToBottom();
    });
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
            double maxWidth = constraints.maxWidth < 800 ? constraints.maxWidth : 600;

            return Center(
              child: Container(
                width: maxWidth,
                child: Column(
                  children: [
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(8.0),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                ChatMessage msg = _messages[index];
                                bool isUser = msg.sender == "user";

                                return Align(
                                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    constraints: BoxConstraints(maxWidth: maxWidth * 0.8),
                                    decoration: BoxDecoration(
                                      color: isUser ? color1.withOpacity(0.7) : Colors.white,
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
                    // ✅ Improved Message Input UI
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        color: Colors.transparent,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: "Type your message...",
                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              textInputAction: TextInputAction.newline,
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: _sendMessage,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color3,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.send, color: Colors.white, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
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

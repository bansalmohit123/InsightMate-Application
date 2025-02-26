import 'dart:ui' as ui; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:insightmate/chat/chat_Screen.dart';
import 'package:insightmate/chat/sessionService.dart';
import 'package:insightmate/forms/document_chatbot_form.dart';
import 'package:insightmate/forms/webpage_chatbot_form.dart';
import 'package:insightmate/forms/youtube_chatbot_form.dart';
import 'package:insightmate/utils.dart';

class ChatbotDetailPage extends StatefulWidget {
  final String option;

  const ChatbotDetailPage({super.key, required this.option});

  @override
  State<ChatbotDetailPage> createState() => _ChatbotDetailPageState();
}

class _ChatbotDetailPageState extends State<ChatbotDetailPage>
    with SingleTickerProviderStateMixin {
  Sessionservice sessionService = Sessionservice();
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  // For a subtle animated gradient background
  late AnimationController _controller;
  late Animation<Color?> _animation1;
  late Animation<Color?> _animation2;

  @override
  void initState() {
    super.initState();
    _fetchSessions();

    // Animate from color1 -> color3 and back for a “breathing” background
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _animation1 = ColorTween(begin: color1, end: color3).animate(_controller);
    _animation2 = ColorTween(begin: color3, end: color1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Fetch sessions from API
  Future<void> _fetchSessions() async {
    List<Map<String, dynamic>> sessions = await sessionService.findoption(
      context: context,
      option: widget.option,
    );
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  /// Adds a new session to the list
  void _addSession(Map<String, dynamic> newSession) {
    setState(() {
      _sessions.insert(0, newSession); // Add at top
    });
  }

  /// Shows the chatbot form
  void _showForm(BuildContext context, Widget form) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width > 600
                ? 500
                : MediaQuery.of(context).size.width * 0.9,
            child: form,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Enhanced gradient AppBar
      appBar: AppBar(
        elevation: 3,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color3],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.option,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      // Animated gradient background
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _animation1.value ?? color1,
                  _animation2.value ?? color3,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          );
        },
        // The main content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Heading
              Text(
                "Previous ${widget.option} Sessions",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Sessions or loading / empty states
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _sessions.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text(
                              "No sessions found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          // Option 1: Make the entire list glassy
                          // by wrapping in a ClipRRect/BackdropFilter
                          // or do it per-card. We'll do it per card:
                          child: ListView.builder(
                            itemCount: _sessions.length,
                            itemBuilder: (context, index) {
                              final session = _sessions[index];
                              return GlassCard(
                                session: session,
                                option: widget.option,
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),

      // Gradient “Create Chatbot” button
      floatingActionButton: Material(
        elevation: 6.0,
        shape: const StadiumBorder(),
        child: Container(
          width: 180,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color1, color3],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: () {
              if (widget.option == "Document Chatbot") {
                _showForm(context,
                    DocumentChatbotForm(onSessionCreated: _addSession));
              } else if (widget.option == "Webpage Extraction Chatbot") {
                _showForm(context,
                    WebpageChatbotForm(onSessionCreated: _addSession));
              } else if (widget.option == "YouTube Summary Chatbot") {
                _showForm(context,
                    YoutubeChatbotForm(onSessionCreated: _addSession));
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Create Chatbot',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A glassy card widget for each session item
class GlassCard extends StatelessWidget {
  final Map<String, dynamic> session;
  final String option;

  const GlassCard({Key? key, required this.session, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Rounded corners for the glass
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          // Semi-transparent white to create frosted glass effect
          color: Colors.white.withOpacity(0.25),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: color3,
              child: const Icon(Icons.chat, color: Colors.white),
            ),
            title: Text(
              session["title"] ?? "Untitled",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // stands out over glass
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            subtitle: Text(
              session["description"] ?? "No description",
              style: const TextStyle(color: Colors.white70),
            ),

            // Right-most button: "Chat with Chatbot"
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      sessionTitle: session["title"] ?? "Untitled",
                      id: session["id"],
                      option: option,
                      sessionID: session["sessionID"],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Chat",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:insightmate/chat/chat_Screen.dart';
import 'package:insightmate/chat/sessionService.dart';
import 'package:insightmate/utils.dart';
import 'package:insightmate/forms/document_chatbot_form.dart';
import 'package:insightmate/forms/webpage_chatbot_form.dart';
import 'package:insightmate/forms/youtube_chatbot_form.dart';

class ChatbotDetailPage extends StatefulWidget {
  final String option;

  const ChatbotDetailPage({super.key, required this.option});

  @override
  State<ChatbotDetailPage> createState() => _ChatbotDetailPageState();
}

class _ChatbotDetailPageState extends State<ChatbotDetailPage> {
  Sessionservice sessionService = Sessionservice();
  List<Map<String, dynamic>> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  /// ✅ Fetch sessions from API
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

  /// ✅ Adds a new session to the list in real-time
  void _addSession(Map<String, dynamic> newSession) {
    setState(() {
      _sessions.insert(0, newSession); // Add new session at the top
    });
  }

  /// ✅ Shows the chatbot form and updates list after session creation
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
      appBar: AppBar(
        title: Text(widget.option),
        backgroundColor: color3,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Previous ${widget.option} Sessions",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color3),
              ),
              const SizedBox(height: 16),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _sessions.isEmpty
                      ? const Center(child: Text("No sessions found"))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _sessions.length,
                            itemBuilder: (context, index) {
                              final session = _sessions[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: const Icon(Icons.chat, color: color3),
                                  title: Text(session["title"] ?? "Untitled"),
                                  subtitle: Text(session["description"] ?? "No description"),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            sessionTitle: session["title"] ?? "Untitled",
                                            id: session["id"],
                                            option: widget.option,
                                            sessionID: session["sessionID"]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: color3,
        child: const Icon(Icons.add),
        onPressed: () {
          if (widget.option == "Document Chatbot") {
            _showForm(
              context,
              DocumentChatbotForm(onSessionCreated: _addSession),
            );
          } else if (widget.option == "Webpage Extraction Chatbot") {
            _showForm(
              context,
              WebpageChatbotForm(onSessionCreated: _addSession),
            );
          } else if (widget.option == "YouTube Summary Chatbot") {
            _showForm(
              context,
              YoutubeChatbotForm(onSessionCreated: _addSession),
            );
          }
        },
      ),
    );
  }
}

import 'dart:ui' as ui; // for BackdropFilter
import 'package:flutter/material.dart';
import 'package:insightmate/chat/chatbot_form.dart';
import 'package:insightmate/utils.dart';

// Dummy chatbot options
final List<Map<String, String>> chatbotOptions = [
  {
    "title": "Document Chatbot",
    "description":
        "Upload a document from your local system. Our AI agent will answer queries based on that document.",
  },
  {
    "title": "Webpage Extraction Chatbot",
    "description":
        "Enter a webpage URL and our chatbot will extract data to answer your questions.",
  },
  {
    "title": "YouTube Summary Chatbot",
    "description":
        "Provide a YouTube video link and our chatbot will extract and summarize the content.",
  },
];

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard-screen';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// Returns an icon based on the title of the chatbot option
  IconData _mapTitleToIcon(String title) {
    if (title.contains("Document")) {
      return Icons.insert_drive_file;
    } else if (title.contains("Webpage")) {
      return Icons.web;
    } else if (title.contains("YouTube")) {
      return Icons.ondemand_video;
    }
    return Icons.chat; // fallback
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
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: GradientBackground(
        showChatbot: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine columns for responsiveness
            int crossAxisCount;
            if (constraints.maxWidth < 600) {
              crossAxisCount = 1; // Mobile
            } else if (constraints.maxWidth < 1024) {
              crossAxisCount = 2; // Tablet
            } else {
              crossAxisCount = 3; // Desktop
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.builder(
                itemCount: chatbotOptions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  final option = chatbotOptions[index];
                  final title = option["title"] ?? "";
                  final description = option["description"] ?? "";

                  return _GlassyCard(
                    title: title,
                    description: description,
                    icon: _mapTitleToIcon(title),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A custom glassy card widget for the dashboard items
class _GlassyCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _GlassyCard({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Round corners
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        // Frosted glass effect
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          // Semi-transparent color to see the background gradient through
          color: const ui.Color.fromARGB(255, 74, 116, 140).withOpacity(0.6),
          child: InkWell(
            onTap: () {
              // On tap, push to ChatbotDetailPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatbotDetailPage(option: title),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon + Title Row
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: color3,
                        child: Icon(icon, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

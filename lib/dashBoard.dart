import 'package:flutter/material.dart';
import 'package:insightmate/chat/chat_Screen.dart';
import 'package:insightmate/utils.dart'; // This should include color3 and GradientBackground

// Dummy data for previous sessions.
final List<String> dummySessions = [
  "Session 1",
  "Session 2",
  "Session 3",
];

// Data for the three chatbot options.
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
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: color3,
      ),
      body: GradientBackground(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use one column if screen width is less than 600, otherwise 3 columns.
            int crossAxisCount = constraints.maxWidth < 600 ? 1 : 3;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: chatbotOptions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final option = chatbotOptions[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatbotDetailPage(
                              option: option["title"]!,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option["title"]!,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: color3),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                option["description"]!,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[800]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

/// Detail page for a selected chatbot option.
/// This page shows a ListView of previous sessions and a FAB to create a new session.
class ChatbotDetailPage extends StatelessWidget {
  final String option;

  const ChatbotDetailPage({Key? key, required this.option}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option),
        backgroundColor: color3,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Previous $option Sessions",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color3),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: dummySessions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.chat, color: color3),
                        title: Text(dummySessions[index]),
                        subtitle: const Text("Tap to view session details"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  sessionTitle: "${dummySessions[index]}"),
                            ),
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //         "Viewing ${dummySessions[index]} session"),
                          //   ),
                          // );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Create new $option session")),
          );
        },
      ),
    );
  }
}

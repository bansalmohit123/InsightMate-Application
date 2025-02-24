// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:insightmate/chat/chat_Screen.dart';
// import 'package:insightmate/utils.dart'; // Ensure this includes color3 and GradientBackground


// // Dummy data for previous sessions.
// final List<String> dummySessions = [
//   "Session 1",
//   "Session 2",
//   "Session 3",
// ];

// // Data for the three chatbot options.
// final List<Map<String, String>> chatbotOptions = [
//   {
//     "title": "Document Chatbot",
//     "description":
//         "Upload a document from your local system. Our AI agent will answer queries based on that document.",
//   },
//   {
//     "title": "Webpage Extraction Chatbot",
//     "description":
//         "Enter a webpage URL and our chatbot will extract data to answer your questions.",
//   },
//   {
//     "title": "YouTube Summary Chatbot",
//     "description":
//         "Provide a YouTube video link and our chatbot will extract and summarize the content.",
//   },
// ];

// class DashboardPage extends StatefulWidget {
//   static const String routeName = '/dashboard-screen';
//   const DashboardPage({super.key});

//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         backgroundColor: color3,
//       ),
//       body: GradientBackground(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             int crossAxisCount = constraints.maxWidth < 600 ? 1 : 3;
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: GridView.builder(
//                 itemCount: chatbotOptions.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: crossAxisCount,
//                   mainAxisSpacing: 16,
//                   crossAxisSpacing: 16,
//                   childAspectRatio: 1.2,
//                 ),
//                 itemBuilder: (context, index) {
//                   final option = chatbotOptions[index];
//                   return Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(12),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ChatbotDetailPage(
//                               option: option["title"]!,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               option["title"]!,
//                               style: const TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: color3),
//                             ),
//                             const SizedBox(height: 8),
//                             Expanded(
//                               child: Text(
//                                 option["description"]!,
//                                 style: TextStyle(
//                                     fontSize: 14, color: Colors.grey[800]),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// /// Detail page for a selected chatbot option.
// /// This page shows a ListView of previous sessions and a FAB to create a new session.
// class ChatbotDetailPage extends StatefulWidget {
//   final String option;

//   const ChatbotDetailPage({super.key, required this.option});

//   @override
//   State<ChatbotDetailPage> createState() => _ChatbotDetailPageState();
// }

// class _ChatbotDetailPageState extends State<ChatbotDetailPage> {
//   void _showChatbotForm(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Allows closing the pop-up by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//           contentPadding: EdgeInsets.zero, // Remove default padding
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width > 600
//                 ? 500
//                 : MediaQuery.of(context).size.width * 0.9,
//             child: _buildChatbotForm(context), // Only the Card appears
//           ),
//         );
//       },
//     );
//   }
//   void _showChatbotFormlink(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Allows closing the pop-up by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//           contentPadding: EdgeInsets.zero, // Remove default padding
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width > 600
//                 ? 500
//                 : MediaQuery.of(context).size.width * 0.9,
//             child: _buildChatbotFormlink(context), // Only the Card appears
//           ),
//         );
//       },
//     );
//   }
//   void _showChatbotFormToutubelink(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true, // Allows closing the pop-up by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//           contentPadding: EdgeInsets.zero, // Remove default padding
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width > 600
//                 ? 500
//                 : MediaQuery.of(context).size.width * 0.9,
//             child: _buildChatbotFormYoutubelink(context), // Only the Card appears
//           ),
//         );
//       },
//     );
//   }


//    Widget _buildChatbotFormlink(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     String _title = '';
//     String _description = '';
//     String _link = '';
    
  
  

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       // Process the form data and file.
//       // You can navigate to the next page, call backend APIs, etc.
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Document Chatbot session created')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and Provide a valid link')),
//       );
//     }
//   }


//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty ? 'Please enter a title' : null,
//                   onSaved: (value) => _title = value!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter a description'
//                       : null,
//                   onSaved: (value) => _description = value!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Youtube Video Link',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter a Youtube Video Link'
//                       : null,
//                   onSaved: (value) => _link = value!,
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: color3,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   onPressed: _submitForm,
//                   child: const Text(
//                     'Create Session',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }



//   Widget _buildChatbotFormYoutubelink(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     String _title = '';
//     String _description = '';
//     String _link = '';
    
  
  

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       // Process the form data and file.
//       // You can navigate to the next page, call backend APIs, etc.
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Document Chatbot session created')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and Provide a valid Youtube link')),
//       );
//     }
//   }


//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) =>
//                       value == null || value.isEmpty ? 'Please enter a title' : null,
//                   onSaved: (value) => _title = value!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3,
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter a description'
//                       : null,
//                   onSaved: (value) => _description = value!,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     labelText: 'Web Page Link',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => value == null || value.isEmpty
//                       ? 'Please enter a Web Page Link'
//                       : null,
//                   onSaved: (value) => _link = value!,
//                 ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: color3,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   onPressed: _submitForm,
//                   child: const Text(
//                     'Create Session',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }


//   Widget _buildChatbotForm(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     String _title = '';
//     String _description = '';
//     String? _selectedFile;

    
//        // Stub function to simulate file picking.
//   Future<void> _pickFile() async {
//   try {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'txt','csv'], // Restrict file types if needed
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.single.name; // Use file name for web compatibility
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No file selected.")),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error selecting file: $e")),
//     );
//   }
// }
 

//   void _submitForm() {
//     if (_formKey.currentState!.validate() && _selectedFile != null) {
//       _formKey.currentState!.save();
//       // Process the form data and file.
//       // You can navigate to the next page, call backend APIs, etc.
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Document Chatbot session created')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and select a file')),
//       );
//     }
//   }


  //   return Card(
  //     elevation: 8,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               TextFormField(
  //                 decoration: const InputDecoration(
  //                   labelText: 'Title',
  //                   border: OutlineInputBorder(),
  //                 ),
  //                 validator: (value) =>
  //                     value == null || value.isEmpty ? 'Please enter a title' : null,
  //                 onSaved: (value) => _title = value!,
  //               ),
  //               const SizedBox(height: 16),
  //               TextFormField(
  //                 decoration: const InputDecoration(
  //                   labelText: 'Description',
  //                   border: OutlineInputBorder(),
  //                 ),
  //                 maxLines: 3,
  //                 validator: (value) => value == null || value.isEmpty
  //                     ? 'Please enter a description'
  //                     : null,
  //                 onSaved: (value) => _description = value!,
  //               ),
  //               const SizedBox(height: 16),
  //               OutlinedButton.icon(
  //                 icon: const Icon(Icons.attach_file),
  //                 label: Text(_selectedFile == null ? 'Select File' : 'File: $_selectedFile'),
  //                 onPressed: _pickFile,
  //               ),
  //               const SizedBox(height: 24),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: color3,
  //                   padding: const EdgeInsets.symmetric(vertical: 16),
  //                 ),
  //                 onPressed: _submitForm,
  //                 child: const Text(
  //                   'Create Session',
  //                   style: TextStyle(fontSize: 16),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.option),
//         backgroundColor: color3,
//       ),
//       body: GradientBackground(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Text(
//                 "Previous ${widget.option} Sessions",
//                 style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold, color: color3),
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: dummySessions.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       child: ListTile(
//                         leading: const Icon(Icons.chat, color: color3),
//                         title: Text(dummySessions[index]),
//                         subtitle: const Text("Tap to view session details"),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ChatScreen(
//                                   sessionTitle: "${dummySessions[index]}"),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: color3,
//         child: const Icon(Icons.add),
//         onPressed: () {
//           if (widget.option == "Document Chatbot") {
//             _showChatbotForm(context);
//           }
//           else if(widget.option == "Webpage Extraction Chatbot"){
//             _showChatbotFormlink(context);
//           }
//           else if(widget.option == "YouTube Summary Chatbot"){
//             _showChatbotFormToutubelink(context);
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:insightmate/chat/chatbot_form.dart';
import 'package:insightmate/utils.dart'; // Ensure this includes color3 and GradientBackground

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: color3,
      ),
      body: GradientBackground(
        showChatbot: true, 
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount;

            // Responsive Grid Settings
            if (constraints.maxWidth < 600) {
              // Mobile Layout: 1 column
              crossAxisCount = 1;
            } else if (constraints.maxWidth < 1024) {
              // Tablet Layout: 2 columns
              crossAxisCount = 2;
            } else {
              // Web Layout: 3 columns
              crossAxisCount = 3;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.builder(
                itemCount: chatbotOptions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3, // Adjust aspect ratio for different layouts
                ),
                itemBuilder: (context, index) {
                  final option = chatbotOptions[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatbotDetailPage(option: option["title"]!),
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
                                color: color3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                option["description"]!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
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

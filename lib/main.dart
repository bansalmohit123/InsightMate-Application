import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightmate/auth/screens/signUp.dart';
import 'package:insightmate/auth/services/authService.dart';
import 'package:insightmate/dashBoard.dart';
import 'package:insightmate/providers/file.dart';
import 'package:insightmate/providers/userProvider.dart';
import 'package:insightmate/providers/web.dart';
import 'package:insightmate/providers/youtube.dart';
import 'package:insightmate/routes.dart';
import 'package:provider/provider.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => WebProvider()),
        ChangeNotifierProvider(create: (_) => YoutubeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    await authService.getUserData(context);
    setState(() {
      _isLoading = false; // Set loading to false after data fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Flutter Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00458B),
        hintColor: const Color(0xFF3FD2C7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                bool isUserLoggedIn = userProvider.user.token != null &&
                    userProvider.user.token.isNotEmpty;
                return isUserLoggedIn
                    ? const DashboardPage()
                    : const SignUpPage();
              },
            ),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

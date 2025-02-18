import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightmate/auth/screens/signUp.dart';
import 'package:insightmate/auth/services/authService.dart';
import 'package:insightmate/chat/chat_Screen.dart';
import 'package:insightmate/dashBoard.dart';
import 'package:insightmate/providers/userProvider.dart';
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

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }
  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn =
        Provider.of<UserProvider>(context).user.token.isNotEmpty;
    return MaterialApp(
      title: 'Responsive Flutter Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:const  Color(0xFF00458B),
        hintColor:const  Color(0xFF3FD2C7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: isUserLoggedIn?const DashboardPage(): const SignUpPage(),
      home: const DashboardPage(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

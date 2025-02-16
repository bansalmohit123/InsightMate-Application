import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insightmate/auth/screens/signUp.dart';
import 'package:insightmate/routes.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Flutter Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:const  Color(0xFF00458B),
        hintColor:const  Color(0xFF3FD2C7),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SignUpPage(),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

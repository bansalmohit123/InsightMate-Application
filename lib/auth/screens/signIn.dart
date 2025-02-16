import 'package:flutter/material.dart';
import 'package:insightmate/auth/screens/signUp.dart';
import 'package:insightmate/auth/services/authService.dart';
import 'package:insightmate/dashBoard.dart';
import 'package:insightmate/utils.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signin-screen';
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService authService = AuthService();
  // Move controllers outside build method so they persist
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signin(BuildContext context) {
    authService.login(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      callback: (bool success) {
        if (success) {
          print("login Succesfull");
          Navigator.pushNamed(context, DashboardPage.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SignIn failed Check Email and Password'),
            ),
          );
          print("Password is Incorrect");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width =
                  constraints.maxWidth < 600 ? constraints.maxWidth * 0.9 : 400;
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: color3),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color3,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // Navigator.pushNamed(context, '/dashboard-screen');
                          signin(context);
                        },
                        child: const Text('Sign In',
                            style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpPage.routeName);
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(
                              color: color1,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

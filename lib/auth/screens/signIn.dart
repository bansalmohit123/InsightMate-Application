import 'dart:ui' as ui; // for BackdropFilter
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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
          print("Login Successful");
          Navigator.pushNamed(context, DashboardPage.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign In failed. Check Email and Password'),
            ),
          );
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

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  // Frosted glass effect
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    // Semi-transparent color to overlay the blurred background
                    color: Colors.white.withOpacity(0.15),
                    width: width,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: color3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Password field
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sign In button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color3,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => signin(context),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Sign Up link
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpPage.routeName);
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(
                              color: ui.Color.fromARGB(255, 63, 110, 210),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
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
        ),
      ),
    );
  }
}

import 'dart:ui' as ui; // for BackdropFilter
import 'package:flutter/material.dart';
import 'package:insightmate/auth/screens/signIn.dart';
import 'package:insightmate/auth/services/authService.dart';
import 'package:insightmate/utils.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = '/signup-screen';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService authService = AuthService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Attempts sign up, returning true if success, false otherwise
  Future<bool> signup() {
    return authService.register(
      context: context,
      username: nameController.text,
      email: emailController.text,
      password: passwordController.text,
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
                    color: Colors.white.withOpacity(0.15),
                    width: width,
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: color3,
                          ),
                          ),
                          const SizedBox(height: 24),

                          // Username field
                          TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(Icons.person),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                            ),
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
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                            ),
                          ),
                          ),

                          const SizedBox(height: 16),

                          // Password field
                          TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                            ),
                          ),
                          ),

                          const SizedBox(height: 32),

                          // Sign Up button
                          ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color3,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            bool result = await signup();
                            if (result) {
                            Navigator.pushNamed(context, '/signin-screen');
                            } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                              content: Text('Sign Up failed'),
                              ),
                            );
                            }
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18),
                          ),
                          ),

                          const SizedBox(height: 24),

                          // Sign In link
                          GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignInPage.routeName);
                          },
                          child: const Text(
                            "Already have an account? Sign In",
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

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

   Future<bool> Signup(){
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
              double width = constraints.maxWidth < 600
                  ? constraints.maxWidth * 0.9
                  : 400;
              return Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: color3),
                        ),
                     const  SizedBox(height: 16),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      const  SizedBox(height: 12),
                         TextField(
                          controller: emailController,
                          decoration:const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      const  SizedBox(height: 12),
                         TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration:const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      const  SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color3,
                            minimumSize:const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async{
                           
                            bool result = await Signup();
                          
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
                          child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                        ),
                       const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                           Navigator.pushNamed(context, SignInPage.routeName);
                          },
                          child: const Text(
                            "Already have an account? Sign In",
                            style: TextStyle(
                                color: color1,
                                decoration: TextDecoration.underline),
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

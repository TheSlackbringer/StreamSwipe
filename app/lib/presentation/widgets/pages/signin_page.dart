import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/svg.dart';
import 'dart:io' show Platform;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../custom_components/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final supabase = Supabase.instance.client;
  final bool isIOS = !kIsWeb && Platform.isIOS;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter email and password')),
        );
        return;
      }

      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      if (response.session != null) {
        // Authentication succeeded
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _signInWithGoogle() {
    // Placeholder for Google Sign-In functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In not implemented')),
    );
  }

  void _navigateToSignUp() {
    // Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Welcome Back!',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 20),
            CustomButton(
                onPressed: _signInWithEmail,
                 text: 'Sign In',
            ),

            const SizedBox(height: 10),

            // Add a separator here
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _signInWithGoogle,
              text: 'Sign in with Google',
              icon: SvgPicture.string(
                '''<svg version="1.1" xmlns="http://www.w3.org/2000/svg" 
                    viewBox="0 0 48 48" xmlns:xlink="http://www.w3.org/1999/xlink">
                  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 
                  3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 
                  2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                  <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94
                  c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 
                  7.09-10.36 7.09-17.65z"/>
                  <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59
                  l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 
                  2.56 10.78l7.97-6.19z"/>
                  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 
                  1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 
                  6.19C6.51 42.62 14.62 48 24 48z"/>
                  <path fill="none" d="M0 0h48v48H0z"/>
                </svg>''',
                width: 20,
                height: 20,
              ),
              backgroundColor: Colors.white,
              borderColor: Color(0xFF747775),
              height: isIOS ? 44.0 : 40.0,
              padding: EdgeInsets.symmetric(horizontal: isIOS ? 16.0 : 12.0),
              iconTextSpacing: isIOS ? 12.0 : 10.0,
              textColor: Color(0xFF1F1F1F),
            ),
            const SizedBox(height: 10),

            // Another separator to distinguish the signup section
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Sign Up Button
            CustomButton(
              onPressed: _navigateToSignUp,
              text: "Don't have an account? Sign Up",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

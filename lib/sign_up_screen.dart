import 'package:flutter/material.dart';
// Import auth to use the signUp method 
import 'auth_service.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Use a uniqure key to track form and run the validators 
  final _formKey = GlobalKey<FormState>();

  // Objects for the users typed text
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Check for password complexity
  String? _validatePassword(String? value) {
    // Check if password is empty
    if (value == null || value.isEmpty) return 'Please enter a password';
    // Check if its more than 8 charecters
    if (value.length < 8) return 'Password must be at least 8 characters long';

    // Used Gemini to grab RegExp: it checks for 1 Upper, 1 Lower, 1 Digit, and 1 Symbol
    final pattern = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
    
    // If it doesnt match conditions then return text if not then it is valid 
    if (!pattern.hasMatch(value)) {
      return 'Must include Uppercase, Lowercase, Digit, and Symbol';
    }
    return null; // Then the Password is valid
  }

  // Sign in interaction with firebase
  void _handleSignUp() async {
    // If all the validations pass, then we can proceed
    if (_formKey.currentState!.validate()) {
      // Calls signUp method
      final result = await AuthService().signUp(
        // Use email as username
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (result == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created! Please log in.')),
        );
        Navigator.pop(context); 
      } else if (result == "exists") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account already exists. Please log in.')),
        );
        Navigator.pop(context); 
      } else {
        // ADD THIS: This will show you exactly why it's not working
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result ?? "An unknown error occurred")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey, // Connects the validator logic
          child: Column(
            children: [
              // Field for the email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email (Username)'),
              ),
              const SizedBox(height: 20),
              // Field for the password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: _validatePassword, 
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleSignUp,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Manages memory by closing controllers when screen is closed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
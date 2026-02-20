import 'package:flutter/material.dart';
import 'package:responsive_design/auth_service.dart';
import 'package:responsive_design/profile_card.dart';
import 'package:responsive_design/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _passHidden = true;

  // there couldd be multiple forms. This assigns a unique key to each form. 
  //Also, it calls the validator function for each field in the form. 
  final _formKey = GlobalKey< FormState>();

  // an object used gor extracting data from fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // Spinning circle feedback
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
              key: _formKey, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: 40), 
                  _username(),
                  const SizedBox(height: 20),
                  _password(),
                  const SizedBox(height: 20),
                  _loginButton(),

                  _signUpLink(),          
                ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Text(
      'Welcome Back',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _username() {
    return TextFormField(
        controller: _usernameController,    
        decoration: const InputDecoration(
          labelText: 'Username',
          border: OutlineInputBorder(),
          // Give the username a little person icon
          prefixIcon: Icon(Icons.person),
        ),
      validator: (value){
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your username';
        }
        return null; 
      }, 

    );
  }

  Widget _password(){
    return TextFormField(
      controller: _passwordController,
      obscureText: _passHidden,
      decoration: InputDecoration(
        labelText: 'Password',
        border:const OutlineInputBorder(),
        prefixIcon: Icon(Icons.lock), 
        suffixIcon: IconButton(
          icon: Icon(_passHidden ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _passHidden =  !_passHidden;
            });
          },
          )
      ),
      validator: (value) {
        // if the value is null or empty, prompt the user to enter a password
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        // If the P-word is less than 8, ask theuser to make it 8 charecters
        if (value.length < 8) {
          return 'Password must be at least 8 charecters long';
        }
        return null;
      } 
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: _submitLogin, 
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
        child: const Text('Login'),
      ); 
  }

  void _submitLogin() async {

    if (!_formKey.currentState!.validate()) return; 

    // Start spinning the progress indicator
    setState(() => _isLoading = true);

    final email = _usernameController.text;
    final password = _passwordController.text;


    try {
      await _authService.signIn(email: email, password: password);

      // from the inherited State we can check to make sure the 
      // signing widget is still on the screen 
      if (!mounted) return; // TODO signOut?

      // If success then go back to ProfileCard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileCard()),
      );
    }
    catch (e) {
      if (!mounted) return; // TODO error popup (Toast)

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally {
      if (mounted) {  // Stop the spinning widget
      setState(() =>_isLoading = false); 
      }
    }

  }
  // Create sign up screen
  Widget _signUpLink() {

    return TextButton(
      onPressed: () {
        // Navigate to the sign up screen 
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
        );
      }, 
      child: const Text('Don\'t have an account? Sign Up'),
      );
  }


}

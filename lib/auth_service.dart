import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Returns a string so we can handle passing error messages to the UI
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      // Create a method to register a new user 
      await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
        );
        return "success";
    } on FirebaseAuthException catch (e) {
      // Check if the email is already registered
      if (e.code == 'email-already-in-use') {
        return "exists"; // Tells the UI to redirect to the login
      }

      // Error check for other Firebase errors
      return e.message?? 'Error';

    } catch (e) {
      return 'System error: $e';
    }
  }
  
  
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found'){
        throw Exception('No user found for that email');
      }
      else if (e.code == 'wrong-password'){
        throw Exception('Wrong password provided');
      }
      else {
        throw Exception(e.message ?? 'An unknown error occurred.');
      }
    }
    catch (e) {
      throw Exception('System error: $e');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
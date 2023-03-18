import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class authenticationService{
  final FirebaseAuth _fireabseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _fireabseAuth.authStateChanges();

  Future<String?> signIn( String email, String Password) async{
    try{
      await _fireabseAuth.signInWithEmailAndPassword(email: email, password: Password);
      return 'Signed In';
    } on FirebaseAuthException catch (e){
      return e.message;
    }
  }
}

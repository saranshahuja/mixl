import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mixl/Pages/UserHome.dart';
import 'Login.dart';
import 'Home.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isAdmin = false;
  bool _termsChecked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'role': _isAdmin ? 'admin' : 'user',
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } catch (e) {
        print("Error: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred while signing up. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // set background color to white
        appBar: AppBar(
        title: Text('Sign Up'),
    ),
    body: SingleChildScrollView(
    child: Container(
    margin: EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    SizedBox(height: 16.0),
    TextFormField(
    controller: _emailController,
    decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email address',
    ),
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
    if (value!.isEmpty || !value.contains('@')) {
    return 'Please enter a valid email';
    }
    return null;
    },
    ),
    SizedBox(height: 16.0),
    TextFormField(
    controller: _passwordController,
    decoration: InputDecoration(
    labelText: 'Password',
    hintText: 'Enter a password',
    ),
    obscureText: true,
    validator: (value) {
    if (value!.isEmpty || value.length < 6) {
    return 'Please enter a valid password (at least 6 characters)';
    }
    return null;
    },
    ),
    SizedBox(height: 16.0),
    TextFormField(
    controller: _confirmPasswordController,
    decoration: InputDecoration(
    labelText: 'Confirm Password',
    hintText: 'Confirm your password',
    ),
    obscureText: true,
    validator: (value) {
    if (value!.isEmpty || value != _passwordController.text) {
    return 'Passwords do not match';
    }
    return null;
    },
    ),
      SizedBox(height: 16.0),
      CheckboxListTile(
        title: Text('Are you an admin?'),
        value: _isAdmin,
        onChanged: (bool? value) {
          setState(() {
            _isAdmin = value!;
          });
        },
      ),
      SizedBox(height: 16.0),
      CheckboxListTile(
        title: Text('I agree to the terms and conditions'),
        value: _termsChecked,
        onChanged: (bool? value) {
          setState(() {
            _termsChecked = value!;
          });
        },
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: _signup,
        child: Text('Sign Up'),
      ),
      SizedBox(height: 16.0),
      TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        child: Text('Already have an account? Log in'),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
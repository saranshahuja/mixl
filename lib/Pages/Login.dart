import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mixl/Pages/Admin.dart';
import 'package:mixl/Pages/Home.dart';
import 'package:mixl/Pages/signup.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      int maxRetries = 3;
      int retryInterval = 1000; // in milliseconds

      for (int retryCount = 0; retryCount <= maxRetries; retryCount++) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

          DocumentSnapshot docSnap = await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).get();
          String role = (docSnap.data() as Map<String, dynamic>)['role'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => role == 'admin' ? AdminPage() : UserPage(),
            ),
          );
          break; // Break the loop on successful login
        } catch (e) {
          if (retryCount == maxRetries) {
            print("Error: $e");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('The service is currently unavailable. Please try again later.'),
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
          } else {

          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Form(
            key: _formKey,
            child: Column(

              children: [

                Image.asset('lib/assets/Avatar.png', width: 250, height: 250), // Replace 'assets/logo.png' with the path of your image

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    scrollPadding: EdgeInsets.all(15),
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email',),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return 'Please enter a valid password (at least 6 characters)';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed:  () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupPage(),
                          ),
                        );
                      },
                      child: Text('Signup'),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

 
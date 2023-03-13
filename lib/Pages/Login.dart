import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                ElevatedButton(
                  onPressed: () async {
                    // final email = _emailController.text.trim();
                    // final password = _passwordController.text.trim();
                    // final auth = context.read(authProvider);
                    // final user = await auth.signIn(email, password);
                    // if (user != null) {
                    //   // Navigate to home screen
                    // } else {
                    //   // Show error message
                    // }
                  },
                  child: const Text('Sign In'),

                ),
                ElevatedButton(
                  onPressed: () async {
                    // final email = _emailController.text.trim();
                    // final password = _passwordController.text.trim();
                    // final auth = context.read(authProvider);
                    // final user = await auth.signIn(email, password);
                    // if (user != null) {
                    //   // Navigate to home screen
                    // } else {
                    //   // Show error message
                    // }
                  },
                  child: const Text('Sign In'),)

              ],
            ),

          ],
        ),
      ),
    );
  }
}
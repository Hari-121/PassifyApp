import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passifyapp/admin.dart';
import 'package:passifyapp/controllers/auth_controller.dart';
import 'package:passifyapp/register.dart';
import 'package:passifyapp/home.dart';

import 'Forgot_Password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final String adminDefaultId = 'admin'; // Set your default admin ID
  final String adminDefaultPassword =
      'password'; // Set your default admin password

  void _login() {
    final String enteredEmail = _emailController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if (enteredEmail == adminDefaultId &&
        enteredPassword == adminDefaultPassword) {
      // Admin login
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPanel(),
        ),
      );
    } else {
      // Regular user login
      AuthController.instance.login(enteredEmail, enteredPassword);
      // Additional logic for regular user login
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade200,
                  Colors.purple.shade50,
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/images/Loginpng.png'),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/Pattern.png'),
                ),
                _header(context),
                _inputfield(context),
                _signup(context),
                _description(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: const [
        SizedBox(
          height: 270,
        ),
        Center(
          child: Text(
            'LOGIN',
            style: TextStyle(fontSize: 39, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  _inputfield(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 370,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.person),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Password',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            obscureText: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 168),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Forget_Password(),
                ),
              );
            },
            child: const Text("Forgot Password ?"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'LOGIN',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  _signup(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 585,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 85),
              child: Center(
                child: Text("Don't have an account?"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Registration(),
                  ),
                );
              },
              child: const Text("Register Here."),
            ),
          ],
        )
      ],
    );
  }

  _description(context) {
    return Column(
      children: const [
        SizedBox(
          height: 735,
        ),
        Center(
          child: Text('"Travel with peace of mind with Passify'),
        ),
        Center(
          child: Text('-your all-in-one travel companion"'),
        )
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passifyapp/controllers/auth_controller.dart';
import 'package:passifyapp/register.dart';
import 'package:passifyapp/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              child: Image.asset('assets/images/image15.png'),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset('assets/images/bg.png'),
            ),
            _header(context),
            _inputfield(context),
            _signup(context),
            _description(context),
          ],
        ),
      ),
    );
  }

  Widget _header(context) {
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

  Widget _inputfield(context) {
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
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
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
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            onPressed: () {
              AuthController.instance.login(_emailController.text.trim(),
                  _passwordController.text.trim());
            },
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

  Widget _signup(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 405,
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
        ),
      ],
    );
  }

  Widget _description(context) {
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
        ),
      ],
    );
  }
}

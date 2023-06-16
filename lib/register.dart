import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passifyapp/controllers/auth_controller.dart';
import 'package:passifyapp/controllers/input_validators.dart';
import 'package:passifyapp/login.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  child: Image.asset('assets/images/Register.png'),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset('assets/images/Pattern.png'),
                    )),
                _header(context),
                _inputfield(context),
                _login(context),
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
          height: 80,
        ),
        Center(
          child: Text(
            "PASSIFY",
            style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(168, 0, 0, 0)),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Center(
          child: Text(
            "REGISTER",
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
          ),
        )
      ],
    );
  }

  _inputfield(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 220,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Name',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.person),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _nameController.text =
                    value[0].toUpperCase() + value.substring(1);
                _nameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _nameController.text.length),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              hintText: 'Username',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.person_2_outlined),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _usernameController.text =
                    value[0].toUpperCase() + value.substring(1);
                _usernameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _usernameController.text.length),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.email),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: TextField(
            controller: _mobileController,
            decoration: InputDecoration(
              hintText: 'Mobile',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.mobile_friendly_outlined),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onChanged: (value) {
              if (value.length > 10) {
                _mobileController.text = value.substring(0, 10);
                _mobileController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _mobileController.text.length),
                );
              }
            },
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
                  borderSide: BorderSide.none),
              fillColor: Colors.white,
              filled: true,
              prefixIcon: const Icon(Icons.lock),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            obscureText: true,
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            onPressed: () {
              if (InputValidator.validateField(
                      "Name", _nameController.text.trim()) &&
                  InputValidator.validateField(
                      "Username", _usernameController.text.trim()) &&
                  InputValidator.validateField(
                      "Email", _emailController.text.trim()) &&
                  InputValidator.validateField(
                      "Mobile", _mobileController.text.trim()) &&
                  InputValidator.validateField(
                      "Password", _passwordController.text.trim())) {
                AuthController.instance.registerUser(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  _nameController.text.trim(),
                  _usernameController.text.trim(),
                  _mobileController.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Register',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  _login(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 530,
        ),
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 85),
              child: Center(
                child: Text("Already have an account?"),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text("Login Here.")),
          ],
        )
      ],
    );
  }

  _description(context) {
    return Column(
      children: const [
        SizedBox(
          height: 749,
        ),
        Center(
          child: Text('"Book bus tickets with ease using Passify"'),
        ),
      ],
    );
  }
}

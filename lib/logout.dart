import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passifyapp/controllers/auth_controller.dart';

import 'Login.dart';
import 'home.dart';
import 'Profile.dart';

class Logout extends StatefulWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String avatarUrl = '';

  final TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          name = data['name'] ?? 'Loading..';
          _nameController.text = name;
          avatarUrl = data['avatar'] ?? ''; // Get the avatar URL from Firestore
        });
      }
    }
  }

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
            child: Stack(children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset('assets/images/Pattern.png'),
                  )),
              Positioned(
                top: 99,
                left: 140,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(
                          avatarUrl) // Use the avatar URL from Firestore
                      : AssetImage('assets/images/image1.png')
                          as ImageProvider, // Fallback image
                ),
              ),
              Positioned(
                  bottom: 0,
                  //right: 0,
                  child: Image.asset(
                    'assets/images/logoutbg.png',
                    height: 450,
                    width: 400,
                  )),
              Positioned(
                  top: 200,
                  left: 140,
                  child: Text(
                    name.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )),
              const Positioned(
                  top: 220,
                  left: 168,
                  child: Text(
                    'Student',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  )),
              const Positioned(
                  top: 350,
                  left: 44,
                  child: Text(
                    'Do you want to logout?',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 405, left: 30, right: 30),
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        AuthController.instance.signOut();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.black,
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 35, left: 30, right: 30),
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.black,
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                  )
                ],
              ),
            ])));
  }
}

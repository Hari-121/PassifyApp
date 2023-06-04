import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passifyapp/Logout.dart';
import 'package:passifyapp/controllers/auth_controller.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'Home.dart';
import 'buspass.dart';
import 'profileupd.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String avatarUrl = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
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
        _deptController.text = data['department'] ?? 'Department';
        _emailController.text = data['email'] ?? '';
        _mobileController.text = data['mobile'] ?? '';
      }
    }
  }

  get changeImageColor => null;

  get imageColor => null;

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
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/Register.png'),
            ),
            Positioned(
              top: 50,
              right: 40,
              child: InkWell(
                onTap: () {
                  changeImageColor;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Profile_Upd()));
                },
                child: Image.asset(
                  'assets/Icons/edit.png',
                  color: imageColor,
                  width: 25,
                  height: 25,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'assets/images/image25.png',
                width: 450,
                height: 550,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(
                            avatarUrl) // Use the avatar URL from Firestore
                        : AssetImage('assets/images/image1.png')
                            as ImageProvider, // Fallback image
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Student',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    width: 300,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _nameController.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Icon(
                                Icons.business,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _deptController.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _mobileController.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Icon(
                                Icons.email_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _emailController.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 180, left: 40),
                              child: InkWell(
                                onTap: () {
                                  changeImageColor;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Dashboard()));
                                },
                                child: Image.asset(
                                  'assets/Icons/Home.png',
                                  color: imageColor,
                                  width: 28,
                                  height: 28,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 180, left: 30),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Logout()));
                              },
                              child: Image.asset(
                                'assets/Icons/Logout.png',
                                color: Colors.black54,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 180, left: 35),
                            child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/Icons/Search.png',
                                color: Colors.black54,
                                width: 53,
                                height: 53,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 180, left: 40),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Buspass()));
                              },
                              child: Image.asset(
                                'assets/Icons/Messages.png',
                                color: Colors.black54,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 180, left: 45),
                            child: InkWell(
                              onTap: () {
                                changeImageColor;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Profile()));
                              },
                              child: Image.asset(
                                'assets/Icons/Avatar.png',
                                //color: Colors.black54,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

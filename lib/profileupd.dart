import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'Profile.dart';

class Profile_Upd extends StatefulWidget {
  const Profile_Upd({Key? key}) : super(key: key);

  @override
  State<Profile_Upd> createState() => _ProfileState();
}

class _ProfileState extends State<Profile_Upd> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String avatarUrl = '';
  XFile? _pickedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingDept = false;
  bool _isEditingMobile = false;

  bool _isEditingImage = false;

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

  Future<void> _updateProfile() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String name = _nameController.text.trim();
      final String dept = _deptController.text.trim();
      final String email = _emailController.text.trim();
      final String mobile = _mobileController.text.trim();

      String avatarUrl = ''; // Initialize the avatar URL

      if (_pickedImage != null) {
        avatarUrl = await _uploadImage(
            user); // Pass the user object to upload the avatar image
      }

      await _firestore.collection('users').doc(user.uid).set(
        {
          'name': name,
          'department': dept,
          'email': email,
          'mobile': mobile,
          'avatar': avatarUrl, // Save the avatar URL in Firestore
        },
        SetOptions(merge: true),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Profile Updated'),
            content: const Text('Your profile has been updated successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<String> _uploadImage(User user) async {
    if (_pickedImage == null) {
      return ''; // No image picked
    }

    final String fileName =
        '${user.uid}.jpg'; // Use user's UID as the file name
    final firebase_storage.Reference reference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('avatars/$fileName');

    final firebase_storage.UploadTask uploadTask = reference.putFile(
      File(_pickedImage!.path),
      firebase_storage.SettableMetadata(contentType: 'image/jpeg'),
    );

    final firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
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
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.fill,
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
              left: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 40,
              child: InkWell(
                onTap: _updateProfile,
                child: Image.asset(
                  'assets/Icons/save.png',
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
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : (avatarUrl.isNotEmpty
                                ? NetworkImage(
                                    avatarUrl) // Use the avatar URL from Firestore
                                : AssetImage('assets/images/image1.png')
                                    as ImageProvider), // Fallback image
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nameController.text.toUpperCase(),
                    style: TextStyle(
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
                  SingleChildScrollView(
                    child: Container(
                      width: 300,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _isEditingName
                                      ? TextFormField(
                                          controller: _nameController,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: 'Name',
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _nameController.text,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingName = !_isEditingName;
                                    });
                                  },
                                  icon: Icon(
                                    _isEditingName ? Icons.done : Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.business,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _isEditingDept
                                      ? TextFormField(
                                          controller: _deptController,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: 'Department',
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _deptController.text,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingDept = !_isEditingDept;
                                    });
                                  },
                                  icon: Icon(
                                    _isEditingDept ? Icons.done : Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone_android_outlined,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _isEditingMobile
                                      ? TextFormField(
                                          controller: _mobileController,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            hintText: 'Mobile',
                                            hintStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          _mobileController.text,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingMobile = !_isEditingMobile;
                                    });
                                  },
                                  icon: Icon(
                                    _isEditingMobile ? Icons.done : Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(color: Colors.white),
                              readOnly: true,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.email_rounded,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

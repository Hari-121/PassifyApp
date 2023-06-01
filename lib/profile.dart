import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:passifyapp/buspass.dart';

import 'package:passifyapp/home.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/utils/constants.dart';

import 'Logout.dart';
import 'controllers/auth_controller.dart';
import 'controllers/profile_controller.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  get changeImageColor => null;

  get imageColor => null;

  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.put(ProfileController());
  }

  @override
  Widget build(BuildContext context) {
    // String? picUrl = AuthController.instance.user!.photoURL;
    // picUrl = picUrl ?? Constants.dummyAvatar;
    String? name = AuthController.instance.user!.displayName ?? "Name";
    String? email = AuthController.instance.user!.email;
    String? mobile = AuthController.instance.user!.phoneNumber ?? "0000000000";
    // String dept = AuthController.instance.
    _mobileController.text = mobile;
    _nameController.text = name;
    //  _deptController.text = dept;
    _emailController.text = email.toString();
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
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/image1.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ANANDU UNNIKRISHNAN',
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
                  Container(
                    width: 300,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                readOnly:
                                    ProfileController.instance.isEdit.value,
                                initialValue: name,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      ProfileController.instance.toggleEdit();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Obx(
                          () {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                readOnly:
                                    ProfileController.instance.isEdit.value,
                                controller: _deptController,
                                //initialValue: '',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: const Icon(
                                      Icons.business,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      ProfileController.instance.toggleEdit();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            initialValue: email,
                            readOnly: true,
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: const Icon(
                                  Icons.email_rounded,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              initialValue: mobile,
                              readOnly: ProfileController.instance.isEdit.value,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: const Icon(
                                    Icons.phone_android_outlined,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    ProfileController.instance.toggleEdit();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 180, left: 40),
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
                                // changeImageColor;
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => const Profile()));
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:passifyapp/controllers/auth_controller.dart';

import 'home.dart';
//import 'Messages.dart';
import 'Profile.dart';
//import 'Search.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 85),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/image1.png',
                height: 110,
                width: 110,
              ),
            ),
            const Text(
              'ANANDU UNNIKRISHNAN',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Text(
              'Student',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            const Spacer(),
            const Text(
              'Do you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  AuthController.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.black,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Dashboard(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.black,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/Icons/Home.png',
                    width: 28,
                    height: 28,
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Logout(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/Icons/Logout.png',
                    width: 28,
                    height: 28,
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Search()));
                  },
                  child: Image.asset(
                    'assets/Icons/Search.png',
                    width: 53,
                    height: 53,
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const Messages()));
                  },
                  child: Image.asset(
                    'assets/Icons/Messages.png',
                    width: 28,
                    height: 28,
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.person_pin,
                    size: 37,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

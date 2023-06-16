import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passifyapp/Logout.dart';
import 'package:passifyapp/profile.dart';

import 'bottombar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color imageColor = Colors.black54;

  String name = '';

  void changeImageColor() {
    setState(() {
      imageColor = Colors.blue;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // User not logged in
        return;
      }

      // Retrieve the username from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid) // Fetch document using current user's UID
          .get();

      // Get the full name from the snapshot
      String fullName = snapshot['name'];

      // Extract the first name from the full name until the first space is encountered
      int spaceIndex = fullName.indexOf(' ');
      String firstName =
          spaceIndex != -1 ? fullName.substring(0, spaceIndex) : fullName;

      setState(() {
        name = firstName;
      });
    } catch (e) {
      print('Error fetching username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Image.asset('assets/images/Home1.png'),
                ),
                Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.15,
                      child: Image.asset('assets/images/Pattern.png'),
                    )),
                _header(context),
                _ticket(context),
                _destination(context),
                // _bottombar(context),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar());
  }

  _header(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(
          height: 70,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(left: 270),
            child: Text(
              'Hello,',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 215),
            child: Text(
              name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(
          height: 125,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 179),
            child: Text(
              'Current Bookings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(
          height: 140,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 212),
            child: Text(
              'Destinations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ],
    );
  }

  _ticket(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 275),
      child: SizedBox(
        height: 140,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 15, left: 8),
                      child: Image.asset('assets/images/Ticket.png'),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'SJCET',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'SJC',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Text(
                            'Passenger',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 22, bottom: 30, right: 15, left: 10),
                      child: Image.asset('assets/images/To.png'),
                    ),
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Vaikom',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'VKM',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Text(
                            'Price',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '150',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 15, left: 8),
                      child: Image.asset('assets/images/Ticket.png'),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Vaikom',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'VKM',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Text(
                            'Passenger',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 22, bottom: 30, right: 15, left: 15),
                      child: Image.asset('assets/images/To.png'),
                    ),
                    Column(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'SJCET',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'SJC',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Text(
                            'Price',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Text(
                            '150',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _destination(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 435),
      child: SizedBox(
        height: 250,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: 220,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 126, 221),
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    alignment: Alignment.bottomCenter,
                    image: AssetImage('assets/images/BG1.png'),
                    fit: BoxFit.scaleDown,
                  ),
                ),
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        //First Box
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 22, top: 25),
                          child: Column(
                            children: const [
                              Text(
                                'Vaikom',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                'VKM',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 65),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 18, left: 5),
                              child: Text(
                                '₹150',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //Second Box
            Container(
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 126, 221),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/images/BG2.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 22, top: 25),
                        child: Column(
                          children: const [
                            Text(
                              'Pala',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'PLA',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 93),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 18, left: 10),
                            child: Text(
                              '₹80',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Third Box
            Container(
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 126, 221),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/images/BG3.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, bottom: 22, top: 25),
                        child: Column(
                          children: const [
                            Text(
                              'Bharananganam',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'BGM',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 18, left: 10),
                            child: Text(
                              '₹50',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Forth Box
            Container(
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 126, 221),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/images/BG4.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 22, top: 25),
                        child: Column(
                          children: const [
                            Text(
                              'Thiruvalla',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'TVL',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 18, left: 5),
                            child: Text(
                              '₹170',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Fifth Box
            Container(
              width: 220,
              height: 120,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 126, 221),
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('assets/images/BG5.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
              margin: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 22, top: 25),
                        child: Column(
                          children: const [
                            Text(
                              'Kottayam',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'KTM',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 55),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(top: 18, left: 5),
                            child: Text(
                              '₹120',
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Arrow
            Padding(
              padding: const EdgeInsets.only(right: 18, left: 5),
              child: InkWell(
                onTap: () {},
                child: Image.asset(
                  'assets/Icons/Rarrow.png',
                  width: 35,
                  height: 35,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _bottombar(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 745, left: 30),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Handle button press here
                    },
                    splashColor:
                        Colors.blue, // Add the desired splash color here
                    child: Ink.image(
                      image: const AssetImage('assets/Icons/Home.png'),
                      width: 37,
                      height: 37,
                      child: InkWell(
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 750, left: 30),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle button press here
                  },
                  splashColor: Colors.blue, // Add the desired splash color here
                  child: Ink.image(
                    image: const AssetImage('assets/Icons/Logout.png'),
                    width: 37,
                    height: 37,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Logout()));
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 748, left: 35),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle button press here
                  },
                  splashColor: Colors.blue, // Add the desired splash color here
                  child: Ink.image(
                    image: const AssetImage('assets/Icons/Search.png'),
                    width: 54,
                    height: 54,
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 745, left: 40),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle button press here
                  },
                  splashColor: Colors.blue, // Add the desired splash color here
                  child: Ink.image(
                    image: const AssetImage('assets/Icons/navticket.png'),
                    width: 37,
                    height: 37,
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 748, left: 30),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle button press here
                  },
                  splashColor:
                      Colors.black, // Add the desired splash color here
                  child: Ink.image(
                    image: const AssetImage('assets/Icons/Avatar.png'),
                    width: 37,
                    height: 37,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

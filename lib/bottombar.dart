import 'package:flutter/material.dart';
import 'package:passifyapp/Home.dart';
import 'package:passifyapp/Logout.dart';
import 'package:passifyapp/profile.dart';
import 'package:passifyapp/search.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          // backgroundColor: Colors.transparent,
          icon: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Ink.image(
              image: AssetImage('assets/Icons/Home.png'),
              width: 37,
              height: 37,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Ink.image(
            image: AssetImage('assets/Icons/Logout.png'),
            width: 37,
            height: 37,
          ),
          label: 'Logout',
        ),
        BottomNavigationBarItem(
          icon: Ink.image(
            image: AssetImage('assets/Icons/Search.png'),
            width: 54,
            height: 54,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Ink.image(
            image: AssetImage('assets/Icons/navticket.png'),
            width: 37,
            height: 37,
          ),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Ink.image(
            image: AssetImage('assets/Icons/Avatar.png'),
            width: 37,
            height: 37,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // Handle button press based on index
        switch (index) {
          case 0:
            // Handle home button press
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));

            break;
          case 1:
            // Handle logout button press
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Logout()));
            break;
          case 2:
            // Handle search button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchPage()));

            break;
          case 3:
            // Handle ticket button press
            break;
          case 4:
            // Handle profile button press
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Profile()));
            break;
        }
      },
    );
  }
}

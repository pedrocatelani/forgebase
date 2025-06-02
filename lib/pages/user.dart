import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/card.dart';
import 'package:iconly/iconly.dart';

enum _SelectedTab { user, home, camera }

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.user;

    void _onTapChange(int index) {
      setState(() {
        _selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushReplacementNamed(
        context,
        '/${_SelectedTab.values[index].name}',
      );
    }

    User? user = FirebaseAuth.instance.currentUser;

    Map<dynamic, dynamic> data = {
      'name': 'Deck de release',
      'sas': '77',
      'houses': ['untamed', 'mars', 'geistoid'],
      'expectedAembar': 11,
      'aembarControl': 17,
      'effectivePower': 57,
      'creatureControl': 30,
      'creatureProtection': 41,
      'disruption': 12,
    };

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomBackground(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      '${user?.displayName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          () => Navigator.pushReplacementNamed(
                            context,
                            '/edituser',
                          ),
                      child: Text('Edit Profile'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Decks'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Aembar'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'My Decks:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        CardWidget(data: data),
                        CardWidget(data: data),
                        CardWidget(data: data),
                        CardWidget(data: data),
                        CardWidget(data: data),
                        CardWidget(data: data),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CrystalNavigationBar(
            onTap: _onTapChange,
            currentIndex: _SelectedTab.values.indexOf(_selectedTab),
            indicatorColor: Color.fromARGB(255, 138, 80, 238),
            backgroundColor: const Color.fromARGB(255, 73, 72, 72),
            enableFloatingNavBar: true,
            items: [
              CrystalNavigationBarItem(
                icon: IconlyBold.user_2,
                unselectedIcon: IconlyLight.user,
                selectedColor: Color.fromARGB(255, 138, 80, 238),
                unselectedColor: Color.fromARGB(255, 138, 80, 238),
              ),
              CrystalNavigationBarItem(
                icon: IconlyBold.home,
                unselectedIcon: IconlyLight.home,
                selectedColor: Color.fromARGB(255, 138, 80, 238),
                unselectedColor: Color.fromARGB(255, 138, 80, 238),
              ),
              CrystalNavigationBarItem(
                icon: IconlyBold.category,
                unselectedIcon: IconlyLight.category,
                selectedColor: Color.fromARGB(255, 138, 80, 238),
                unselectedColor: Color.fromARGB(255, 138, 80, 238),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

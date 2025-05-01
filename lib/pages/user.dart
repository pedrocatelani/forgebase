import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
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

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(110, 155, 39, 176), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),
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
                Center(child: Text('UserName', style: TextStyle(fontSize: 18))),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
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
                    children: [CardWidget(), CardWidget(), CardWidget()],
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
          indicatorColor: Colors.purple,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          enableFloatingNavBar: true,
          items: [
            CrystalNavigationBarItem(
              icon: IconlyBold.user_2,
              unselectedIcon: IconlyLight.user,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.category,
              unselectedIcon: IconlyLight.category,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

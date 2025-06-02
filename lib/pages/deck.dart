import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/cardgradient.dart';
import 'package:forgebase/utils/_get_info.dart';
import 'package:iconly/iconly.dart';

enum _SelectedTab { user, home, camera }

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {

  Future<void> showStatistics(String deckId) async {
    final getinfo = GetInfo();

    try {
      final result = await getinfo.getDeckStatistics(deckId);
    } catch (e) {
      print("Error $e");
    }
  }

  void initState() {
    super.initState();
      Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String deckId = args['id'];
      showStatistics(deckId);
  });
  }

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

    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(202, 73, 72, 72),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(0, 0, 0, 0),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  height: 92,
                  child: Column(
                    children: [
                      Text('Deck Name etc...', style: TextStyle(fontSize: 22)),
                      Text(
                        'Mass Mutation',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(radius: 18, backgroundColor: Colors.pink),
                    CircleAvatar(radius: 18, backgroundColor: Colors.pink),
                    CircleAvatar(radius: 18, backgroundColor: Colors.pink),
                  ],
                ),
                Container(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Column(
                      children: [
                        Text(
                          '62',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '30',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '-2',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Base AERC',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Synergy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Anti Synergy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '90',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('SaS'),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '99%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Percentil'),
                      ],
                    ),
                  ],
                ),
                Container(height: 32),
                CardGradient(
                  color: const Color.fromARGB(255, 207, 204, 22),
                  title: Text(
                    'Aember',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 255, 20, 20),
                  title: Text(
                    'Creature',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 22, 155, 207),
                  title: Text(
                    'Speed',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 68, 192, 19),
                  title: Text(
                    'Extras',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 255, 25, 167),
                  title: Text(
                    'Card Count',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
    );
  }
}

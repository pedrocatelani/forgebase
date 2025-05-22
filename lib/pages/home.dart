import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:forgebase/components/card.dart';
import 'package:iconly/iconly.dart';
// import 'package:forgebase/components/footer.dart';

enum _SelectedTab { user, home, camera }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.home;

    void _onTapChange(int index) {
      setState(() {
        _selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    return Scaffold(
      appBar: AppBar(title: Text("Global Decks")),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Flexible(
              child: ListView(
                children: [
                  CardWidget(),
                  CardWidget(),
                  CardWidget(),
                  CardWidget(),
                  CardWidget(),
                  CardWidget(),
                  CardWidget(),
                ],
              ),
            ),
            // FooterWidget(),
          ],
        ),
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

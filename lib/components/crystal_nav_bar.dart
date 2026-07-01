import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';

class ForgebaseCrystalNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ForgebaseCrystalNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CrystalNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        indicatorColor: const Color.fromARGB(255, 138, 80, 238),
        backgroundColor: const Color.fromARGB(255, 73, 72, 72),
        enableFloatingNavBar: true,
        items: [
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home_outlined,
            selectedColor: const Color.fromARGB(255, 138, 80, 238),
            unselectedColor: const Color.fromARGB(255, 138, 80, 238),
          ),
          CrystalNavigationBarItem(
            icon: Icons.person,
            unselectedIcon: Icons.person_outline,
            selectedColor: const Color.fromARGB(255, 138, 80, 238),
            unselectedColor: const Color.fromARGB(255, 138, 80, 238),
          ),
          CrystalNavigationBarItem(
            icon: Icons.settings,
            unselectedIcon: Icons.settings_outlined,
            selectedColor: const Color.fromARGB(255, 138, 80, 238),
            unselectedColor: const Color.fromARGB(255, 138, 80, 238),
          ),
        ],
      ),
    );
  }
}

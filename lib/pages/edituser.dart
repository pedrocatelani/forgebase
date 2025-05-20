import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:iconly/iconly.dart';

enum _SelectedTab { user, home, camera }

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.user;

    void _onTapChange(int index) {
      setState(() {
        _selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    // ignore: no_leading_underscores_for_local_identifiers
    final AuthService _authService = AuthService();
    User? user = FirebaseAuth.instance.currentUser;
    final _database =
        FirebaseColletion(); //função para intanciar a função getAPI Key

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomBackground(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  Container(height: 200),
                  Text('${user?.displayName}', style: TextStyle(fontSize: 20)),
                  FutureBuilder<String>(
                    future: _database.getApiKey(user!.email.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(height: 10);
                      }
                      if (snapshot.hasError) {
                        return Text("Erro ao carregar API Key");
                      }
                      return Text(
                        snapshot.data ?? "Nenhuma API Key encontrada",
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "${user?.displayName}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                  FutureBuilder<String>(
                    future: _database.getApiKey(user!.email.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(height: 10);
                      }
                      if (snapshot.hasError) {
                        return Text("Erro ao carregar API Key");
                      }
                      return TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          hintText:
                              snapshot.data ?? "Nenhuma API Key encontrada",
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text(
                      'Change Password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text('Change Image', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () => _authService.logout(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      shadowColor: Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(Icons.logout),
                        Text('Logout', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      shadowColor: Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(Icons.delete_forever_outlined),
                        Text('Delete Account', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('Save')),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushReplacementNamed(
                              context,
                              '/user',
                            ),
                        child: Text('Back'),
                      ),
                    ],
                  ),
                  Container(height: 100),
                ],
              ),
            ),
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

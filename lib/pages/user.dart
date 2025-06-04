import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/card.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:iconly/iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum _SelectedTab { user, home, camera }

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseColletion database = FirebaseColletion();
  final User? user = FirebaseAuth.instance.currentUser;

  void initState() {
    super.initState();
    buildImage();
  }

  Uint8List? _imageBytes;

  void buildImage() async {
    final image = await database.getUserImage(user!.email!);
    setState(() {
      _imageBytes = image;
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
                            color: Colors.grey[300],
                            image:
                                _imageBytes != null
                                    ? DecorationImage(
                                      image: MemoryImage(_imageBytes!),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              _imageBytes == null
                                  ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                  : null,
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
                          Text('Aember'),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    'My Decks:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: 
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('decks').where('user_email', isEqualTo: user!.email).snapshots(), 
                        builder: (context, snapshot) {

                          if (!snapshot.hasData) {
                            return Text(
                              "Loading Decks ......",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              )
                            );
                          }

                          List decks = snapshot.data!.docs;

                          decks.sort((a, b) {
                            int sasA = a["sas"];
                            int sasB = b["sas"];

                            return sasB.compareTo(sasA);
                          });

                          List<Widget> userDecks = [];

                          for (var deck in decks){
                            userDecks.add(CardWidget(data: deck.data()));
                          }

                          return ListView(children: userDecks);
                        }
                      )
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

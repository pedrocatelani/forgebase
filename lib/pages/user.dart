import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/card.dart';
import 'package:forgebase/components/crystal_nav_bar.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/translate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forgebase/components/search_dialog.dart';

enum _SelectedTab { user, home, camera }

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseColletion database = FirebaseColletion();
  final User? user = FirebaseAuth.instance.currentUser;

  String? orderBy = 'sas';
  bool desc = true;
  Stream? stream;
  String? decksQnt;
  StreamSubscription? decksCounter;
  Uint8List? _imageBytes;

  late final SearchHelper searchHelper;

  @override
  void initState() {
    super.initState();
    searchHelper = SearchHelper(
      onSearchChanged: () {
        setState(() {});
      },
    );
    buildImage();
    stream =
        FirebaseFirestore.instance
            .collection('decks')
            .where('user_email', isEqualTo: user!.email)
            .snapshots();

    decksCounter = stream!.listen((snapshot) {
      decksQnt = snapshot.docs.length.toString();
    });
  }

  @override
  void dispose() {
    searchHelper.dispose();
    decksCounter?.cancel();
    super.dispose();
  }



  void buildImage() async {
    final image = await database.getUserImage(user!.email!);
    setState(() {
      _imageBytes = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.user;
    stream = stream;

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
            Positioned.fill(
              child: SingleChildScrollView(
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
                        child: Text(translate('USER.EDIT_PROFILE')),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              decksQnt ?? "0",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(translate('USER.DECKS')),
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
                            Text(translate('USER.CHAINS')),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('USER.MY_DECKS'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          tooltip: translate('HOME.SEARCH_DECKS'),
                          icon: Icon(Icons.search),
                          onPressed: () => searchHelper.openSearch(context),
                        ),
                      ],
                    ),
                    if (searchHelper.searchTerm.isNotEmpty)
                      Center(
                        child: Chip(
                          label: Text(searchHelper.searchTerm),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: searchHelper.clearSearch,
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('HOME.SELECT_SORTING_METHOD'),
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton(
                          value: orderBy,
                          items: [
                            DropdownMenuItem(value: 'sas', child: Text('SAS')),
                            DropdownMenuItem(
                              value: 'name',
                              child: Text(translate('DECK.NAME')),
                            ),
                            DropdownMenuItem(
                              value: 'aerc',
                              child: Text('AERC'),
                            ),
                            DropdownMenuItem(
                              value: 'synergy',
                              child: Text(translate('DECK.SYNERGY')),
                            ),
                          ],
                          onChanged: (newOrder) {
                            setState(() {
                              orderBy = newOrder!;
                            });
                          },
                        ),

                        DropdownButton(
                          value: desc,
                          items: [
                            DropdownMenuItem(
                              value: true,
                              child: Icon(Icons.arrow_downward_rounded),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Icon(Icons.arrow_upward_rounded),
                            ),
                          ],
                          onChanged: (newDesc) {
                            setState(() {
                              desc = newDesc as bool;
                            });
                          },
                        ),
                      ],
                    ),

                    StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            translate('USER.LOADING_DECKS'),
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Text(
                            translate(
                              'USER.ERROR',
                              namedArgs: {'error': snapshot.error.toString()},
                            ),
                          );
                        }

                        List decks = snapshot.data!.docs;

                        if (searchHelper.searchTerm.isNotEmpty) {
                          final termLowerCase = searchHelper.searchTerm.toLowerCase();
                          decks = decks.where((deck) {
                            final name = deck.data()['name'].toString().toLowerCase();
                            return name.contains(termLowerCase);
                          }).toList();
                        }

                        if (decks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(translate('HOME.NO_DECKS_FOUND')),
                            ),
                          );
                        }

                        decks.sort((a, b) {
                          var itemA = a.data()[orderBy];
                          var itemB = b.data()[orderBy];

                          if (desc) {
                            return itemB.compareTo(itemA);
                          }

                          return itemA.compareTo(itemB);
                        });

                        List<Widget> widgets = [];

                        for (var deck in decks) {
                          widgets.add(CardWidget(data: deck.data()));
                        }

                        return Column(children: widgets);
                      },
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        extendBody: true,
        bottomNavigationBar: ForgebaseCrystalNavigationBar(
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          onTap: _onTapChange,
        ),
      ),
    );
  }
}

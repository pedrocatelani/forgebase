import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:forgebase/components/card.dart';
import 'package:forgebase/utils/translate.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forgebase/components/search_dialog.dart';

enum _SelectedTab { user, home, camera }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String orderBy = 'sas';
  String searchTerm = '';
  bool desc = true;
  final ScrollController _scrollController = ScrollController();
  int limit = 20;
  bool isLoading = false;
  bool hasMore = true;
  bool reloadAfterCurrentLoad = false;
  int queryVersion = 0;
  List documents = [];
  DocumentSnapshot? lastDoc;
  late final SearchHelper searchHelper;

  @override
  void initState() {
    super.initState();
    searchHelper = SearchHelper(
      onSearchChanged: () {
        setState(() {});
        _resetAndLoad();
      },
    );
    _scrollController.addListener(_scrollListener);
    load(context);
  }

  @override
  void dispose() {
    searchHelper.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading &&
        hasMore) {
      load(context);
    }
  }

  void _resetAndLoad() {
    setState(() {
      queryVersion++;
      documents.clear();
      lastDoc = null;
      hasMore = true;
    });

    if (isLoading) {
      reloadAfterCurrentLoad = true;
      return;
    }

    load(context);
  }



  Future<void> load(BuildContext context) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    final int currentQueryVersion = queryVersion;

    try {
      final String querySearchTerm = searchHelper.searchTerm.trim().toLowerCase();
      final bool isSearching = querySearchTerm.isNotEmpty;
      Query query = FirebaseFirestore.instance.collection('decks');

      query = query.orderBy(orderBy, descending: desc);

      if (!isSearching) {
        if (documents.isEmpty) {
          query = query.limit(limit);
        } else {
          query = query.startAfterDocument(lastDoc!).limit(limit);
        }
      }

      QuerySnapshot snapshot = await query.get();
      if (!mounted || !context.mounted || currentQueryVersion != queryVersion) {
        return;
      }

      if (isSearching) {
        final filteredDocs = snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toString().toLowerCase();
          return name.contains(querySearchTerm);
        }).toList();

        setState(() {
          documents.addAll(filteredDocs);
          hasMore = false;
        });
      } else {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            documents.addAll(snapshot.docs);
            lastDoc = snapshot.docs.last;
            hasMore = snapshot.docs.length == limit;
          });
        } else {
          setState(() {
            hasMore = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(translate('HOME.END_OF_LIST'))));
        }
      }
    } catch (e) {
      debugPrint('error loading data: $e');
      if (!mounted || !context.mounted || currentQueryVersion != queryVersion) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(translate('HOME.LOAD_ERROR'))));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (reloadAfterCurrentLoad && context.mounted) {
          reloadAfterCurrentLoad = false;
          load(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _SelectedTab selectedTab = _SelectedTab.home;

    void onTapChange(int index) {
      setState(() {
        selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('HOME.GLOBAL_DECKS')),
        actions: [
          IconButton(
            tooltip: translate('HOME.SEARCH_DECKS'),
            icon: Icon(Icons.search),
            onPressed: () => searchHelper.openSearch(context),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
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
                    DropdownMenuItem(value: 'aerc', child: Text('AERC')),
                    DropdownMenuItem(
                      value: 'synergy',
                      child: Text(translate('DECK.SYNERGY')),
                    ),
                  ],
                  onChanged: (newOrder) {
                    setState(() {
                      orderBy = newOrder!;
                    });
                    _resetAndLoad();
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
                    _resetAndLoad();
                  },
                ),

                if (searchHelper.searchTerm.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Chip(
                      label: Text(searchHelper.searchTerm),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: searchHelper.clearSearch,
                    ),
                  ),
              ],
            ),

            Expanded(
              child:
                  documents.isEmpty && isLoading
                      ? Center(child: CircularProgressIndicator())
                      : documents.isEmpty && !isLoading && !hasMore
                      ? Center(child: Text(translate('HOME.NO_DECKS_FOUND')))
                      : ListView.builder(
                        controller: _scrollController,
                        itemCount: documents.length + 1,
                        itemBuilder: (context, index) {
                          if (index == documents.length) {
                            return isLoading
                                ? Center(child: CircularProgressIndicator())
                                : hasMore
                                ? SizedBox.shrink()
                                : Center(
                                  child: Text(
                                    translate('HOME.NO_MORE_DECKS'),
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        160,
                                        118,
                                        233,
                                      ),
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                          }

                          return CardWidget(data: documents[index].data());
                        },
                      ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          onTap: onTapChange,
          currentIndex: _SelectedTab.values.indexOf(selectedTab),
          indicatorColor: Color.fromARGB(255, 138, 80, 238),
          backgroundColor: const Color.fromARGB(255, 73, 72, 72),
          enableFloatingNavBar: true,
          items: [
            CrystalNavigationBarItem(
              icon: Icons.person,
              unselectedIcon: Icons.person_outline,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home_outlined,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
            CrystalNavigationBarItem(
              icon: Icons.qr_code_scanner,
              unselectedIcon: Icons.qr_code_scanner_outlined,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:forgebase/components/card.dart';
import 'package:iconly/iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:forgebase/components/footer.dart';

enum _SelectedTab { user, home, camera }
Stream? stream;
int pagesCounter = 1;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scroll = ScrollController();
  String orderBy = 'sas';
  bool desc = true;

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection('decks').orderBy('sas', descending: true).limit(10).snapshots();
    pagesCounter = 1;
  }


  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.home;

    void _onTapChange(int index) {
      setState(() {
        _selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    
    void _nextPage(var last) {
      setState(() {
          scroll.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          stream = FirebaseFirestore.instance.collection('decks').orderBy(orderBy, descending: desc).startAfterDocument(last).limit(10).snapshots();
          pagesCounter ++;
        }
      );
    }


    void _prevPage(var last) {
      setState(() {
          scroll.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          stream = FirebaseFirestore.instance.collection('decks').orderBy(orderBy, descending: desc).endBeforeDocument(last).limit(10).snapshots();
          pagesCounter --;
        }
      );
    }


    return Scaffold(
      appBar: AppBar(title: Text("Global Decks")),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select a sorting method: ",
                  style: TextStyle(fontSize: 16)
                ),
                DropdownButton(
                  value: orderBy,
                  items: [
                    DropdownMenuItem(value: 'sas', child: Text('SAS')),
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(value: 'aerc', child: Text('AERC')),
                    DropdownMenuItem(value: 'sasPercentile', child: Text('SAS Percentile')),
                    DropdownMenuItem(value: 'synergy', child: Text('Synergy'))
                  ],
                  onChanged: (newOrder) {
                    setState(() {
                      orderBy = newOrder!;
                      stream = FirebaseFirestore.instance.collection('decks').orderBy(orderBy, descending: desc).limit(10).snapshots();
                      pagesCounter = 1;
                    });
                  }
                ),

                DropdownButton(
                  value: desc,
                  items: [
                    DropdownMenuItem(value: true, child: Icon(Icons.arrow_downward_rounded)),
                    DropdownMenuItem(value: false, child: Icon(Icons.arrow_upward_rounded)),
                  ],
                  onChanged: (newDesc) {
                    setState(() {
                      desc = newDesc as bool;
                      stream = FirebaseFirestore.instance.collection('decks').orderBy(orderBy, descending: desc).limit(10).snapshots();
                      pagesCounter = 1;
                    });
                  }
                ),
              ],
            ),
            Flexible(
              child:
              StreamBuilder(
                stream: stream,
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

                  List<Widget> widgets = [];

                  for (var deck in snapshot.data!.docs){
                    widgets.add(CardWidget(data: deck.data()));
                  }

                  Widget prevButton = TextButton(onPressed:() => {},
                    child: Text("Previous Page",
                      style: TextStyle(color: const Color.fromARGB(255, 139, 139, 139)),
                    )
                  );

                  Widget nextButton = TextButton(onPressed:() => {},
                    child: Text("Next Page",
                      style: TextStyle(color: const Color.fromARGB(255, 139, 139, 139)),
                    )
                  );

                  if (pagesCounter > 1) {
                    prevButton = TextButton(onPressed:() => _prevPage(snapshot.data!.docs.last), child: Text("Previous Page"));
                  }

                  if (snapshot.data!.size == 10) {
                    nextButton = TextButton(onPressed:() => _nextPage(snapshot.data!.docs.last), child: Text("Next Page"));
                  }

                  widgets.add(Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [prevButton, nextButton],
                  ));

                  return ListView(
                    controller: scroll,
                    children: widgets,
                  );
                }
              )
            ),
            
            // FooterWidget(),]
          ],
        ),
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

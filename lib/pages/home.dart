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
          stream = FirebaseFirestore.instance.collection('decks').orderBy('sas', descending: true).startAfterDocument(last).limit(10).snapshots();
          pagesCounter ++;
        }
      );
    }


    void _prevPage(var last) {
      setState(() {
          scroll.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          stream = FirebaseFirestore.instance.collection('decks').orderBy('sas', descending: true).endBeforeDocument(last).limit(10).snapshots();
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

import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/cardgradient.dart';
import 'package:forgebase/components/infocard.dart';
import 'package:forgebase/utils/_get_info.dart';
import 'package:forgebase/utils/translate.dart';

enum _SelectedTab { user, home, camera }

class DeckPage extends StatefulWidget {
  const DeckPage({super.key});

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  Map<String, dynamic>? deckInfo;

  Future<void> fetchDeckInfo(String deckId) async {
    final getinfo = GetInfo();

    final result = await getinfo.getDeckStatistics(deckId);
    setState(() {
      deckInfo = result;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String deckId = args['id'];
      fetchDeckInfo(deckId);
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

    if (deckInfo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                  height: 84,
                  child: Column(
                    spacing: 4,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          deckInfo!['name'],
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                      Text(
                        deckInfo!['expansion']
                            .toLowerCase()
                            .split('_')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' '),
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
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                        "assets/houses/${deckInfo!['housesNames'][0].toLowerCase()}.png",
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                        "assets/houses/${deckInfo!['housesNames'][1].toLowerCase()}.png",
                      ),
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(
                        "assets/houses/${deckInfo!['housesNames'][2].toLowerCase()}.png",
                      ),
                    ),
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
                          deckInfo!['aerc'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          deckInfo!['synergy'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          deckInfo!['antiSynergy'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate('DECK.BASE_AERC'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          translate('DECK.SYNERGY'),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          translate('DECK.ANTI_SYNERGY'),
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
                          deckInfo!['sas'].toString(),
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
                          deckInfo!['sasPercentile'].toString().substring(0, 4),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(translate('DECK.PERCENTILE')),
                      ],
                    ),
                  ],
                ),
                Container(height: 32),
                CardGradient(
                  color: const Color.fromARGB(255, 207, 204, 22),
                  title: Text(
                    translate('DECK.AEMBER'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.EXPECTED'),
                  info: deckInfo!['expectedAember'].toStringAsFixed(2),
                  icon: Icon(Icons.diamond, color: Colors.amber),
                ),
                InfoCard(
                  cardTitle: translate('DECK.CONTROL'),
                  info: deckInfo!['aemberControl'].toStringAsFixed(2),
                  icon: Icon(Icons.diamond, color: Colors.red),
                ),
                InfoCard(
                  cardTitle: translate('DECK.BONUS'),
                  info: deckInfo!['bonusAember'].toString(),
                  icon: Icon(Icons.plus_one, color: Colors.amber),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 255, 20, 20),
                  title: Text(
                    translate('DECK.CREATURE'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.CONTROL'),
                  info: deckInfo!['creatureControl'].toStringAsFixed(2),
                  icon: Icon(Icons.south_west_rounded, color: Colors.red),
                ),
                InfoCard(
                  cardTitle: translate('DECK.EFFECTIVE_POWER'),
                  info: deckInfo!['effectivePower'].toString(),
                  icon: Icon(Icons.people, color: Colors.amber),
                ),
                InfoCard(
                  cardTitle: translate('DECK.PROTECTION'),
                  info: deckInfo!['creatureProtection'].toStringAsFixed(2),
                  icon: Icon(Icons.shield, color: Colors.blue),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 22, 155, 207),
                  title: Text(
                    translate('DECK.SPEED'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.EFFICIENCY'),
                  info: deckInfo!['efficiency'].toStringAsFixed(2),
                  icon: Icon(Icons.speed, color: Colors.blue),
                ),
                InfoCard(
                  cardTitle: translate('DECK.DISRUPTION'),
                  info: deckInfo!['disruption'].toStringAsFixed(2),
                  icon: Icon(Icons.undo, color: Colors.red),
                ),
                InfoCard(
                  cardTitle: translate('DECK.RECURSION'),
                  info: deckInfo!['recursion'].toStringAsFixed(2),
                  icon: Icon(Icons.wifi_protected_setup, color: Colors.blue),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 68, 192, 19),
                  title: Text(
                    translate('DECK.EXTRAS'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.OTHER'),
                  info: deckInfo!['other'].toStringAsFixed(2),
                  icon: Icon(
                    Icons.wifi_protected_setup,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                Container(height: 16),
                CardGradient(
                  color: const Color.fromARGB(255, 255, 25, 167),
                  title: Text(
                    translate('DECK.CARD_COUNT'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.CREATURE'),
                  info: deckInfo!['creatureCount'].toString(),
                  icon: Icon(
                    Icons.people_outline,
                    color: Color.fromARGB(255, 255, 25, 167),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.ACTION'),
                  info: deckInfo!['actionCount'].toString(),
                  icon: Icon(
                    Icons.double_arrow_outlined,
                    color: Color.fromARGB(255, 255, 25, 167),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.ARTIFACT'),
                  info: deckInfo!['artifactCount'].toString(),
                  icon: Icon(
                    Icons.account_balance,
                    color: Color.fromARGB(255, 255, 25, 167),
                  ),
                ),
                InfoCard(
                  cardTitle: translate('DECK.UPGRADE'),
                  info: deckInfo!['upgradeCount'].toString(),
                  icon: Icon(
                    Icons.pin_end_sharp,
                    color: Color.fromARGB(255, 255, 25, 167),
                  ),
                ),
                Container(height: 180),
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

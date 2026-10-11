import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/crystal_nav_bar.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/language.dart';
import 'package:forgebase/utils/translate.dart';

enum _SelectedTab { home, user, settings }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();
  final database = FirebaseColletion();

  var txtApiKey = TextEditingController();
  String selectedLanguage = defaultLanguageCode;
  bool _hasUserSelectedLanguage = false;
  bool _isSavingLanguage = false;

  @override
  void initState() {
    super.initState();

    if (user != null) {
      database.getApiKey(user!.email!).then((value) {
        if (!mounted) return;
        setState(() {
          txtApiKey.text = value;
        });
      });
      database.getUserLanguage(user!.email!).then((value) {
        if (!mounted) return;
        if (_hasUserSelectedLanguage) return;
        setState(() {
          selectedLanguage = value;
        });
        context.setLocale(localeFromLanguageCode(value));
      });
    }
  }

  Future<void> _changeLanguage(String code) async {
    if (user?.email == null || _isSavingLanguage) return;

    final previousLanguage = selectedLanguage;
    final nextLanguage = normalizeLanguageCode(code);
    if (nextLanguage == previousLanguage) return;

    _hasUserSelectedLanguage = true;

    setState(() {
      selectedLanguage = nextLanguage;
      _isSavingLanguage = true;
    });

    try {
      await database.updateUserLanguage(user!.email!, nextLanguage);
      if (!mounted) return;
      await context.setLocale(localeFromLanguageCode(nextLanguage));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        selectedLanguage = previousLanguage;
      });
      await context.setLocale(localeFromLanguageCode(previousLanguage));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(translate('AUTH.REGISTER_ERROR'))));
    } finally {
      if (mounted) {
        setState(() {
          _isSavingLanguage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _SelectedTab _selectedTab = _SelectedTab.settings;

    void _onTapChange(int index) {
      setState(() {
        _selectedTab = _SelectedTab.values[index];
      });

      Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomBackground(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 80),
                  Text('Settings', style: TextStyle(fontSize: 20)),
                  InputDecorator(
                    decoration: InputDecoration(
                      label: Text(translate('EDIT_USER.LANGUAGE')),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        onChanged:
                            _isSavingLanguage
                                ? null
                                : (String? code) async {
                                  if (code == null) return;
                                  await _changeLanguage(code);
                                },
                        items: [
                          DropdownMenuItem(
                            value: 'pt-BR',
                            child: Text(translate('LANGUAGES.PT')),
                          ),
                          DropdownMenuItem(
                            value: 'en',
                            child: Text(translate('LANGUAGES.EN')),
                          ),
                          DropdownMenuItem(
                            value: 'es',
                            child: Text(translate('LANGUAGES.ES')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pushReplacementNamed(context, '/about'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      shadowColor: Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(Icons.question_mark_rounded),
                        Text('About Us', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: ForgebaseCrystalNavigationBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _onTapChange,
      ),
    );
  }
}

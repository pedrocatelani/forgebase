import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/language.dart';
import 'package:forgebase/utils/translate.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translate('AUTH.REGISTER_ERROR'))),
      );
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
    var txtUserEmail = TextEditingController(text: user?.email);
    var txtUserName = TextEditingController(text: user?.displayName ?? '');
    var txtUserPassword = TextEditingController();

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
                  Text('${user?.displayName}', style: TextStyle(fontSize: 20)),
                  TextField(
                    controller: txtUserName,
                    decoration: InputDecoration(
                      label: Text(translate('AUTH.USERNAME')),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                  PasswordField(
                    controller: txtApiKey,
                    decoration: InputDecoration(
                      label: Text(translate('AUTH.API_KEY')),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
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
                        () => showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(translate('AUTH.ENTER_USER_EMAIL')),
                                actions: [
                                  TextField(
                                    controller: txtUserEmail,
                                    decoration: InputDecoration(
                                      label: Text(translate('AUTH.USER_EMAIL')),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed:
                                            () => authService
                                                .changePasswordByEmail(
                                                  txtUserEmail.text,
                                                ),
                                        child: Text(translate('COMMON.SEND')),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(translate('COMMON.CLOSE')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text(
                      translate('EDIT_USER.CHANGE_PASSWORD'),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => database.uploadUserImage(user!.email!, context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text(
                      translate('EDIT_USER.CHANGE_IMAGE'),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text(translate('EDIT_USER.SYNCING_DECKS')),
                              actions: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                ),
                              ],
                            ),
                      );

                      final nav = Navigator.of(context);
                      await database.syncDoK(user!.email!, context);
                      nav.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      backgroundColor: Color.fromARGB(0, 255, 255, 255),
                      shadowColor: Color.fromARGB(0, 255, 255, 255),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(Icons.sync_rounded),
                        Text(
                          translate('EDIT_USER.SYNC_DECKS_WITH_DOK'),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => authService.logout(context),
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
                        Text(
                          translate('EDIT_USER.LOGOUT'),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  translate('EDIT_USER.CONFIRM_DELETE_ACCOUNT'),
                                ),
                                actions: [
                                  PasswordField(
                                    controller: txtUserPassword,
                                    decoration: InputDecoration(
                                      label: Text(translate('AUTH.PASSWORD')),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed:
                                            () => {
                                              authService.deleteUser(
                                                user!.email!,
                                                txtUserPassword.text,
                                                context,
                                              ),
                                            },
                                        child: Text(translate('COMMON.DELETE')),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(translate('COMMON.CLOSE')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        ),
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
                        Text(
                          translate('EDIT_USER.DELETE_ACCOUNT'),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed:
                            () => authService.updateUser(
                              txtUserName.text,
                              user?.email,
                              txtApiKey.text,
                              context,
                            ),
                        child: Text(translate('COMMON.SAVE')),
                      ),
                      ElevatedButton(
                        onPressed:
                            () => Navigator.pushReplacementNamed(
                              context,
                              '/user',
                            ),
                        child: Text(translate('COMMON.BACK')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

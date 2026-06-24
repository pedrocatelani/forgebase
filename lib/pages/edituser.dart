import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
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

  @override
  void initState() {
    super.initState();

    if (user != null) {
      database.getApiKey(user!.email!).then((value) {
        setState(() {
          txtApiKey.text = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var txtUserEmail = TextEditingController(text: user?.email);
    var txtUserName = TextEditingController(text: user?.displayName ?? '');
    var txtUserPassword = TextEditingController();

    final localeKey =
        '${context.locale.languageCode}_${context.locale.countryCode ?? ''}';
    final currentLocaleKey =
        ['pt_BR', 'en_', 'es_'].contains(localeKey) ? localeKey : 'pt_BR';

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
                        value: currentLocaleKey,
                        items: const [
                          DropdownMenuItem(
                            value: 'pt_BR',
                            child: Text('Portugues (Brasil)'),
                          ),
                          DropdownMenuItem(
                            value: 'en_',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: 'es_',
                            child: Text('Espanol'),
                          ),
                        ],
                        onChanged: (String? code) async {
                          if (code == null) return;
                          final parts = code.split('_');
                          final newLocale =
                              parts.length > 1 && parts[1].isNotEmpty
                                  ? Locale(parts[0], parts[1])
                                  : Locale(parts[0]);
                          await context.setLocale(newLocale);
                        },
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

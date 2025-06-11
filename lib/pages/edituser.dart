import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/components/password_field.dart';

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
                      label: Text('Username'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                  PasswordField(
                    controller: txtApiKey,
                    decoration: InputDecoration(
                      label: Text('API Key'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text('Enter your user email'),
                                actions: [
                                  TextField(
                                    controller: txtUserEmail,
                                    decoration: InputDecoration(
                                      label: Text('User email'),
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
                                        child: Text('Send'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close'),
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
                      'Change Password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => database.uploadUserImage(user!.email!, context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                    ),
                    child: Text('Change Image', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      showDialog(barrierDismissible: false, context: context, builder: (context) =>
                        AlertDialog(
                          title: Text("Syncing Decks......"),
                          actions: [Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          )],
                        )
                      );

                      await database.syncDoK(user!.email!, context);

                      Navigator.pop(context);
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
                        Text('Sync decks with Decks of KeyForge', style: TextStyle(fontSize: 18)),
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
                        Text('Logout', style: TextStyle(fontSize: 18)),
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
                                  'Are you sure you want to delete your account?',
                                ),
                                actions: [
                                  PasswordField(
                                    controller: txtUserPassword,
                                    decoration: InputDecoration(
                                      label: Text('Password'),
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
                                        child: Text('Delete'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Close'),
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
                        Text('Delete Account', style: TextStyle(fontSize: 18)),
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
                        child: Text('Save'),
                      ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

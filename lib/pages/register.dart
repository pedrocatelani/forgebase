import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showInstructions = false;
  final String _url = 'https://decksofkeyforge.com/';

  void _launchURL() async {
    final Uri uri = Uri.parse(_url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $_url';
    }
  }

  final List<String> instructionImages = [
    'assets/instructions/instruction11.jpg',
    'assets/instructions/instruction12.jpg',
    'assets/instructions/instruction13.jpg',
    'assets/instructions/instruction14.jpg',
    'assets/instructions/instruction15.jpg',
    'assets/instructions/instruction16.jpg',
    'assets/instructions/instruction17.jpg',
    'assets/instructions/instruction18.jpg',
  ];

  final List<String> instructionTexts = [
    'Step 1: After clicking the link, tap the three-bar icon.',
    'Step 2: Then tap to log in. If you don\'t have an account, go to Sign Up.',
    'Step 3: Once logged in, navigate to the "About" section.',
    'Step 4: Then tap on "APIs".',
    'Step 5: Scroll down the page.',
    'Step 6: Then tap on "Generate API Key".',
    'Step 7: Press and hold your API key.',
    'Step 8: Then tap "Copy" and return to the app.',
  ];

  var txtName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtConfirmPassword = TextEditingController();
  var txtAPIKey = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomBackground(),
            Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 25,
                  children: [
                    Image.asset(
                      'assets/ForgeBase.png',
                      width: 300,
                      height: 250,
                    ),
                    TextField(
                      controller: txtName,
                      decoration: InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    TextField(
                      controller: txtEmail,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    PasswordField(
                      controller: txtPassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    PasswordField(
                      controller: txtConfirmPassword,
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: PasswordField(
                            controller: txtAPIKey,
                            decoration: InputDecoration(
                              hintText: "API Key",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),

                          child: Icon(Icons.question_mark, size: 20),

                          onPressed: () {
                            setState(() {
                              _showInstructions = true;
                            });
                          },
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed:
                          () => authService.register(
                            txtName.text,
                            txtEmail.text.trim(),
                            txtPassword.text.trim(),
                            txtConfirmPassword.text.trim(),
                            txtAPIKey.text.trim(),
                            context,
                          ),
                      child: Text("Register"),
                    ),
                  ],
                ),
              ),
            ),

            if (_showInstructions)
              Container(
                color: const Color.fromARGB(37, 115, 0, 86),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "How to Get the Api Key?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 280,
                          child: CarouselSlider.builder(
                            itemCount: instructionImages.length,
                            itemBuilder: (context, index, realIndex) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 180,
                                      child: Image.asset(
                                        instructionImages[index],
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Flexible(
                                      child: Text(
                                        instructionTexts[index],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 280,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                              enableInfiniteScroll: true,
                              pauseAutoPlayOnTouch: true,
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: _launchURL,
                          child: Text(
                            _url,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed:
                                  () => setState(() {
                                    _showInstructions = false;
                                  }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  138,
                                  16,
                                  159,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'Ok',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

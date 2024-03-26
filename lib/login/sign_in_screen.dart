import 'dart:ui';

import 'package:estacionamiento_uaem/dto/bg_data.dart';
import 'package:estacionamiento_uaem/screens/home_screen.dart';
import 'package:estacionamiento_uaem/utils/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      // print('Error signing in with Google: $e');
    }
  }

  int selectedIndex = 0;
  bool showOption = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Bienvenido",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_sharp),
              color: Colors.white,
              onPressed: () => _onBackButtonPressed(context),
            );
          },
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: showOption
                    ? ShowUpAnimation(
                        delay: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: bgList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: selectedIndex == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                        bgList[index],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : const SizedBox()),
            const SizedBox(
              width: 20,
            ),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            bgList[selectedIndex],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bgList[selectedIndex]), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 450,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Spacer(),
                      // Center(
                      //     child: TextUtil(
                      //   text: "Iniciar Sesión",
                      //   weight: true,
                      //   size: 30,
                      // )),
                      // const Spacer(),
                      // TextUtil(
                      //   text: "Correo",
                      // ),
                      // Container(
                      //   height: 35,
                      //   decoration: const BoxDecoration(
                      //       border: Border(
                      //           bottom: BorderSide(color: Colors.white))),
                      //   child: TextFormField(
                      //     maxLength: 30,
                      //     inputFormatters: <TextInputFormatter>[
                      //       FilteringTextInputFormatter.allow(
                      //           RegExp("[0-9@a-zA-Z.]")),
                      //     ],
                      //     autocorrect: false,
                      //     autovalidateMode: AutovalidateMode.onUserInteraction,
                      //     keyboardType: TextInputType.emailAddress,
                      //     textInputAction: TextInputAction.done,
                      //     style: const TextStyle(color: Colors.white),
                      //     decoration: const InputDecoration(
                      //       suffixIcon: Icon(
                      //         Icons.mail,
                      //         color: Colors.white,
                      //       ),
                      //       fillColor: Colors.white,
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      // const Spacer(),
                      // TextUtil(
                      //   text: "Contraseña",
                      // ),
                      // Container(
                      //   height: 35,
                      //   decoration: const BoxDecoration(
                      //       border: Border(
                      //           bottom: BorderSide(color: Colors.white))),
                      //   child: TextFormField(
                      //     obscuringCharacter: "•",
                      //     obscureText: true,
                      //     smartDashesType: SmartDashesType.enabled,
                      //     smartQuotesType: SmartQuotesType.enabled,
                      //     style: const TextStyle(color: Colors.white),
                      //     decoration: const InputDecoration(
                      //       suffixIcon: Icon(
                      //         Icons.lock,
                      //         color: Colors.white,
                      //       ),
                      //       fillColor: Colors.white,
                      //       border: InputBorder.none,
                      //     ),
                      //   ),
                      // ),
                      // const Spacer(),
                      // Row(
                      //   children: [
                      //     Container(
                      //       height: 15,
                      //       width: 15,
                      //       color: Colors.white,
                      //     ),
                      //     const SizedBox(
                      //       width: 10,
                      //     ),
                      //     Expanded(
                      //         child: TextUtil(
                      //       text: "Recordar             Olvide mi contraseña",
                      //       size: 12,
                      //       weight: true,
                      //     ))
                      //   ],
                      // ),
                      const Spacer(),
                      Container(
                        height: 300,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/park_sinfondo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () => signInWithGoogle(context),
                      //   child: Container(
                      //     height: 40,
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(30)),
                      //     alignment: Alignment.center,
                      //     child: TextUtil(
                      //       text: "Ingresar",
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => signInWithGoogle(context),
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google.png',
                                height: 45,
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                'Continuar con Google',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Center(
                      //   child: RichText(
                      //     text: TextSpan(
                      //       text: "No tienes una cuenta  ",
                      //       children: <TextSpan>[
                      //         TextSpan(
                      //           text: 'REGISTRATE',
                      //           style: TextStyle(
                      //               color: Colors.blue.shade50,
                      //               fontWeight: FontWeight.bold),
                      //           recognizer: TapGestureRecognizer()
                      //             ..onTap = () {
                      //               Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                       builder: (context) =>
                      //                           const SignUpPage()));
                      //             },
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const Spacer(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Salir de la aplicación"),
          content: const Text("¿Quieres salir de la aplicación?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text("Si"),
            ),
          ],
        );
      },
    );
    return exitApp;
  }
}

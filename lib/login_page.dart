import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/loading_dialog.dart';
import 'package:rive_animation/success_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //login_information
  String validUserName = "Mhtprogrammer";
  String validPassword = "programmer1234";

  //input form controller
  FocusNode userName = FocusNode();
  TextEditingController userNameController = TextEditingController();

  FocusNode password = FocusNode();
  TextEditingController passwordController = TextEditingController();

  //rive controllers and inputs --start
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  //rive controllers and inputs --end

  @override
  void initState() {
    userName.addListener(userNameFocus);
    password.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    userName.removeListener(userNameFocus);
    password.removeListener(passwordFocus);
    super.dispose();
  }

  //create_func
  void userNameFocus() {
    isChecking?.change(userName.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(password.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "Example of Rive animation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 5.0,
                ),

                //animation --start
                SizedBox(
                  height: 300.0,
                  width: 400.0,
                  child: RiveAnimation.asset(
                    "assets/login.riv",
                    fit: BoxFit.fitHeight,
                    stateMachines: const ["Login Machine"],
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                        artboard,

                        //from rive.You can see it in rive editor
                        "Login Machine",
                      );
                      if (controller == null) return;
                      artboard.addController(controller!);
                      isChecking = controller!.findInput("isChecking");
                      numLook = controller!.findInput("numLook");
                      isHandsUp = controller!.findInput("isHandsUp");
                      trigSuccess = controller!.findInput("trigSuccess");
                      trigFail = controller!.findInput("trigFail");
                    },
                  ),
                ),
                //animation --end
                const SizedBox(
                  height: 20.0,
                ),

                //field_one
                SizedBox(
                  height: 50.0,
                  width: 340.0,
                  child: TextField(
                    focusNode: userName,
                    controller: userNameController,
                    onChanged: (value) {
                      numLook?.change(value.length.toDouble());
                    },
                    decoration: const InputDecoration(
                      fillColor: Colors.pink,
                      filled: true,
                      labelText: "UserName",
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),

                //field_two
                SizedBox(
                  height: 50.0,
                  width: 340.0,
                  child: TextFormField(
                    controller: passwordController,
                    focusNode: password,
                    decoration: const InputDecoration(
                      fillColor: Colors.pink,
                      filled: true,
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),

                //login_button
                ElevatedButton(
                  onPressed: () async {
                    userName.unfocus();
                    password.unfocus();
                    final String userNameText = userNameController.text;
                    final String passwordText = passwordController.text;

                    showLoadingDialog(context);
                    await Future.delayed(
                      const Duration(milliseconds: 2000),
                    );
                    if (mounted) {
                      Navigator.pop(context);
                    }

                    if (userNameText == validUserName &&
                        passwordText == validPassword) {
                      trigSuccess!.change(true);
                      await Future.delayed(
                        const Duration(
                          seconds: 2,
                        ),
                      );
                      final navigatorVar = Navigator.of(context);
                      navigatorVar.push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return const Success();
                          },
                        ),
                      );
                    } else {
                      passwordController.clear();
                      trigFail!.change(true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    minimumSize: const Size(200.0, 40.0),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

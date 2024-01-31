import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/components/inputs/email.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/network_handler.dart';
import 'package:your_blog/pages/home.dart';
import 'package:your_blog/pages/sign_up.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/inputs/password.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  final storage = const FlutterSecureStorage();
  var log = Logger();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> output;
    Response response;
    Map<String, String> body;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  emailInput(_emailController),
                  const SizedBox(height: 20,),
                  PasswordInput(controller: _passwordController, update: false,),
                  /*TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  mainButton(
                      context,
                      loading,
                      "Sign In",
                          () async => {
                        setState(() {
                          loading = true;
                        }),
                        if (_globalKey.currentState!.validate()) {
                          body = {
                            "email": _emailController.text,
                            "password": _passwordController.text,
                          },
                          response = await networkHandler.post("/users/login.php", body, {}),
                          output = json.decode(response.body),
                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(output["message"]),
                                )
                            ),
                            await storage.write(key: "userId", value: output["user"]["userId"]),
                            setState(() {
                              loading = false;
                            }),
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false)
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(output["error"]),
                                )
                            ),
                            setState(() {
                              loading = false;
                            })
                          },
                        } else {
                          setState(() {
                            loading = false;
                          })
                        }
                      }
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account yet ?", style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17,
                      ),),
                      const SizedBox(width: 5,),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpPage(),));
                        },
                        child: const Text("Sign up", style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      )
    );
  }
}
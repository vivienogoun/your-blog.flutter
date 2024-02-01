import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/inputs/fullname.dart';
import 'package:your_blog/components/inputs/password.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/network_handler.dart';
import 'package:your_blog/pages/sign_in.dart';

import '../components/inputs/email.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _fullnameController = TextEditingController();
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
                    "Create your account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  fullnameInput(_fullnameController),
                  const SizedBox(height: 20,),
                  emailInput(_emailController),
                  const SizedBox(height: 20,),
                  PasswordInput(controller: _passwordController, update: false,),
                  const SizedBox(
                    height: 20,
                  ),
                  mainButton(
                      context,
                      loading,
                      "Sign Up",
                          () async => {
                        setState(() {
                          loading = true;
                        }),
                        if (_globalKey.currentState!.validate()) {
                          body = {
                            "email": _emailController.text,
                            "fullName": _fullnameController.text,
                            "password": _passwordController.text,
                          },
                          response = await networkHandler.post("/users/register.php", body, {}),
                          if (response.statusCode == 500) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Something went wrong. Try again"),
                                )
                            ),
                            setState(() {
                              loading = false;
                            })
                          } else if (response.body.contains("SQLSTATE")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Email already used"),
                                )
                            ),
                            setState(() {
                              loading = false;
                            })
                          } else {
                            output = json.decode(response.body),
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(output["message"]),
                                  )
                              ),
                              setState(() {
                                loading = false;
                              }),
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage()))
                            } else {
                              setState(() {
                                loading = false;
                              })
                            },
                          }
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
                      const Text("Already have an account ?", style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17,
                      ),),
                      const SizedBox(width: 5,),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignInPage(),));
                          },
                          child: const Text("Sign in", style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ))
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
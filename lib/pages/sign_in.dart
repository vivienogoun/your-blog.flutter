import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:your_blog/network_handler.dart';
import 'package:your_blog/pages/home.dart';
import 'package:your_blog/pages/sign_up.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showPassword = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Map<String, String> data;
    Map<String, dynamic> output;
    Response response;

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
          child: Form(
            key: _globalKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter your account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  usernameInput(),
                  passwordInput(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot password ?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FilledButton(
                        onPressed: () async => {
                          setState(() {
                            loading = true;
                          }),
                          if (_globalKey.currentState!.validate()) {
                            data = {
                              "username": _usernameController.value.text,
                              "password": _passwordController.value.text,
                            },
                            print(data),
                            response = await networkHandler.post("products/add", data),
                            output = json.decode(response.body),
                            if (response.statusCode == 200 || response.statusCode == 201) {
                              print(output["id"]),
                              await storage.write(key: "id", value: '$output["id"]'),
                              setState(() {
                                loading = false;
                              }),
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false)
                            } else {
                              print(output["error"]),
                              setState(() {
                                loading = false;
                              })
                            },
                          } else {
                            setState(() {
                              loading = false;
                            })
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStatePropertyAll<Size>(
                              Size(MediaQuery.of(context).size.width, 60.0)
                          ),
                          backgroundColor: const MaterialStatePropertyAll<Color>(Colors.black87),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: loading ? const CircularProgressIndicator(
                          color: Colors.white,
                        ) : const Text("Sign In", style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),)
                    ),
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
              ),
            )
          )
      ),
    );
  }

  Widget usernameInput() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          validator: (value) {
            if (value!.isEmpty) return "Username can't be empty";
            return null;
          },
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                )
            ),
            labelText: "Username",
          ),
        )
      ],
    );
  }

  Widget passwordInput() {
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value!.isEmpty) return "Password can't be empty";
            if (value.length < 8) return "Password should have more than 8 characters";
            return null;
          },
          obscureText: showPassword,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility)
              ),
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  )
              ),
              labelText: "Password"
          ),
        )
      ],
    );
  }
}
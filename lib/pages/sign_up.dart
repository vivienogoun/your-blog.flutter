import 'package:flutter/material.dart';
import 'package:your_blog/network_handler.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool showPassword = true;
  final _globalKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorText = "";
  bool validate = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Map<String, String> data;

    return Scaffold(
      body: Container(
        //height: MediaQuery.of(context).size.height,
        //width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black12,
        ),
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20,),
              usernameInput(),
              emailInput(),
              passwordInput(),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () async => {
                    setState(() {
                      loading = true;
                    }),
                    if (_globalKey.currentState!.validate()) {
                      data = {
                        "username": _usernameController.value.text,
                        "email": _emailController.value.text,
                        "password": _passwordController.value.text,
                      },
                      print(data),
                      await networkHandler.post("products/add", data),
                      setState(() {
                        loading = false;
                      }),
                    } else {
                      setState(() {
                        loading = false;
                      })
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll<Size>(
                        Size(270.0, 60.0)
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
                  ) : const Text("Sign Up", style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),)
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
          ),
        )
      ),
    );
  }

  Widget usernameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Column(
        children: [
          TextFormField(
            controller: _usernameController,
            validator: (value) {
              if (value!.isEmpty) return "Username can't be empty";
              // verify if username is unique
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
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty) return "Email can't be empty";
              if (!value.contains("@")) return "Email is invalid";
              // verify if email is unique
              return null;
            },
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    )
                ),
              labelText: "Email",
            ),
          )
        ],
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Column(
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
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/pages/sign_up.dart';
import 'package:your_blog/pages/sign_in.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});


  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: baseContainer(
        context,
        false,
        const EdgeInsets.symmetric(
          vertical: 60.0,
          horizontal: 20.0,
        ),
        Column(
        children: [
          const Text(
            "Welcome to",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const Text(
            "YourBlog",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 60,),
          Image.asset("assets/graphics.png"),
          const SizedBox(height: 60,),
          OutlinedButton(
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignInPage(),))
            },
            style: ButtonStyle(
              fixedSize: MaterialStatePropertyAll<Size>(
                  Size(MediaQuery.of(context).size.width, 50.0)
              ),
              backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white70),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            child: const Text("Login", style: TextStyle(
              color: Colors.black87,
              fontSize: 18.0,
            )),
          ),
          //boxContainer("assets/google.png", "Sign up with Google"),
          const SizedBox(height: 30,),
          const Text("New here ?", textAlign: TextAlign.center,),
          //boxContainer("assets/facebook.png", "Sign up with Facebook"),
          const SizedBox(height: 10,),
          mainButton(
              context,
              false,
              "Register",
                  () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage(),));
          }),
        ],
      )
      )
    );
  }
}
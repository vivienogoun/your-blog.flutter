import 'package:flutter/material.dart';
import 'package:your_blog/components/base_container.dart';
import 'package:your_blog/components/main-button.dart';
import 'package:your_blog/pages/sign_up.dart';
import 'package:your_blog/pages/sign_in.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseContainer(
        padding: EdgeInsets.symmetric(
          vertical: (MediaQuery.of(context).size.height)/12,
          horizontal: 20.0,
        ),
        white: false,
        child: Column(
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
              "Your Blog",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height)/15,
            ),
            Image.asset(
              "assets/graphics.png",
              height: (MediaQuery.of(context).size.height)/2.5,
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height)/15,
            ),
            OutlinedButton(
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignInPage(),)
                )
              },
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll<Size>(
                    Size(MediaQuery.of(context).size.width, 40.0)
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
                fontSize: 16.0,
              )),
            ),
            SizedBox(
              height: (MediaQuery.of(context).size.height)/30,
            ),
            const Text("New here ?", textAlign: TextAlign.center,),
            SizedBox(
              height: (MediaQuery.of(context).size.height)/60,
            ),
            MainButton(
              text: 'Register',
              loading: false,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignUpPage(),)
                );
              },
            ),
          ],
        ),
      )
    );
  }
}
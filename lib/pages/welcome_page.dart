import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});


  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.deepOrange.shade200
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.repeated,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            children: [
              const Text(
                "YourBlog",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              //SizedBox(height: MediaQuery.of(context).size.height/6,),
              const Text(
                "Don't worry, we mean it.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 50,),
              Image.asset("assets/graphics.png"),
              const SizedBox(height: 50,),
              boxContainer("assets/google.png", "Sign up with Google"),
              const SizedBox(height: 20,),
              boxContainer("assets/facebook.png", "Sign up with Facebook"),
              const SizedBox(height: 20,),
              boxContainer("assets/email.png", "Sign up with Email"),
              const SizedBox(height: 20,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account ?", style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),),
                  SizedBox(width: 10,),
                  Text("Sign in", style: TextStyle(
                    color: Colors.green,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget boxContainer(String path, String text) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width-125,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Image.asset(path, height: 25, width: 25,),
              const SizedBox(width: 20,),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
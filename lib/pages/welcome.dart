import 'package:flutter/material.dart';
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black12,
          /*gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.deepOrange.shade200
            ],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.repeated,
          )*/
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
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
                "Don't worry, we mean it",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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
                  fixedSize: const MaterialStatePropertyAll<Size>(
                      Size(270.0, 60.0)
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
                  fontSize: 20.0,
                )),
              ),
              //boxContainer("assets/google.png", "Sign up with Google"),
              const SizedBox(height: 30,),
              const Text("New here ?"),
              //boxContainer("assets/facebook.png", "Sign up with Facebook"),
              const SizedBox(height: 10,),
              FilledButton(
                onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage(),))
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
                child: const Text("Register", style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),)
              )
              /*boxContainer("assets/email.png", "Sign up with Email"),
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
              )*/
            ],
          ),
        ),
      ),
    );
  }
  /*Widget boxContainer(String path, String text) {
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
  }*/
}
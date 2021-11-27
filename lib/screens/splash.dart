import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/screens/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(
      Duration(milliseconds: 1500),
        () {}
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homepage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0
              ),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: Image(
                  image: AssetImage(
                    "assets/icons8-exam-96.png"
                  ),
                ),
              ),
            ),
            Container(
                child: Text(
                "WHAT TO DO..",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
              ),
            )),
          ],
        ),
      ),
    );
  }
}

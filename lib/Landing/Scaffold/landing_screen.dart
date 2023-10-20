import 'package:flutter/material.dart';
import 'package:swallow/Common/Widgets/button.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';

//TODO tökélesíteni
class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void proceedtoLogin(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text("Üdvözlünk", style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600,
              ),
            ),
             SizedBox(height: size.height /10),
            //TODO kép esetleg valami szöveg
            SizedBox(height: size.height / 10),
            CustomButton('Elfogadom', () => proceedtoLogin(context))
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:swallow/Screens/Login/phone_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void login(BuildContext context) {
    Navigator.pushNamed(context, PhoneScreen.route);
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text("Üdvözlünk a swallowban", style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text("Már vártunk rád", style: TextStyle(
                 fontSize: 26,
                  fontWeight: FontWeight.w400
               ),),
              const SizedBox(height: 60),
              const Icon(Icons.email_outlined, size: 190.0,color: Colors.lightBlue,),
              SizedBox(height: size.height / 10),
              const Text("'A tovább gomb megnyomásával, elfogadod szerződési és felhasználási feltételeinket.'", style: TextStyle(
                  fontSize: 9,
              ),),
              ElevatedButton(onPressed: () => login(context), child: const Text("Tovább"))
            ],
          ),
        ),
      ),
    );
  }
}


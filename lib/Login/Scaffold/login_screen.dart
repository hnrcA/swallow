import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Widgets/button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:swallow/Login/controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const route= '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final controller = TextEditingController();
  Country? country;

  void chooseCountry () {
    showCountryPicker(context: context, onSelect: (Country _country) {
      setState(() {
        country = _country;
      });
    });
  }

  void sendNumber() {
    String number = controller.text.trim();
    if(country != null && number.isNotEmpty) {
      ref.read(controllerProvider).signInWithPhone(context, '+${country!.phoneCode}$number');
    }
}

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add meg a telefonszámod"),
        elevation: 10,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Erősítsd meg a telefonszámod"),
            const SizedBox(height: 10,),
            TextButton(onPressed: chooseCountry,
                 child: const Text("Válassz hívót"),
            ),
            const SizedBox(height: 10),
             Row(
              children: [
                if(country!=null)
                 Text('+${country!.phoneCode}'),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width*0.7,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Telószám',
                    ),
                  ) ,
                ),
              ],
            ),
            SizedBox(height: size.height*0.6),
            SizedBox(
              width: 90,
              child: CustomButton(
                  'Tovább',
                  sendNumber
              ),
            ),
          ],
        ),
      ),
    );
  }
}


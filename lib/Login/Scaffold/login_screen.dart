import 'package:flutter/material.dart';
import 'package:swallow/Common/Widgets/button.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  static const route= '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = TextEditingController();
  Country? country;

  void chooseCountry () {
    showCountryPicker(context: context, onSelect: (Country _country) {
      setState(() {
        country = _country;
      });
    });

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
                "Tovább",
                  (){},
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:swallow/Controllers/auth_controller.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  static const String route= '/login';
  const PhoneScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<PhoneScreen> {
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
      ref.read(authControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$number');
    }
}

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add meg a telefonszámod"),
        elevation: 10,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Fiókodba való bejelentkezéshez,"
                  " illetve regisztrációjához "
                  "szükséged lesz a telefonszámodra,"
                  "mely alapján azonosítunk téged.", textAlign: TextAlign.center,),
              const SizedBox(height: 10,),
              TextButton(onPressed: chooseCountry,
                   child: const Text("Válaszd ki országod hívószámát"),
              ),
              const SizedBox(height: 10),
               Row(
                children: [
                  if(country!=null)
                   Padding(
                     padding: const EdgeInsets.only(bottom: 21.0),
                     child: Text('+${country!.phoneCode}', style: const TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                     ),),
                   ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: size.width*0.7,
                    child: TextFormField(
                      controller: controller,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 15,
                      decoration: const InputDecoration(
                        hintText: 'Telefonszámod',
                        border: InputBorder.none,
                      ),
                    ) ,
                  ),
                ],
              ),
              SizedBox(height: size.height*0.01),
              SizedBox(
                width: 90,
                child: ElevatedButton(onPressed: sendNumber,child: const Text("Tovább"),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}


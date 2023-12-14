import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Screens/Login/user_screen.dart';
import 'package:swallow/Services/authService.dart';

class OtpScreen extends ConsumerWidget {
  static const String route= '/otp';
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyCode(BuildContext context, String code, WidgetRef ref) {
    ref.read(authServiceProvider).verifyCode(context, verificationId, code);
    Navigator.pushNamedAndRemoveUntil(context, UserScreen.route, (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hitelesítés"),
        elevation: 10,
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text("Az azonosításhoz szükséges sms kiküldésre került!"),
            const SizedBox(height: 25),
            SizedBox(
              width: size.width*0.6,
              child:  TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                onChanged: (value) {
                  if(value.length == 6) {
                    verifyCode(context, value.trim(), ref);
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'Megerősítő kód'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

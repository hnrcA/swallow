import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Services/auth.dart';

class OtpScreen extends ConsumerWidget {
  static const String route= '/otp';
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyCode(BuildContext context, String code, WidgetRef ref) {
    ref.read(authServiceProvider).verifyCode(context, verificationId, code);
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
              child:  TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Megerősítő kód'
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if(value.length == 6) {
                    verifyCode(context, value.trim(), ref);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

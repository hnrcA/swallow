import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Login/auth.dart';

class OtpScreen extends ConsumerWidget {
  static const route= '/otp';
  final String verificationId;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  void verifyCode(BuildContext context, String code, WidgetRef ref) {
    ref.read(authProvider).verifyCode(context, verificationId, code);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Erősítd meg a telefonszámot"),
        elevation: 10,
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text("Az sms kiküldésre került!"),
            SizedBox(
              width: size.width*0.4,
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
            SizedBox(height: size.height*0.2),
            const Text("Gomb helye")
          ],
        ),
      ),
    );
  }
}

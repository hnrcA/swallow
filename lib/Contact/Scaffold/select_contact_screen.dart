import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Contact/controller.dart';

class ContactScreen extends ConsumerWidget {
  static const String route = '/contact';
  const ContactScreen({Key? key}) : super(key: key);

  void selectContact(BuildContext context, WidgetRef ref, Contact contact) {
    ref.read(contactControllerProvider).selectContact(context, contact);
  }

  //TODO IKON 127
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Válassz kontaktot'),
      ),
      body: ref.watch(getContactProvider).when(
          data: (contactList) => ListView.builder(itemCount: contactList.length ,itemBuilder: (context, index) {
            final contact = contactList[index];
            return InkWell(
              onTap: () => selectContact(context, ref, contact),
              child: ListTile(
                title: Text(contact.displayName),
                //TODO finomítás
              ),
            );
          }),
          error: (err, trace) => Text(err.toString()),
          loading: () => const Loader()),
    );
  }
}

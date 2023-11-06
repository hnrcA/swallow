import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Firebase/contact.dart';


final getContactProvider = FutureProvider((ref) {
  final selectContact = ref.watch(selectContactProvider);
  return selectContact.getContact();
});

final contactControllerProvider = Provider((ref)  {
  final selectedContact = ref.watch(selectContactProvider);
  return ContactController(ref, selectedContact);
});

class ContactController {
  final ProviderRef ref;
  final SelectContact selectedContact;

  ContactController(this.ref, this.selectedContact);

  void selectContact(BuildContext context,Contact contact) {
    selectedContact.selectContact(context, contact);
  }
}
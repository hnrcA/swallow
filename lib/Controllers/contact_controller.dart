import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Services/contact.dart';

//region riverpod providers
final getContactProvider = FutureProvider((ref) {
  final selectContact = ref.watch(contactServiceProvider);
  return selectContact.getContact();
});

final contactControllerProvider = Provider((ref)  {
  final selectedContact = ref.watch(contactServiceProvider);
  return ContactController(ref, selectedContact);
});
//endregion

class ContactController {
  final ProviderRef ref;
  final ContactService contactService;

  ContactController(this.ref, this.contactService);

  void selectContact(BuildContext context,Contact contact) {
    contactService.selectContact(context, contact);
  }
}
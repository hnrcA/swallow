class ChatContact {
  final String name;
  final String picture;
  final String id;
  final DateTime sent;
  final String lastMessage;

  ChatContact({required this.name, required this.picture, required this.id, required this.sent, required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "picture": picture,
      "id": id,
      "sent": sent.millisecondsSinceEpoch,
      "lastMessage": lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map["name"] ?? '',
      picture: map["picture"] ?? '',
      id: map["id"] ?? '',
      sent: DateTime.fromMillisecondsSinceEpoch(map['sent']),
      lastMessage: map["lastMessage"] ?? '',
    );
  }
//
}
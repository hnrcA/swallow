import 'package:swallow/Common/Enum/message.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String messageId;
  final String message;
  final DateTime sent;
  final bool seen;
  final MessageEnum type;

  Message({required this.senderId, required this.recieverId, required this.messageId, required this.message, required this.sent, required this.seen, required this.type});


  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "recieverId": recieverId,
      "messageId": messageId,
      "message": message,
      "sent": sent.millisecondsSinceEpoch,
      "seen": seen,
      "type": type.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map["senderId"] ?? '',
      recieverId: map["recieverId"]?? '',
      messageId: map["messageId"]?? '',
      message: map["message"]?? '',
      sent: DateTime.fromMillisecondsSinceEpoch(map['sent']),
      seen: map["seen"] ?? false,
      type: (map["type"] as String).toEnum(),
    );
  }
//
}
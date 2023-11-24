import 'package:swallow/Common/Enum/message.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String messageId;
  final String message;
  final DateTime sent;
  final bool seen;
  final MessageEnum type;

  MessageModel({required this.senderId, required this.receiverId, required this.messageId, required this.message, required this.sent, required this.seen, required this.type});


  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "receiverId": receiverId,
      "messageId": messageId,
      "message": message,
      "sent": sent.millisecondsSinceEpoch,
      "seen": seen,
      "type": type.type,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map["senderId"] ?? '',
      receiverId: map["receiverId"]?? '',
      messageId: map["messageId"]?? '',
      message: map["message"]?? '',
      sent: DateTime.fromMillisecondsSinceEpoch(map['sent']),
      seen: map["seen"] ?? false,
      type: (map["type"] as String).toEnum(),
    );
  }
//
}
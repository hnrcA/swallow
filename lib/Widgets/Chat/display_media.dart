import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swallow/Widgets/Chat/video_player.dart';
import 'package:swallow/Common/Enum/message.dart';

class DisplayMedia extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;


  const DisplayMedia(this.message, this.messageEnum, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (messageEnum) {
      case MessageEnum.picture :
        return CachedNetworkImage(imageUrl: message);
      case MessageEnum.video :
        return VideoPlayer(message);
      default:
      return Text(
        message,
        style: const TextStyle(
          fontSize: 16,
        ),
      );
    }
  }
}

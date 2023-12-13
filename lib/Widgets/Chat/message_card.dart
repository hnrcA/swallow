import 'package:flutter/material.dart';
import 'package:swallow/Widgets/Chat/display_media.dart';
import 'package:swallow/Common/Enum/message.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageEnum;
  final bool seen;

  const MessageCard({Key? key, required this.message, required this.date, required this.messageEnum, required this.seen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
          minWidth:MediaQuery.of(context).size.width- 260,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          color: Colors.grey,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: messageEnum.type == MessageEnum.text.type ? const EdgeInsets.only(
                  left: 40,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ): const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 5,
                  bottom: 25,
                ),
                child: DisplayMedia(message, messageEnum),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style:const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                     seen ?  Icons.remove_red_eye_outlined: Icons.done,
                      size: 20,
                      color: seen ? Colors.purple : Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
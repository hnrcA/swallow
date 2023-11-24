import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Chat/controller.dart';
import 'package:swallow/Common/common.dart';
import '../../Common/Enum/message.dart';


class BottomChat extends ConsumerStatefulWidget {
  final String recieverId;
  const BottomChat({
    Key? key,
    required this.recieverId
}) : super (key: key);


  @override
  ConsumerState<BottomChat> createState() => _BottomChatState();
}

class _BottomChatState extends ConsumerState<BottomChat> {
  final TextEditingController _messageController = TextEditingController();


  void sendMessage() {
    ref.read(chatControllerProvider).sendMessage(context, _messageController.text.trim(), widget.recieverId);
    setState(() {
      _messageController.text = '';
    });
  }

  void sendPicture(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendPicture(context, file, widget.recieverId, messageEnum);
  }

  void selectPicture() async {
    File? picture = await chooseImage(context);
    if (picture!= null) {
      sendPicture(picture, MessageEnum.picture);
    }
  }

  void selectVideo() async {
    File? video = await chooseVideo(context);
    if (video!= null) {
      sendPicture(video, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSendable = false;
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 7,
              left: 25,
            ),
            child: TextFormField(
              controller: _messageController,
              onChanged: (val) {
                if(val.isNotEmpty) {
                  setState(() {
                    isSendable = true;
                  });
                } else {
                  setState(() {
                    isSendable = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueGrey,
                suffixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: selectPicture, icon: const Icon(Icons.image), color: Colors.white),
                      IconButton(onPressed: selectVideo, icon: const Icon(Icons.movie_filter), color: Colors.white),
                    ],
                  ),
                ),
                hintText: 'Üzenj valamit!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(
              bottom: 5,
              right: 2,
              left: 1,
            ),
            child: IconButton(onPressed: _messageController.text.isEmpty ? null : sendMessage, icon: const Icon(Icons.send), color: Colors.lightBlue,)),
      ],
    );
  }
}

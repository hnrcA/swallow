import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Chat/controller.dart';


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

  void sendMessage() async {
    ref.read(chatControllerProvider).sendMessage(context, _messageController.text.trim(), widget.recieverId);
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 7,
              left: 25,
            ),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                suffixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)), //TODO prefix ha kell
                    ],
                  ),
                ),
                hintText: 'Type a message!',
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
            child: IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))),
      ],
    );
  }
}

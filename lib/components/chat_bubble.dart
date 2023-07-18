import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Color color;
  final String message;
  final Color textColor;
  final String messageTime;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.color,
      required this.textColor,
      required this.messageTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: TextStyle(color: textColor),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                messageTime.toString(),
                style: const TextStyle(color: Colors.amber),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Color color;
  final String message;
  const ChatBubble({super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Text(message),
      ),
    );
  }
}

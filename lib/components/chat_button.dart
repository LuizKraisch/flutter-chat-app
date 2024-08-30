import 'package:chat_app/components/chat_text.dart';
import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;
  final double padding;
  final double margin;

  const ChatButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.padding,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(padding),
        margin: EdgeInsets.symmetric(horizontal: margin),
        child: Center(
          child: ChatText(
            text: label,
            size: 15,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}

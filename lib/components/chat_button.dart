import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          child: Text(
            label,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

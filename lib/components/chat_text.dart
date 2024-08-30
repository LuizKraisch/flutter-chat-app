import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight? fontWeight;
  final Color color;

  const ChatText({
    super.key,
    required this.text,
    required this.size,
    this.fontWeight = FontWeight.normal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}

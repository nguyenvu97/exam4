import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Text_Data extends StatelessWidget {
  String name;
  Color? color;
  double size;
  int maxLine;
  Text_Data(
      {super.key,
      required this.name,
      required this.color,
      required this.size,
      required this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        name,
        maxLines: maxLine,
        style: GoogleFonts.headlandOne(
            color: color, fontWeight: FontWeight.bold, fontSize: size),
      ),
    );
  }
}

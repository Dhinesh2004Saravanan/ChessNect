import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/Constants/colors.dart';

class Savedpage extends StatefulWidget {
  const Savedpage({super.key});

  @override
  State<Savedpage> createState() => _SavedpageState();
}

class _SavedpageState extends State<Savedpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        title: Text(
          'Saved',
          style: GoogleFonts.aBeeZee(fontSize: 18),
        ),
      ),
    );
  }
}

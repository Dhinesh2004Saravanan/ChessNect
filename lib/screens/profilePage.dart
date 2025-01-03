import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        title: Text(
          'Profile',
          style: GoogleFonts.aBeeZee(fontSize: 18),
        ),
      ),
    );
  }
}

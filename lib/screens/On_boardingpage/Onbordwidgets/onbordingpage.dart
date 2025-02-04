import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/Constants/colors.dart';

class Onbordingpage extends StatelessWidget {
  const Onbordingpage({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final double screenWidth;
  final double screenHeight;
  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image(
            width: screenWidth * 0.8,
            height: screenHeight * 0.6,
            image: AssetImage(image),
          ),
          Text(
            '$title',
            style:
                GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "$subtitle",
            style: GoogleFonts.aBeeZee(
              fontSize: 16,
              color: TColors.texthint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

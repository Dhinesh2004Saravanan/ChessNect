import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utils/Controllers/Onbording_controller/onbording_controller.dart';

class skiponbording extends StatelessWidget {
  const skiponbording({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 8,
        child: TextButton(
            onPressed: () => OnBordingController.instance.skipPage(),
            child: Text(
              'Skip',
              style: GoogleFonts.aBeeZee(fontSize: 16, color: TColors.primary),
            )));
  }
}

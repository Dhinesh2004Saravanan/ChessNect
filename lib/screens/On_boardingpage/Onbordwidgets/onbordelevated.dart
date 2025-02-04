import 'package:flutter/material.dart';

import '../../../Utils/Constants/colors.dart';
import '../../../Utils/Controllers/Onbording_controller/onbording_controller.dart';

class onbordelevate extends StatelessWidget {
  const onbordelevate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 10,
        bottom: 35,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(), backgroundColor: TColors.primary),
            onPressed: () => OnBordingController.instance.nextPage(),
            child: Icon(
              Icons.arrow_forward_ios,
              color: TColors.iconsecondary,
              size: 20,
            )));
  }
}

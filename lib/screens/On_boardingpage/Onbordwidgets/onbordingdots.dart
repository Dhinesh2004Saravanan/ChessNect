import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Utils/Constants/colors.dart';
import '../../../Utils/Controllers/Onbording_controller/onbording_controller.dart';

class onbordingdots extends StatelessWidget {
  const onbordingdots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBordingController.instance;
    return Positioned(
        bottom: 35,
        left: 8,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
              activeDotColor: TColors.primary, dotHeight: 4),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Constants/colors.dart';
import '../../Utils/Constants/onbordtext.dart';
import '../../Utils/Controllers/Onbording_controller/onbording_controller.dart';
import 'Onbordwidgets/onbordelevated.dart';
import 'Onbordwidgets/onbordingdots.dart';
import 'Onbordwidgets/onbordingpage.dart';
import 'Onbordwidgets/skipbbording.dart';

class Onboarding extends StatefulWidget {
  const Onboarding(BuildContext context, {super.key});

  @override
  State<Onboarding> createState() => OnboardingState();
}

class OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBordingController());
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.NSwhite,
        body: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndictor,
              children: [
                Onbordingpage(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  image: 'assets/images/Onboarding_images/chessnews.png',
                  title: TOnbordtext.bordtitle,
                  subtitle: TOnbordtext.bordSubtitle,
                ),
                Onbordingpage(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  image: 'assets/images/Login/Login.jpg',
                  title: TOnbordtext.bordtitle2,
                  subtitle: TOnbordtext.bordSubtitle2,
                ),
                Onbordingpage(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  image: 'assets/images/Onboarding_images/chessplan.jpeg',
                  title: TOnbordtext.bordtitle3,
                  subtitle: TOnbordtext.bordSubtitle3,
                ),
              ],
            ),
            skiponbording(),
            onbordingdots(),
            onbordelevate()
          ],
        ),
      ),
    );
  }
}

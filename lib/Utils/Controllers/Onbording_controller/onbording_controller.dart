import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Navigation/bottomnav.dart';

class OnBordingController extends GetxController {
  static OnBordingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIfOnboardingIsShown();
  }

  void updatePageIndictor(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage() async {
    if (currentPageIndex.value == 2) {
      await _setOnboardingShown();
      Get.off(() => MainScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() async {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
    await _setOnboardingShown();
    Get.off(() => MainScreen());
  }

  Future<void> _setOnboardingShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardingShown', true);
  }

  Future<void> _checkIfOnboardingIsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboardingShown = prefs.getBool('onboardingShown');
    if (onboardingShown == true) {
      Get.off(() => MainScreen());
    }
  }
}

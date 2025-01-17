
import 'dart:convert';

import 'package:chess_application_1/backendOperations/likedCount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../modelClass/newsModel.dart';


import 'package:get/get.dart';

class NewsController extends GetxController {
  var newsFeed = <Article>[].obs;
  var bookmarkStatus = <int, bool>{}.obs;
  var currentIndex = 0.obs;
  var startTime = DateTime.now().obs;

  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    loadNews();

  }

  Future<void> loadNews() async {
    try {
      final response = await rootBundle.loadString("assets/chessData.json");
      var jsonData = await json.decode(response);
      var value = NewsData.fromJson(jsonData);
      newsFeed.value = value.articles.sublist(0, 11);
    } catch (e) {
      print("Error loading news: $e");
    }
  }

  void updateCurrentPage(int index) {
    int durationInSeconds = DateTime.now().difference(startTime.value).inSeconds;
    print('Time spent on page $currentIndex: $durationInSeconds seconds');


    Likes.timeSpent(index: index, durationInSeconds: durationInSeconds);

    currentIndex.value = index;
    startTime.value = DateTime.now();// Reset the start time for the new page
  }
  void toggleBookmark(int index) {
    bookmarkStatus[index] = !(bookmarkStatus[index] ?? false);
  }
}

import 'dart:convert';
import 'package:chess_application_1/modelClass/newsSet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  // Use Rx types for reactive state management
  RxList<Item> newsItems = <Item>[].obs;
  List<int> likedAndDisLikedCount = [0, 0];
  RxList<String> likedPeople = <String>[].obs;
  RxList<String> dislikedPeople = <String>[].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Method to fetch liked and disliked counts
  Future<void> getLikedAndDisLikedCount({required int index}) async {

    print("Liked and Disliked function gets called..........");
    var snapshot = await firestore.collection("NEWSFEED").doc("$index").get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>; // Explicitly cast to a Map
      likedPeople.value = List<String>.from(data["likes"] ?? []);
      dislikedPeople.value = List<String>.from(data["dislikes"] ?? []);
      print("Liked People: $likedPeople");
    } else {
      print("Document does not exist.");
      likedPeople.value = [];
      dislikedPeople.value = [];
    }

    likedAndDisLikedCount[0] = likedPeople.value.length;
    likedAndDisLikedCount[1] = dislikedPeople.value.length;
    print(likedAndDisLikedCount.toString());
    update();
  }

  // Method to fetch news data from the API
  Future<void> fetchNewsData() async {
    final response = await http.get(
      Uri.parse('https://rss.app/feeds/v1.1/t8KM2nAljlnxP5hn.json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      NewsSet news = NewsSet.fromJson(data);

      newsItems.value = news.items;
      print(newsItems);

      for (int i = 0; i < newsItems.length; i++) {
        await FirebaseFirestore.instance.collection("NEWSFEED").doc("$i").update({
          "title": newsItems[i].title ?? '',
          "description": newsItems[i].contentText ?? '',
          "imageUrl": newsItems[i].image ?? '',
        });
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchNewsData();
    getLikedAndDisLikedCount(index: 0);
  }
}

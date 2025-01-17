import 'package:chess_application_1/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // Import GetX

import '../Utils/Constants/colors.dart';

// Controller class for managing the state
class SavedPageController extends GetxController {
  var savedDatas = <List<String>>[].obs; // Observable list

  @override
  void onInit() {
    super.onInit();
    fetchDatas();
  }

  Future<void> fetchDatas() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    savedDatas.clear();
    var counter = await preferences.getInt('counter') ?? 0;

    for (int i = 0; i < counter; i++) {
      var values = await preferences.getStringList(i.toString()) ?? [];
      savedDatas.add(values);
      refresh();
    }


  }
}

class Savedpage extends StatefulWidget {
  const Savedpage({super.key});

  @override
  State<Savedpage> createState() => _SavedpageState();
}

class _SavedpageState extends State<Savedpage> {


  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SavedPageController());

    return Scaffold(
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        title: Text(
          'Saved',
          style: GoogleFonts.aBeeZee(fontSize: 18),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchDatas(); // Call fetchDatas from the controller
        },
        child: Obx(() { // Use GetX to reactively update the UI
          if (controller.savedDatas.isEmpty) {
            return Center(child: Text("No saved data", style: GoogleFonts.aBeeZee()));
          } else {
            return ListView.builder(
              itemCount: controller.savedDatas.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Image.network(controller.savedDatas[index][2], width: 100, height: 100),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        controller.savedDatas[index][0],
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        }),
      ),
    );
  }
}

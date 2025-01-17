import 'dart:io';

import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/screens/Edit_profile/edit_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  String userName = "Fetching Name...";
  String userEmail = "Fetching Email...";
  String userAddress = "Fetching Address...";
  String profileImagePath = ""; // Path for the profile image if stored locally


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  Future<void> getData() async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    userName=await preferences.getString('name')??" ";
    userEmail=await preferences.getString('email')??" ";
    profileImagePath=await preferences.getString("selectedAvatar")??"";
    print("user $userEmail");
    setState(() {
      userName;
      userEmail;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImagePath.isNotEmpty
                            ? AssetImage(profileImagePath)
                            : AssetImage(
                                    'assets/images/lunchericon/chessnact.png')
                                as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => EditProfilePage());
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: TColors.primary,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Name
                  Text(
                    userName,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Email
                  Text(
                    userEmail,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  // Address
                  Text(
                    userAddress,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Options Section
            _buildOption('Manage Bookmark', Icons.bookmark),
            _buildOption('Help', Icons.help),
            _buildOption('Logout', Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          // Handle navigation or action
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: TColors.NSlightgray,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: TColors.iconlink),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: TColors.iconhint),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:chess_application_1/screens/Aboutus/aboutus.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:chess_application_1/screens/profilePage.dart';
import 'package:chess_application_1/screens/savedPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/colors.dart';

class DrawerNav extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userAvatarUrl;

  const DrawerNav({Key? key, this.userName, this.userEmail, this.userAvatarUrl})
      : super(key: key);

  @override
  State<DrawerNav> createState() => _DrawerNavState();
}

class _DrawerNavState extends State<DrawerNav> {

  String username="";
  String emailId="";
  String profileImage="";

 Future<void>  getDatas() async
  {
   SharedPreferences preferences=await SharedPreferences.getInstance();

   username=await preferences.getString('name')??"";
   emailId=await preferences.getString("email")??"";
   profileImage=await preferences.getString("selectedAvatar")??"";
   setState(() {
     username;
     emailId;
     profileImage;
   });
   print(username);
   print(emailId);

   print(profileImage);

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatas();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: TColors.NSwhite,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            InkWell(
              onTap: () {
                if(FirebaseAuth.instance.currentUser==null)
                  {
                    Get.to(() => LoginPage());
                  }
                else
                  {
                    Get.to(()=>Profilepage());
                  }
              },
              child: (FirebaseAuth.instance.currentUser!=null)
                  ? UserAccountsDrawerHeader(
                      accountName: Text(
                        '${username ?? 'Hi!'}',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      accountEmail: Text(
                        emailId ?? 'Traveller',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:(profileImage.isNotEmpty)
                            ? AssetImage(profileImage)
                            : AssetImage('asset/images/user/person.png')
                                as ImageProvider,
                      ),
                      decoration: BoxDecoration(
                        color: TColors.primary,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(16),
                      color: TColors.primary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('asset/images/user/person.png')
                                        as ImageProvider,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login/Signup now',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 16,
                                      color: TColors.textsecondary,
                                    ),
                                  ),
                                  Text(
                                    'and Grab Exclusive deals',
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      color: TColors.textsecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/Drawer_icons/bookmark.png',
                height: 25,
                width: 25,
              ),
              title: Text(
                'Saved',
                style: GoogleFonts.aBeeZee(fontSize: 14),
              ),
              onTap: () async {
                Get.to(() => Savedpage());
              },
            ),
            // ListTile(
            //   leading: Image.asset(
            //     'assets/images/Drawer_icons/videos.png',
            //     height: 25,
            //     width: 25,
            //   ),
            //   title: Text(
            //     'Videos',
            //     style: GoogleFonts.aBeeZee(fontSize: 14),
            //   ),
            //   onTap: () async {},
            // ),
            // ListTile(
            //   leading: Image.asset(
            //     'assets/images/Drawer_icons/news.png',
            //     height: 25,
            //     width: 25,
            //   ),
            //   title: Text(
            //     'News',
            //     style: GoogleFonts.aBeeZee(fontSize: 14),
            //   ),
            //   onTap: () async {},
            // ),
            ListTile(
              leading: Image.asset(
                'assets/images/Drawer_icons/aboutus.png',
                height: 25,
                width: 25,
              ),
              title: Text(
                'About Us',
                style: GoogleFonts.aBeeZee(fontSize: 14),
              ),
              onTap: () async {
                Get.to(() => Aboutus());
              },
            ),
            if (widget.userEmail != null && widget.userEmail!.isNotEmpty) ...[
              ListTile(
                leading: Icon(
                  Icons.logout,
                ),
                title: Text(
                  'Sign Out',
                  style: GoogleFonts.aBeeZee(fontSize: 14),
                ),
                onTap: () async {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

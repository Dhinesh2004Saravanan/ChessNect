import 'dart:io';

import 'package:chess_application_1/screens/Aboutus/aboutus.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:chess_application_1/screens/savedPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
                Get.to(() => LoginPage());
              },
              child: widget.userEmail != null && widget.userEmail!.isNotEmpty
                  ? UserAccountsDrawerHeader(
                      accountName: Text(
                        '${widget.userName ?? 'Hi!'}',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      accountEmail: Text(
                        widget.userEmail ?? 'Traveller',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: widget.userAvatarUrl != null &&
                                widget.userAvatarUrl!
                                    .startsWith('/data/user/0/')
                            ? FileImage(File(widget.userAvatarUrl!))
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

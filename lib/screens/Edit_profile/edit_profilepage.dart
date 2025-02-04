import 'dart:io';

import 'package:chess_application_1/Navigation/bottomnav.dart';
import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/ServerAuthenticationUser.dart';
import 'package:chess_application_1/controllers/LocationController.dart';
import 'package:chess_application_1/screens/Edit_profile/Confirmlocation/confirm_location.dart';
import 'package:chess_application_1/screens/homePage.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final PageController _pageController = PageController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  int selectedAvatarIndex = -1;
  String? selectedAvatar;
  File? uploadedImage;
  bool value=false;

  @override
  void initState() {
    super.initState();
   // _loadStoredData();

  }

  // Load saved data from shared preferences
  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar');
      nameController.text = prefs.getString('name') ?? '';
      phoneController.text = prefs.getString('email') ?? '';

    });
  }

  // Show image picker for uploading a custom avatar
  Future<void> _showImagePicker(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        uploadedImage = File(image.path);
        selectedAvatar = image.path;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedAvatar', image.path);
      await prefs.setBool('isUploadedImage', true);
    }
  }

  void _navigateToProfilePage() {
    // Get.offAll(() => NewsPage());
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _saveToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('phone', phoneController.text);

    var name=await prefs.getString('name');
    print("NAME IS $name");

  }

  // Avatar selection logic
  Widget buildStep1(BuildContext context) {
    final List<String> avatars = [
     'assets/images/persons/Mikhail.jpg',
      'assets/images/persons/bobby.webp',
      'assets/images/persons/Gukesh.webp',
      'assets/images/persons/magnus.png',
      'assets/images/persons/Vishy.webp',
      'assets/images/persons/pragg.webp',
    ];

    final List<String> namesOfAvatar=[
      'Mikhail Tal',
      'Bobby Fischer',
      'D. Gukesh',
      'Magnus Carlsen',
      'Viswanathan Anand',
      'Pragganandha'
    ];
    final List<String> captions=[

      "Master of attacks",
      "Chess genius",
      "Rising Indian star",
      "World champion",
      "India's chess legend",
      "Wizard Of Chess"
    ];

    return FutureBuilder<bool>(future: ServerAuthentication.isUserRegistered(), builder: (context,snapshot){

      if(snapshot.connectionState==ConnectionState.waiting)
        {
          return CircularProgressIndicator();

        }
      else
        {
          bool isRegistered=snapshot.data??false;
          return (isRegistered)?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Step 1/2',
                style: GoogleFonts.aBeeZee(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                'Choose your avatar',
                style: GoogleFonts.aBeeZee(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(avatars.length, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedAvatarIndex = index;
                            selectedAvatar = avatars[index];
                            uploadedImage = null;
                          });

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('selectedAvatar', avatars[index]);
                          await prefs.setString('characterName', namesOfAvatar[index]);
                          await prefs.setBool('isUploadedImage', true);
                        },
                        child: CircleAvatar(
                          radius: 53,
                          backgroundColor: selectedAvatarIndex == index
                              ? Colors.blue
                              : Colors.grey[300],
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(avatars[index]),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(captions[index],style: GoogleFonts.aBeeZee(),)


                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),
              Text(
                'Or add your own photo',
                style: GoogleFonts.aBeeZee(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showImagePicker(context);
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.add, size: 28, color: Colors.black),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: selectedAvatarIndex == -1 && uploadedImage == null
                    ? null
                    : () {
                  //  print(selectedAvatar);
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                  Get.put(LocationController()).getCurrentLocation();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.aBeeZee(
                      fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ):LoginPage();
        }

    });
  }

  // Step 2: Add profile details form
  Widget buildStep2(BuildContext context) {


    return SingleChildScrollView(

      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        // key: formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Step 2/2',
              style: GoogleFonts.aBeeZee(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              'Add your details',
              style:
                  GoogleFonts.aBeeZee(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (selectedAvatar != null)
              CircleAvatar(
                  radius: 50, backgroundImage: AssetImage(selectedAvatar!)),
            const SizedBox(height: 20),
            TextFormField(
              validator: (val){
                if(val==null || val.isEmpty)
                {
                  return "PLEASE FILL THIS FIELD";
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val){
                if(val==null || val.isEmpty)
                {
                  return "PLEASE FILL THIS FIELD";
                }
              },
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: InputDecoration(

                labelText: 'Phone Number',

                labelStyle: const TextStyle(color: Colors.blue),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: ()async{
                _saveToSharedPreferences();
                _navigateToProfilePage();

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Finish',
                style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    color: TColors.textsecondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // Widget _buildOption(String title, IconData icon) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: InkWell(
  //       onTap: () {
  //         if (title == 'Use current location') {
  //           // Navigate to the ConfirmLocation page
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => ConfirmLocation()),
  //           );
  //         }
  //       },
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
  //         decoration: BoxDecoration(
  //           color: TColors.NSlightgray,
  //           borderRadius: BorderRadius.circular(10),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.3),
  //               spreadRadius: 1,
  //               blurRadius: 5,
  //               offset: const Offset(0, 3),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Icon(icon, size: 24, color: TColors.iconlink),
  //             const SizedBox(width: 20),
  //             Expanded(
  //               child: Text(
  //                 title,
  //                 style: GoogleFonts.aBeeZee(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             const Icon(Icons.arrow_forward_ios,
  //                 size: 16, color: TColors.iconhint),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.NSwhite,
      appBar: AppBar(
        backgroundColor: TColors.NSwhite,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.aBeeZee(fontSize: 18.5),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: TColors.iconlink,
            size: 21,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [buildStep1(context), buildStep2(context)],
      ),
    );
  }


}

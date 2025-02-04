import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/Constants/colors.dart';

class Aboutus extends StatefulWidget {
  const Aboutus({super.key});

  @override
  State<Aboutus> createState() => _AboutusState();
}

class _AboutusState extends State<Aboutus> {
  final TextEditingController _numberCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _numberCtrl.text = "9403891882";
  }

  // Open Email Client
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'chessensei.com',
      queryParameters: {'subject': 'Support Request'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Could not launch $emailLaunchUri');
    }
  }

  // Open Dialer
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      print('Could not launch dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'About us',
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            color: Colors.black,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(color: TColors.NSwhite),
                child: Column(
                  children: [
                    Text(
                      'Something not right? Please call us or mail following list.',
                      style: GoogleFonts.aBeeZee(),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      onTap: () {
                        _launchPhone("+919403891882"); // Open dialer
                      },
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/aboutus/telephone.png',
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _launchPhone(_numberCtrl.text); // Open dialer
                            },
                            child: Text('+91 9403891882',
                                style: GoogleFonts.aBeeZee()),
                          )
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/aboutus/email.png',
                            height: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: _launchEmail,
                            child: Text(
                              'info@chessensei.com',
                              style: GoogleFonts.aBeeZee(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(color: TColors.NSwhite),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address',
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/aboutus/map-pin.png',
                            height: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "4th Floor, Whitefield Main Rd, \n"
                            "near Balaraj's Arcade, \n"
                            "opposite to BRIGADE COSMOPOLIS,\n"
                            "Brooke Bond First Cross,Whitefield,\n"
                            "Bengaluru,Karnataka 560066",
                            style: GoogleFonts.aBeeZee(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

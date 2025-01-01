

import 'dart:async';

import 'package:chess_application_1/firebase_options.dart';
import 'package:chess_application_1/screens/homePage.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async
{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(FrontPage());
}


class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4),(){

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>


      (FirebaseAuth.instance.currentUser==null)
          ?LoginPage():NewsPage())



      );


    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(


      resizeToAvoidBottomInset: false,


      body: Center(
        child:Image.asset("assets/chessIcon.gif") ,
      ),
    );
  }
}


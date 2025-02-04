import 'dart:convert';

import 'package:chess_application_1/Navigation/bottomnav.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constants/api-credentials.dart';

class ServerAuthentication {
  static String baseUrl = "http://staging.bdsd.technology/tts-app/api";
  static late SharedPreferences preferences;
  static late ProgressDialog progressDialog;

  static Future<void> register({
    required String emailId,
    required String password,
    required BuildContext context,
  }) async {
    try {
      print("$baseUrl/register");
      progressDialog = ProgressDialog(context, type: ProgressDialogType.normal);
      progressDialog.style(
        message: 'Registering...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      );
      await progressDialog.show();

      final Uri apiUrl = Uri.parse('$baseUrl/register');
      final Map<String, dynamic> postData = {
        "email_id": emailId.trim(),
        "password": password.trim(),
      };

      final http.Response response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Username': TApicredentials.Username,
          'Password': TApicredentials.Password,
        },
        body: jsonEncode(postData),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);
      final int statusCode = resData["StatusCode"] ?? -1;

      await progressDialog.hide();

      if (statusCode == 0) {
        String successMessage =
            resData["Message"] ?? "Registration successful!";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print("Full API Response: $resData"); // Debugging

        // Extract error message
        String errorMessage = "Unknown error";
        if (resData["ErrorMessage"] is String) {
          errorMessage = resData["ErrorMessage"];
        } else if (resData["ErrorMessage"] is Map &&
            resData["ErrorMessage"].isNotEmpty) {
          errorMessage = resData["ErrorMessage"].values.first ??
              "An error occurred. Please try again.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      await progressDialog.hide();
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

//-------- Login api call --------

  static Future<void> login({
    required String emailId,
    required String password,
    required BuildContext context,
  }) async {
    try {
      print("$baseUrl/login");

      ProgressDialog progressDialog =
      ProgressDialog(context, type: ProgressDialogType.normal);
      progressDialog.style(
        message: 'Logging in...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      );
      await progressDialog.show();

      final Uri apiUrl = Uri.parse("$baseUrl/login");
      final Map<String, dynamic> postData = {
        "email_id": emailId.trim(),
        "password": password.trim(),
      };

      final http.Response response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Username': TApicredentials.Username,
          'Password': TApicredentials.Password,
        },
        body: jsonEncode(postData),
      );

      final Map<String, dynamic> resData = jsonDecode(response.body);
      final int statusCode = resData["statusCode"] ?? -1;
      final String message = resData["Message"] ?? "Unknown error";
      final String customer_id=resData["Result"]["customer_id"];

      await progressDialog.hide();

      if (statusCode == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        preferences = await SharedPreferences.getInstance();
        print("CUSTOMER ID IS ${customer_id}");
        await preferences.setBool("isRegistered", true);

        await preferences.setString("cid",customer_id);
        await preferences.setString("email", emailId);



        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login successful!"),
            backgroundColor: Colors.green,
          ),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        });
      }
    } catch (e) {
      await progressDialog.hide();
      print("Error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


   static Future<bool> isUserRegistered() async
   {
     preferences=await SharedPreferences.getInstance();

     bool isRegistered=await preferences.getBool("isRegistered")??false;
     print("IS USER REGISTERED $isRegistered");
     return isRegistered;

   }
}


// import 'dart:convert';
// import 'package:chess_application_1/screens/loginPage.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../screens/Edit_profile/edit_profilepage.dart';
// import 'package:http/http.dart' as http;
//
// class ServerAuthentication
// {
//
//   static String baseUrl="https://staging.bdsd.technology/tts-app/api";
//   static late SharedPreferences preferences;
//  static late ProgressDialog progressDialog;
//   static Future<void> register({required String emailId,required String password,required BuildContext context}) async
//    {
//     try
//         {
//           print("$baseUrl/register");
//          progressDialog= ProgressDialog(context, type: ProgressDialogType.normal);
//           progressDialog.style(
//             message: 'Logging in...',
//             borderRadius: 10.0,
//             backgroundColor: Colors.white,
//             progressWidget: CircularProgressIndicator(),
//             elevation: 10.0,
//             insetAnimCurve: Curves.easeInOut,
//             messageTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 18.0,
//               fontWeight: FontWeight.w600,
//             ),
//           );
//           progressDialog.show();
//
//           var response=await Dio(
//               BaseOptions(
//                   headers: {
//                     'Content-Type':'application/json'
//                   }
//               )
//           ).post(baseUrl+"/register",data: {
//
//             "email_id":emailId,
//             "password":password
//           });
//
//           var res=response.data;
//
//
//           print("Response is $res");
//           await progressDialog.hide();
//
//           var statusCode=res["StatusCode"];
//           var message=res["ErrorMessage"];
//
//           if(statusCode==1)
//             {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email ID already exists!! Enter a new Email ID")));
//             }
//           else
//             {
//
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//
//
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => LoginPage()));
//
//               });
//
//             }
//         }
//         catch(e)
//      {
//        progressDialog.hide();
//        print("Error occured $e");
//      }
//
//
//    }
//
//
//    static Future<void> login({required String emailId,required String password,required BuildContext context}) async
//    {
//      try
//          {
//
//          ProgressDialog progressDialog= ProgressDialog(context, type: ProgressDialogType.normal);
//            progressDialog.style(
//              message: 'Logging in...',
//              borderRadius: 10.0,
//              backgroundColor: Colors.white,
//              progressWidget: CircularProgressIndicator(),
//              elevation: 10.0,
//              insetAnimCurve: Curves.easeInOut,
//              messageTextStyle: TextStyle(
//                color: Colors.black,
//                fontSize: 18.0,
//                fontWeight: FontWeight.w600,
//              ),
//            );
//            progressDialog.show();
//            var response=await http.post(Uri.parse("$baseUrl/login"),headers: {
//              'Content-Type':'application/json'
//            },body: jsonEncode({
//
//              "email_id":emailId,
//              "password":password
//
//            }));
//
//
//            var res=jsonDecode(response.body);
//
//            print("Response is $res");
//
//
//            var statusCode=res["statusCode"];
//            var message=res["Message"];
//
//           progressDialog.hide();
//            if(statusCode==2)
//              {
//                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("message")));
//
//              }
//            else
//              {
//
//                preferences=await SharedPreferences.getInstance();
//                await preferences.setBool("isRegistered", true);
//
//                WidgetsBinding.instance.addPostFrameCallback((_) {
//
//
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context) => EditProfilePage()));
//
//                });
//              }
//
//          }
//          catch(e)
//      {
//
//      }
//    }
//
//    static Future<bool> isUserRegistered() async
//    {
//      preferences=await SharedPreferences.getInstance();
//
//      bool isRegistered=await preferences.getBool("isRegistered")??false;
//      print("IS USER REGISTERED $isRegistered");
//      return isRegistered;
//
//    }
//
// }
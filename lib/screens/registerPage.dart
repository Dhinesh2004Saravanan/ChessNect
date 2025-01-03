import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/authenticationFirebase.dart';
import 'package:chess_application_1/screens/loginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../usableWidgets/inputField.dart';
import '../usableWidgets/inputFieldForPassword.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailId = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: TColors.NSwhite,
      resizeToAvoidBottomInset: false,
      body: Form(
          key: _formkey,
          child: Container(
            height: _height,
            width: _width,
            margin: EdgeInsets.fromLTRB(30, _height / 12, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/Login/Login.jpg',
                    height: _height / 4),
                SizedBox(height: 10),
                Text(
                  "Create An account",
                  style: GoogleFonts.aBeeZee(fontSize: 20),
                ),
                SizedBox(
                  height: _height / 32,
                ),
                Container(
                  height: 50,
                  child: InputText(
                    first: Icon(
                      FontAwesomeIcons.user,
                      size: 18,
                    ),
                    textController: username,
                    hint: "Username",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: InputText(
                    first: Icon(
                      Icons.email,
                      size: 18,
                    ),
                    textController: emailId,
                    hint: "Email Id",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Inputfieldforpassword(
                      first: Icon(
                        Icons.lock,
                        size: 18,
                      ),
                      textController: password,
                      hint: "Password"),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: Inputfieldforpassword(
                      first: Icon(
                        Icons.lock,
                        size: 18,
                      ),
                      textController: confirmPassword,
                      hint: "Confirm Password"),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: 50,
                    width: _width,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(TColors.primary)),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            print(username.text);
                            print(confirmPassword.text);
                            print(emailId.text);
                            print(password.text);
                            String p = password.text.trim();
                            String cp = confirmPassword.text.trim();
                            if (p == cp) {
                              FirebaseAuthentication.register(
                                  context: context,
                                  emailId: emailId.text,
                                  password: password.text,
                                  username: username.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("PASSWORDS NOT EQUAL")));
                            }
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 20, color: Colors.white),
                            )))),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: Center(
                    child: Text(
                      "---------- Or Sign In with ----------",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/Login/google.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/Login/microsoft.png',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    // Other social media sign-in buttons
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(
                        text: "Already Have an Account ? ",
                        style: GoogleFonts.aBeeZee(color: Colors.black),
                        children: [
                      TextSpan(
                          text: "Login",
                          style: GoogleFonts.aBeeZee(color: TColors.textlinks),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Login page navigated Function Called");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            })
                    ]))
              ],
            ),
          )),
    );
  }
}

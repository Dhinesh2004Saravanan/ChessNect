import 'package:chess_application_1/Utils/Constants/colors.dart';
import 'package:chess_application_1/backendOperations/authenticationFirebase.dart';
import 'package:chess_application_1/screens/registerPage.dart';
import 'package:chess_application_1/usableWidgets/inputField.dart';
import 'package:chess_application_1/usableWidgets/inputFieldForPassword.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();

  final TextEditingController emailId = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: TColors.NSwhite,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formkey,
        child: Container(
          height: _height,
          width: _width,
          padding: EdgeInsets.fromLTRB(30, _height / 12, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/Login/Login.jpg', height: _height / 4),
              SizedBox(height: 10),

              // Welcome text
              Text(
                "Welcome Back",
                style: GoogleFonts.aBeeZee(
                    fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "Enter your credentials to Login",
                style: GoogleFonts.aBeeZee(fontSize: 11),
              ),
              SizedBox(height: _height / 25),

              // Email input field
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
              SizedBox(height: 10),

              // Password input field
              Container(
                height: 50,
                child: Inputfieldforpassword(
                  first: Icon(
                    Icons.lock,
                    size: 18,
                  ),
                  textController: password,
                  hint: "Password",
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot Password",
                      style: GoogleFonts.aBeeZee(
                          color: TColors.textlinks, fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Login button
              Container(
                width: _width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(TColors.primary),
                  ),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      print(emailId.text);
                      print(password.text);
                      FirebaseAuthentication.login(
                          context: context,
                          emailId: emailId.text,
                          password: password.text);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text(
                      "Login",
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Sign Up text link
              RichText(
                text: TextSpan(
                  text: "Don't Have an account ? ",
                  style: GoogleFonts.aBeeZee(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Sign Up ",
                      style: GoogleFonts.aBeeZee(color: TColors.textlinks),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("Sign Up Function Called");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

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



  final _formkey=GlobalKey<FormState>();

  final TextEditingController emailId=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController username=TextEditingController();
  final TextEditingController confirmPassword=TextEditingController();


  @override
  Widget build(BuildContext context) {

    double _width=MediaQuery.of(context).size.width;
    double _height=MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Form(

          key: _formkey,
          child: Container(
            height: _height,
            width: _width,
            margin: EdgeInsets.fromLTRB(30, _height/8, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text("Sign Up",style:GoogleFonts.aBeeZee(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                ),),


                SizedBox(height: 10,),
                Text("Create An account",style: GoogleFonts.aBeeZee(
                ),),


                SizedBox(height: _height/12,),


                InputText(first: Icon(FontAwesomeIcons.user), textController: username,hint: "Username",),
                SizedBox(height: 10,),

                InputText(first: Icon(Icons.email), textController: emailId,hint: "Email Id",),
                SizedBox(height: 10,),
                Inputfieldforpassword(first: Icon(Icons.password), textController: password, hint: "Password"),
                SizedBox(height: 20,),

                Inputfieldforpassword(first: Icon(Icons.password), textController: confirmPassword, hint: "Confirm Password"),
                SizedBox(height: 20,),


                Container(
                    width: _width,

                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.purple
                            )
                        ),
                        onPressed: (){

                          if(_formkey.currentState!.validate())
                          {
                            print(username.text);
                            print(confirmPassword.text);
                            print(emailId.text);
                            print(password.text);
                            String p=password.text.trim();
                            String cp=confirmPassword.text.trim();
                            if(p==cp)
                              {
                                FirebaseAuthentication.register(context: context, emailId: emailId.text, password: password.text, username: username.text);

                              }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PASSWORDS NOT EQUAL")));
                              }
                          }
                        }, child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Text("Sign Up",style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            color: Colors.white

                        ),)))),
                
                
                
                SizedBox(height: 20,),
                Text("OR"),
                SizedBox(height: 20,),
                Container(
                    width: _width,

                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.purple
                            )
                        ),
                        onPressed: (){

                        }, child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Text("Sign Up With Google",style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            color: Colors.white

                        ),)))),



                SizedBox(height: 20,),
                RichText(text: TextSpan(
                    text: "Already Have an Account ? ",
                    style: GoogleFonts.aBeeZee(
                        color: Colors.black
                    ),
                    children: [
                      TextSpan(
                          text: "Login",
                          style: GoogleFonts.aBeeZee(
                              color: Colors.red
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap=(){

                              print("Login page navigated Function Called");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                            }
                      )
                    ]
                ))



              ],

            ),
          )),

    );
  }
}

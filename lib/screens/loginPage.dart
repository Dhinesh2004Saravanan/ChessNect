import 'package:chess_application_1/backendOperations/authenticationFirebase.dart';
import 'package:chess_application_1/screens/registerPage.dart';
import 'package:chess_application_1/usableWidgets/inputField.dart';
import 'package:chess_application_1/usableWidgets/inputFieldForPassword.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formkey=GlobalKey<FormState>();

 final TextEditingController emailId=TextEditingController();
 final TextEditingController password=TextEditingController();

  @override
  Widget build(BuildContext context) {

    double _width=MediaQuery.of(context).size.width;
    double _height=MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,


      body:
      Form(

          key: formkey,
          child: Container(
            height: _height,
            width: _width,
          margin: EdgeInsets.fromLTRB(30, _height/6, 30, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Text("Welcome Back",style:GoogleFonts.aBeeZee(
              fontSize: 40,
              fontWeight: FontWeight.bold
            ),),

            
            Text("Enter your credentials to Login",style: GoogleFonts.aBeeZee(
            ),),


            SizedBox(height: _height/10,),


            InputText(first: Icon(Icons.email), textController: emailId,hint: "Email Id",),
            SizedBox(height: 10,),
            Inputfieldforpassword(first: Icon(Icons.password), textController: password, hint: "Password"),
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

                    if(formkey.currentState!.validate())
                      {
                        print(emailId.text);
                        print(password.text);
                        FirebaseAuthentication.login(context: context, emailId: emailId.text, password: password.text);
                      }
                    }, child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text("Login",style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      color: Colors.white

                    ),)))),



            SizedBox(height: 25,),
            TextButton(onPressed: (){}, child: Text("Forgot Password",style: GoogleFonts.aBeeZee(

              color: Colors.purple,
              fontSize: 18
            ),)),


            SizedBox(height: 35,),

            RichText(text: TextSpan(
              text: "Don't Have an account ? ",
              style: GoogleFonts.aBeeZee(
                color: Colors.black
              ),
              children: [
                TextSpan(
                  text: "Sign Up ",
                  style: GoogleFonts.aBeeZee(
                      color: Colors.red
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap=(){

                      print("Sign Up Function Called");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
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

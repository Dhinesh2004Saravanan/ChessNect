

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputText extends StatelessWidget {

  final Icon first;
  final TextEditingController textController;

  final String hint;
   InputText({required this.first,required this.textController ,required this.hint,super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val){
        if(val!.isEmpty || val==null)
          {
            return "PLEASE FILL THIS FIELD";
          }
      },

      controller: textController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide.none

        ),
        prefixIcon: this.first,
        filled: true,
        hintText: hint,
        hintStyle: GoogleFonts.aBeeZee(),
        fillColor: Colors.purple.withOpacity(0.1)
      ),

    );
  }
}

import 'package:flutter/material.dart';

import '../Utils/Constants/colors.dart';

class Inputfieldforpassword extends StatefulWidget {
  final Icon first;
  final TextEditingController textController;
  final String hint;

  const Inputfieldforpassword(
      {required this.first,
      required this.textController,
      required this.hint,
      super.key});

  @override
  State<Inputfieldforpassword> createState() => _InputfieldforpasswordState();
}

class _InputfieldforpasswordState extends State<Inputfieldforpassword> {
  bool showStatus = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        if (val!.isEmpty || val == null) {
          return "PLEASE FILL THIS FIELD";
        }
      },
      obscureText: showStatus,
      controller: widget.textController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide.none),
          prefixIcon: this.widget.first,
          filled: true,
          hintText: widget.hint,
          fillColor: TColors.primary.withOpacity(0.1),
          suffixIcon: InkWell(
            onTap: () {
              setState(() {
                showStatus = !showStatus;
              });
              print("show is $showStatus");
            },
            child: (!showStatus)
                ? Icon(
                    Icons.visibility_sharp,
                    size: 18,
                  )
                : (Icon(
                    Icons.visibility_off,
                    size: 18,
                  )),
          )),
    );
  }
}

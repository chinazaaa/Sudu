import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final readOnly;
  final Function validator;
  final String hintText;
  final bool obscureText;
  final Function onTap;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final AutovalidateMode autovalidateMode;
  CustomTextField({
    Key key, this.validator, this.hintText, this.obscureText = false, this.onTap, this.controller, this.readOnly = false, this.textInputAction = TextInputAction.done, this.textInputType, this.autovalidateMode,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool hide;
  @override
  void initState() {
    super.initState();
    hide = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly,
      controller: widget.controller,
      onTap: widget.onTap,
      obscureText: hide,
      validator: widget.validator,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: widget.obscureText ? IconButton(
          onPressed: (){
            setState(() {
              hide = !hide;
            });
          },
          icon: !hide ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ) : null,
        filled: true,
        hintText: widget.hintText,
        fillColor: Color(0xffF5F5F5),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),

      ),
    );
  }
}

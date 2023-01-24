import 'package:flutter/material.dart';

AppBar myAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
}) =>
    AppBar(
      leading: leading,
      title: Text(title),
      centerTitle: true,
      actions: actions,
      elevation: 0,
    );

// snack bar
SnackBar mySnackBar(String text)
  => SnackBar(
    content: Row(
      children: <Widget>[
        const Icon(
          Icons.info, 
          color: Colors.white,
        ),
        const SizedBox(width:10),
        Text(text)
      ],
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
  );

  // input field 
 TextFormField myTextFormField({
  String? label,
  String? hintText,
  TextEditingController? controller,
  bool readOnly = false,
  Widget? suffix,
  bool isTextArea = false,
 }) =>
  TextFormField(
  textInputAction:TextInputAction.next,
  readOnly: readOnly,
  controller: controller,
  maxLines: isTextArea ? 5 : 1,
  decoration: InputDecoration(
    suffixIcon: suffix,
    labelText:label,                   
    hintText: hintText,
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 3
      )
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 3
      )
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 3
      )
    ),
    focusedErrorBorder:const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 3
      )
    ), 
  ),
  validator: (String? value) {
    if (value == null || value.isEmpty) {
      return 'This Field Is Required';
    }
    return null;
  },
);

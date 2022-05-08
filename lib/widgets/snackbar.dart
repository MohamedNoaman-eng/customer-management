
import 'package:flutter/material.dart';
import 'package:zain/localization/localization_constants.dart';

Widget BuildSnackBar({context,String title='snackbar',Color color=Colors.white}){
  final snackBar = SnackBar(
    backgroundColor: color,
    duration: Duration(milliseconds: 1500),
    content: Text(
      LocalizationConst.translate(context, title),
      style: TextStyle(
        color: Colors.black,
      
        fontSize: 17.0
      ),
    ),

  );
  ScaffoldMessenger.of(context)
      .showSnackBar(snackBar);
}
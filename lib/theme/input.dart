import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black54, width: 2.0),
    borderRadius: const BorderRadius.all(const Radius.circular(5.0),)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlue, width: 2.0),
    borderRadius: const BorderRadius.all(const Radius.circular(5.0),),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 12.0 , horizontal: 10.0),
  hintStyle: TextStyle(fontSize: 14.0,color: Color(0xffc3c4c3)),


);

var dropdownDecoration = BoxDecoration(
  border: Border.all(color: Colors.grey[300], width: 1),
  borderRadius: BorderRadius.circular(15),
);

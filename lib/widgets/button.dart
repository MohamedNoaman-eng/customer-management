import 'package:flutter/material.dart';
import 'package:zain/localization/localization_constants.dart';

class BuildButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  const BuildButton({this.title,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 35,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0)),
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            LocalizationConst.translate(context, title),
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

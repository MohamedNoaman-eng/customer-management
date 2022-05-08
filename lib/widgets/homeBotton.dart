import 'package:flutter/material.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/widgets/snackbar.dart';

Widget bottonInHome(
  BuildContext context, {
  IconData icon = Icons.ac_unit_sharp,
  String name,
  String pageName,
  width,
  height,
  Function onTap,
  bool selectable = false,
      bool isScure=true
}) {
  return Container(
    width: width,
    height: 90,
    child: RaisedButton(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Color.fromRGBO(255, 0, 0, 1),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  LocalizationConst.translate(context, name),
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
        onPressed: isScure?(){
          BuildSnackBar(
            color: Colors.amber,
            title: "Not supported for you!",
            context: context
          );
        }:(selectable
            ? onTap
            : () {
          Navigator.pushNamed(context, pageName);
        })
    ),
  );
}

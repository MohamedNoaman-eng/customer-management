import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SpinKitCircle(
          color: Color.fromRGBO(255, 0, 0, 1),
          size: 50.0,
        duration: Duration(milliseconds: 300),
      ),
    );
  }
}
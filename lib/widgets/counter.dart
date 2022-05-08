import 'package:flutter/material.dart';


class CounterWidget extends StatelessWidget {
  int count;
  final String sparepartId;

  CounterWidget({this.count, this.sparepartId});

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Container(
        decoration: BoxDecoration(
            border:
            Border.all(color: Color.fromRGBO(151, 151, 151, 1), width: 1.0),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                child: IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 13,
                    ),
                    onPressed: () {
                      if (count == 1) return;

                      count--;
                      (context as Element).markNeedsBuild();
                    }),
              ),
            ),
            Expanded(
              child: Container(
                // color: Colors.yellow,
                child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none),
                    )),
              ),
            ),
            Expanded(
              child: Container(
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 13,
                    ),
                    onPressed: () {

                      count++;
                      (context as Element).markNeedsBuild();
                    }),
              ),
            )

          ],
        ),
      ),
    );
  }
}
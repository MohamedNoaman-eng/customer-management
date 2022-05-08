import 'package:flutter/material.dart';

class BuildCheckBox extends StatelessWidget {
  final bool value;
  final Function onChanged;

  const BuildCheckBox({
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        contentPadding: EdgeInsets.all(0.0),
        value: value,
        title: Text("Discount sales"),
        onChanged:onChanged
        );
  }
}

import 'package:flutter/material.dart';

class BuildRadioListTile extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function onChanged;
  final Text title;
  final Text subTitle;

  const BuildRadioListTile({
    this.value,
    this.groupValue,
    this.onChanged,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      value: value,
      title: title,
      groupValue: groupValue,
      controlAffinity: ListTileControlAffinity.trailing,
      dense: true,
      subtitle: subTitle,
      onChanged: onChanged
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/theme/input.dart';


class BuildTextFormField extends StatelessWidget {
  final TextInputType type;
  final String hint;
  final String label;
  final String labelValidate;
  final Function onChanged;
  final Function validator;
  final bool isSecure;
  final bool readOnly;
  final bool isValidate;
  final TextEditingController controller;

  const BuildTextFormField({
    this.type=TextInputType.text,
    this.hint,
    this.labelValidate,
    this.isValidate=false,
    this.label,
    this.onChanged,
    this.validator,
    this.isSecure=false,
    this.controller,
    this.readOnly = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: LocalizationConst.getCurrentLang(context) == 1
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Text(
            LocalizationConst.translate(context, label),
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          onChanged: onChanged,
          controller: controller,
          readOnly: readOnly,
          keyboardType: type,
          style: TextStyle(color: Color(0xff16071E)),
          validator: !isValidate? (val) => val.isEmpty
              ? LocalizationConst.translate(
              context, labelValidate)
              : null:validator,
          decoration: textInputDecoration.copyWith(
            hintText: LocalizationConst.translate(
                context, hint),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zain/lang/language.dart';

class MyLanguage extends StatefulWidget {
  const MyLanguage({this.onValueChange, this.initialValue});

  final int initialValue;
  final void Function(BuildContext, int) onValueChange;

  @override
  State createState() => new MyLanguageState();
}

class MyLanguageState extends State<MyLanguage> {
  int selectedLanguage;
  List<Language> languages;

  @override
  void initState() {
    languages = Language.languageList();
    setState(() {
      selectedLanguage = widget.initialValue;
    });
    super.initState();
  }

  List<Widget> createRadioListLanguages() {
    List<Widget> widgets = [];
    for (Language language in languages) {
      widgets.add(
        RadioListTile(
          value: language.id,
          groupValue: selectedLanguage,
          title: Text(language.flag),
          subtitle: Text(language.name),
          activeColor: Colors.green,
          onChanged: (value) {
            print("Language $value");
            widget.onValueChange(context, value);
            setState(() {
              selectedLanguage = value;
            });
            Fluttertoast.showToast(
                msg: "${language.name}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pop();
          },
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: createRadioListLanguages());
  }
}
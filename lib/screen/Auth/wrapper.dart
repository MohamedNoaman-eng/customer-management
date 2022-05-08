import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/models/user.dart';

import '../home.dart';
import 'login.dart';



checkIfAuthenticated() async {
  await Future.delayed(Duration(
      seconds: 5),
  ); // could be a long running task, like a fetch from keychain
  return true;
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    /// this provider listen to which???
    final user = Provider.of<UserDetails>(context);

    saveUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", user.uid);
      userDetailId = user.uid;
    }

    //return either Home or Authenticate

    if (userDetailId != null) {
      saveUser();
    } else {
      return Login();
    }
  }
}

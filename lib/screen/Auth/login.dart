

import 'package:flutter/material.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/auth.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/screen/home.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar:AppBar(
              title: Text(LocalizationConst.translate(context, "Login")),
              leading: SizedBox(),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: Container(
              //constraints: BoxConstraints.expand(),

              child: ListView(children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 165.0,
                          child: Image(
                            image: AssetImage("images/logo.png"),
                            width: 100.0,
                          ),
                        ),
                        SizedBox(
                          height: 35.0,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Email',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Color(0xff8F5F43)),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter an valid email' : null,
                      
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Password',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Color(0xff8F5F43)),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          autofocus: false,
                          initialValue: password,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: textInputDecoration.copyWith(
                            hintText: 'Password',
                          ),
                          validator: (val) => val.length < 8
                              ? 'Enter password 8 or more characters'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(
                          height: 7.0,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Must be 8 or more characters',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Color(0xff8F5F43)),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        BuildButton(
                          title: "Login",
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'email or password wrong';
                                  loading = false;
                                });
                              } else {
                                if(email.endsWith("@admin.com")){
                                  whoIs = 1;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(whoIs: 1,)));

                                }else if(email.endsWith("@officer.com")){
                                  whoIs = 2;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(whoIs: 2,)));

                                }else if(email.endsWith("@driver.com")){
                                  whoIs = 3;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(whoIs: 3,)));

                                }else if(email.endsWith("@admina.com")){
                                  whoIs = 4;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(whoIs: 4,)));

                                }
                                else if(email.endsWith("@leader.com")){
                                  whoIs = 5;
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Home(whoIs: 5,)));

                                }else{
                                  setState(() {
                                    error = 'email or password wrong';
                                    loading = false;
                                  });

                                }

                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(
                              color: Color(0xFFDA2C2C), fontSize: 14.0),
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ),
              ]),
            ));
  }
}

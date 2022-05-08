import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/auth.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/lang/language.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/localization/mylanguage.dart';
import 'package:zain/provider/providerState.dart';
import 'package:zain/screen/Auth/login.dart';
import 'package:zain/widgets/snackbar.dart';
import '../screen/Products_Categpries/AllCategories.dart';
import '../screen/cars/AllDriversScreen.dart';
import '../screen/Sales_team/AllOfficerScreen.dart';
import '../screen/Products_Categpries/AllProducts.dart';
import '../screen/clients/allClientScreen.dart';
import '../screen/Sales_team/all_leader_screen.dart';

class SideBar extends StatefulWidget {
  int whoIs;

  SideBar({this.whoIs});

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  void changeLanguage(BuildContext context, int id) async {
    Language language =
        Language.languageList().firstWhere((element) => element.id == id);
    LocalizationConst.changeLanguage(context, language);
  }

  double profits=0;
  double arrears =0;
  bool isCalcProfit=true;
  void calcProfit(){
    setState(() {
      isCalcProfit = false;
    });
    OrderService().read().then((value){
      if(value!=null){
        value.forEach((element) {
          if(element.isPremium==true){
            if(element.status=="Approved"){
                arrears = arrears + (double.parse(element.totalPrice)-double.parse(element.paidPrice));
                profits = profits + double.parse(element.paidPrice);
            }
          }else{
            print("in else");
            if(element.status=="Approved"){
                profits = profits + double.parse(element.totalPrice);
            }
          }
        });
        setState(() {
          isCalcProfit = true;
        });
      }
    }).catchError((onError){
      print(onError);
    });
  }
  Widget _buildContactUs(BuildContext context) {
    return new AlertDialog(
      title: const Text('Contact us'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(LocalizationConst.translate(context, "Phone") +
              ": " +
              "01022947803"),
          SizedBox(
            height: 10,
          ),
          SelectableText(LocalizationConst.translate(context, "Email") +
              ": " +
              "mnoaman660@gmail.com")
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildSelectableDialog(
      {BuildContext context,
      String select1,
      String select2,
      screen1,
      screen2,
        String title,
      IconData iconData,
      IconData iconData2}) {
    return new AlertDialog(
      title: Text(
        LocalizationConst.translate(context, title),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14.0),
      ),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => screen1));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            LocalizationConst.translate(context, select1),
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black),
                          ),
                          Icon(
                            iconData,
                            size: 15.0,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(width: 5.0,),
              Expanded(
                child: Container(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => screen2));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            LocalizationConst.translate(context, select2),
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black,
                            ),
                          ),
                          Icon(
                            iconData2,
                            size: 15.0,
                            color: Color.fromRGBO(255, 0, 0, 1),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.black,
          child: Text(
            LocalizationConst.translate(context, 'Close'),
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 14.0,color: Colors.red),
          ),
        ),
      ],
    );
  }
  @override
  void initState() {
    calcProfit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
          child: Column(
      children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(40),
            color: Color.fromRGBO(255, 0, 0, 1),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      width: 75,
                      height: 75,
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logo.png"),
                          fit: BoxFit.fill,
                        ),
                      )),
                  Text(
                    LocalizationConst.translate(context, "welcome") +
                        " " +
                        "Zain",
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket_rounded,
                color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "My Orders"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==2||whoIs==4||whoIs==5
                ? () {
                    Navigator.pushNamed(context, '/showOrders');
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading: Icon(Icons.money,
                color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Profit&Arrears"),
              style:
              TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1
                ? () {
              showDialog(context: context, builder: (context)=>AlertDialog(
                title: Text( LocalizationConst.translate(context, "Profit&Arrears"),textAlign: TextAlign.center,),
                content: isCalcProfit?Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LocalizationConst.translate(context, "Profit"),style: TextStyle(color: Colors.black),),
                            Text("$profits",style: TextStyle(color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LocalizationConst.translate(context, "Arrears"),style: TextStyle(color: Colors.black),),
                            Text("$arrears",style: TextStyle(color: Colors.redAccent),),
                          ],)
                      ],
                    ),
                  ),
                ):SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  duration: Duration(milliseconds: 300),
                ),
              ));

            }
                : () {
            },
          ),
          ListTile(
            leading: Icon(Icons.group, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Clients"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==4
                ? () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ClientScreen()));
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading: Icon(Icons.group_work, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Sales team"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==4
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) => _buildSelectableDialog(
                            context: context,
                            select1: "Leaders",
                            select2: "Officers",
                            screen1: AllLeaderScreen(),
                            screen2: AllOfficerScreen(),
                            iconData: Icons.group_work,
                            title: "Which persons you need to see?",
                            iconData2: Icons.group));
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading:
                Icon(Icons.add_box_outlined, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Categories and Products"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==4
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) => _buildSelectableDialog(
                            context: context,
                            select1: "All Categories",
                            select2: "Products",
                            screen1: AllCategoriesScreen(),
                            screen2: AllProductsScreen(),
                            iconData: Icons.category,
                            title: "Choose product or category",
                            iconData2: Icons.shopping_cart_outlined));
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading:
                Icon(Icons.directions_car, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Drivers"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==4
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllDriversScreen()));
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Contactus"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: whoIs == 1||whoIs==4
                ? () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        // child: Text('Phone: 010'),
                        builder: (BuildContext context) =>
                            _buildContactUs(context));
                  }
                : () {
                    BuildSnackBar(
                        color: Colors.amber,
                        title: "Not supported for you!",
                        context: context);
                  },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Language"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => MyLanguage(
                    onValueChange: changeLanguage,
                    initialValue: LocalizationConst.getCurrentLang(context)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Color.fromRGBO(255, 0, 0, 1)),
            title: Text(
              LocalizationConst.translate(context, "Signout"),
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(50, 51, 53, 1)),
            ),
            onTap: () async {
              await AuthService().signOut().then((value) => {
                    if (value)
                      {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()))
                      }

                  });

            },

          ),
      ],
    ),
        ));
  }
}

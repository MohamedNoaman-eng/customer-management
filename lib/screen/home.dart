import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/lang/language.dart';
import 'package:zain/localization/localization.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/provider/providerState.dart';
import 'orders/add_order.dart';
import 'package:zain/screen/cars/add_driver.dart';
import 'package:zain/screen/cars/all_drivers.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/homeBotton.dart';
import 'package:zain/widgets/sideBar.dart';

class Home extends StatefulWidget {
  int whoIs;
  Home({this.whoIs});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userId;
  int languageValue;

  Localization _localization;

  List<Map<String,dynamic>> userInterestC=[];
  List<Map<String,dynamic>> userInterestF=[];
  Widget _buildSelectableDialog(BuildContext context) {
    return new AlertDialog(
      title: Text(LocalizationConst.translate(context, "Which person you need to add?"),textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0),),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: OutlinedButton(onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/addLeader");
                  }, child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocalizationConst.translate(context, "ADDLeader"),style: TextStyle(fontSize: 15.0,color: Colors.black),),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(Icons.perm_contact_cal_sharp,size: 10.0,color: Color.fromRGBO(255, 0, 0, 1),),
                      ],
                    ),
                  )),

                ),
              ),
              SizedBox(
               width: 5.0,
              ),
              Expanded(
                child: Container(

                  child: OutlinedButton(onPressed: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "/addOfficer");
                  }, child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocalizationConst.translate(context, "ADDOfficer"),style: TextStyle(fontSize: 15.0,color: Colors.black),),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(Icons.person_add_alt,size: 10.0,color: Color.fromRGBO(255, 0, 0, 1),),
                      ],
                    ),
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
          child: Text(LocalizationConst.translate(context, 'Close'),textAlign: TextAlign.start,),
        ),
      ],
    );
  }
  Widget _buildSelectable({BuildContext context,String select1,String select2,screen1,screen2}) {
    return new AlertDialog(
      title: Text(LocalizationConst.translate(context, "Which you need to do?"),textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15.0),),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>screen1));
                }, child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(LocalizationConst.translate(context, select1),style: TextStyle(fontSize: 13.0,color: Colors.black),),
                      Icon(Icons.perm_contact_cal_sharp,size: 13.0,color: Color.fromRGBO(255, 0, 0, 1),),
                    ],
                  ),
                )),
              ),
              SizedBox(
                width: 5.0,
              ),
              Container(
                child: OutlinedButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>screen2));
                }, child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(LocalizationConst.translate(context, select2),style: TextStyle(fontSize: 13.0,color: Colors.black),),
                      Icon(Icons.person_add_alt,size: 15.0,color: Color.fromRGBO(255, 0, 0, 1),),
                    ],
                  ),
                )),
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
          child: Text(LocalizationConst.translate(context, 'Close'),textAlign: TextAlign.start,
          style: TextStyle(fontSize: 15.0),),
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainBar("Home", context,isHome: true),
      drawer: SideBar(whoIs: widget.whoIs),
      body: Provider.of<AppProvider>(context).donLang?Center(
        child: Container(
          width: MediaQuery.of(context).size.width ,
          height:MediaQuery.of(context).size.height ,

          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(
              builder: (context,constrains)=>Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      bottonInHome(context,
                          icon: Icons.add_box_outlined,
                          name: 'Add Products',
                          width: constrains.maxWidth *0.4,
                          pageName: '/products',
                          isScure: widget.whoIs==2||widget.whoIs==3||widget.whoIs==5?true:false),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bottonInHome(context,
                          icon: Icons.person_add_alt,
                          name: 'Register client',
                          width: constrains.maxWidth *0.4,
                          pageName: '/register',
                          isScure: widget.whoIs==2||widget.whoIs==1||widget.whoIs==4||widget.whoIs==5?false:true),
                      bottonInHome(context,
                          icon: Icons.add_shopping_cart,
                          name: 'Orders',
                          width: constrains.maxWidth *0.4,
                          pageName: '/orderScreen',
                          isScure: widget.whoIs==2||widget.whoIs==1||widget.whoIs==4||widget.whoIs==5?false:true),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      bottonInHome(context,
                          icon: Icons.group_work,
                          name: 'Sales team',
                          width: constrains.maxWidth *0.4,
                          pageName: '/addOfficer',
                          isScure: widget.whoIs==2||widget.whoIs==3||widget.whoIs==5?true:false,
                      selectable: true,
                      onTap: (){
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            // child: Text('Phone: 010'),
                            builder: (BuildContext context) => _buildSelectableDialog(context));
                      }),

                      bottonInHome(
                        context,
                        icon: Icons.directions_car_sharp,
                        width: constrains.maxWidth *0.4,
                        name: 'Cars',
                        selectable: true,
                          isScure: widget.whoIs==2||widget.whoIs==3||widget.whoIs==5?true:false,
                        onTap: (){
                          showDialog(context: context, builder:(context)=>
                              _buildSelectable(
                                select1: "Add Drivers",
                                select2: "Add Orders",
                                context: context,
                                screen1: AddDriverScreen(),
                                screen2: AddOrderDriver(),
                              ));
                        }
                      ),


                    ],
                  ),
                  SizedBox(height: 15.0,),
                  bottonInHome(context,
                      icon: Icons.drive_eta_outlined,
                      name: 'Driver journey',
                      width: constrains.maxWidth *0.4,
                      pageName: '/driverJourney',
                      isScure: widget.whoIs==3||widget.whoIs==1||widget.whoIs==4?false:true),
                ],
              ),
            ),
          ),
        ),
      ):Loading(),

    );
  }
}




import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/driver.dart';
import 'package:zain/widgets/appBar.dart';

class AllDriversScreen extends StatefulWidget {
  @override
  _AllDriversScreenState createState() => _AllDriversScreenState();
}

class _AllDriversScreenState extends State<AllDriversScreen> {
  bool isGet = true;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<DriverModel> drivers = [];
  List<DriverModel> searchDrivers = [];
  List<String> driversIds = [];
  filterDrivers(String id, context) {
    if (id != "") {
      this.setState(() {
        searchDrivers =
            drivers.where((element) => element.driverId.contains(id)).toList();
      });
    } else {
      this.setState(() {
        searchDrivers =
            drivers;
      });
    }
  }
  void getAllDrivers(){
    setState(() {
      isGet = false;
    });
    DriverService().read().then((value){
      if(value==null) {
        drivers = [];
      }else {
        drivers = value;
        searchDrivers = value;
        drivers.forEach((element) {
          driversIds.add(element.driverId);
        });
      }
      setState(() {
        isGet = true;
      });
    }).catchError((onError){
      print("error on getting drivers $onError");
    });
  }
  @override
  void initState() {
    getAllDrivers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isGet? Scaffold(
      appBar: mainBar("All Drivers", context, disPose: () {}),
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: LayoutBuilder(
          builder:(context,constrains)=> Column(
            children: [
              Container(
                height: constrains.maxHeight *.1,
                child: SimpleAutoCompleteTextField(
                  key: key,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    hintText: LocalizationConst.translate(
                        context, "Search for driver"),
                    suffixIcon: new Icon(Icons.search),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  controller: TextEditingController(text: ""),
                  suggestions: driversIds,
                  textChanged: (text) {
                    filterDrivers(text,context);
                  },
                  clearOnSubmit: false,
                  onFocusChanged: (value) {
                    return null;
                  },
                  textSubmitted: (text) {
                    setState(() {
                      filterDrivers(text,context);
                    });
                  },
                ),
              ),
              Container(
                height: constrains.maxHeight *0.9,
                width: double.infinity,
                child: searchDrivers.length!=0?ListView.separated(
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                        ),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Align(
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                color:  Colors.white,
                                child: Card(
                                  elevation: 10.0,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(top: 35.0,start: 10.0,end: 10.0,bottom: 10.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Column(

                                          children: [
                                            Text("${searchDrivers[index].driverName}"),
                                            Text("${searchDrivers[index].driverPhone}"),
                                          ],
                                        ),
                                        Column(

                                          children: [
                                            Text("${searchDrivers[index].carConsumption}"),
                                            Text("${searchDrivers[index].carCounter}"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("${searchDrivers[index].carId}"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>null));
                                            }, child: Text(LocalizationConst.translate(context, "View Details"))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              alignment: Alignment.bottomCenter,
                            ),
                            CircleAvatar(
                              child: Text(searchDrivers[index].driverId),
                              backgroundColor: Colors.red,
                              radius: 25.0,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  itemCount: searchDrivers.length,
                  shrinkWrap: true,
                  separatorBuilder: (context,index)=>Container(
                    height: 10.0,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  physics: BouncingScrollPhysics(),
                ):Center(child: Text(LocalizationConst.translate(context, "There are no drivers"))),
              ),
            ],
          ),
        ),
      ),
    ):Loading();
  }
}

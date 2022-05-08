import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/driver.dart';
import 'package:zain/screen/cars/all_drivers_add_order.dart';
import 'package:zain/widgets/appBar.dart';

class AddOrderDriver extends StatefulWidget {
  @override
  _AddOrderDriverState createState() => _AddOrderDriverState();
}

class _AddOrderDriverState extends State<AddOrderDriver> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<DriverModel> drivers = [];
  List<String> driversIds =[];
  bool isGet = true;
  @override
  void initState() {
    getAllDrivers();
    super.initState();
  }
  void getAllDrivers(){
    setState(() {
      isGet = false;
    });
    DriverService().read().then((value) {
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
    }).catchError((error){
      print("error on getting drivers");
    });
  }
  List<DriverModel> searchDrivers = [];
  filterLeaders(String id, context) {
    if (id != "") {
      this.setState(() {
       searchDrivers =
            drivers.where((element) => element.driverId.contains(id)).toList();
      });
    } else {
      this.setState(() {
        searchDrivers = drivers;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return isGet?Scaffold(
      appBar: mainBar("All Drivers", context,disPose: (){}),
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
                    filterLeaders(text,context);
                  },
                  clearOnSubmit: false,
                  onFocusChanged: (value) {
                    return null;
                  },
                  textSubmitted: (text) {
                    setState(() {
                      filterLeaders(text,context);
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
                                            Text("${searchDrivers[index].carCounter}"),

                                          ],
                                        ),
                                        Column(

                                          children: [
                                            Text("${searchDrivers[index].carConsumption}"),
                                            Text("${searchDrivers[index].carId}"),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddOrderToDriver(driverModel: searchDrivers[index],)));
                                            }, child: Text(LocalizationConst.translate(context, "Add orders"))),
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

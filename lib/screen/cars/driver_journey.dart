import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/provider/driver_provider.dart';
import 'package:zain/screen/cars/client_location.dart';
import 'package:zain/screen/cars/maps.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/button.dart';

class DriverJourney extends StatefulWidget {
  @override
  _DriverJourneyState createState() => _DriverJourneyState();
}

class _DriverJourneyState extends State<DriverJourney> {
  Widget buildOrderItem({
    OrderModel orderModel,
    int orderNumber,
    String price = "0",
    index,
    BuildContext context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromRGBO(255, 0, 0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "#$index",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationConst.translate(
                            context, "Product Numbers"),
                        style: TextStyle(
                            fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        "$orderNumber",
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationConst.translate(context, "Status"),
                        style: TextStyle(
                            fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        "${orderModel.status}",
                        style:
                            TextStyle(fontSize: 13.0, color: Colors.orange),
                      ),
                      Text(
                          "${DateFormat.yMd('ar').format(orderModel.createdAt)}"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationConst.translate(context, "Total Price"),
                        style: TextStyle(
                            fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        "$price ${LocalizationConst.translate(context, "LE")}",
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ],
                  ),
                  Column(

                    children: [
                      TextButton(
                          onPressed: () {
                            print("${orderModel.orderClientId}");
                            ClientService()
                                .getById(orderModel.orderClientId)
                                .then((value) {
                              if (value != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ClientLocation(
                                              latitude: value.late,
                                              longitude: value.lang,
                                            )));
                              }
                            }).catchError((onError) {
                              print("error on getting lat $onError");
                            });
                          },
                          child: Icon(Icons.location_on)),
                    ],
                  ),
                ],
              ),
              Container(
                width: 300,
                child: BuildButton(
                  title: "Arrived",
                  onPressed: () {
                    Provider.of<DriverProvider>(context, listen: false)
                        .removedFromList(orderModel);
                    orderModel.status = 'Approved';
                    OrderService()
                        .updateOrder(orderModel, orderModel.id)
                        .then((value) {})
                        .catchError((onError) {
                      print(onError);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DriverProvider>(context, listen: false)
          .getDriver(userDetailId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<DriverProvider>(context, listen: false);
    var tProvider = Provider.of<DriverProvider>(context);
    return tProvider.isGet
        ? Scaffold(
            appBar: mainBar("Driver journey", context, disPose: () {}),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                child: Provider.of<DriverProvider>(context).driverOrders != null
                    ? ListView.builder(
                        itemBuilder: (context, index) => buildOrderItem(
                          context: context,
                          orderNumber:
                              tProvider.driverOrders[index].orderList.length,
                          index: index + 1,
                          price: tProvider.driverOrders[index].totalPrice,
                          orderModel: tProvider.driverOrders[index],
                        ),
                        itemCount: tProvider.driverOrders.length,
                      )
                    : Center(
                        child: Text(
                            LocalizationConst.translate(context, "No Orders")),
                      )),
          )
        : SpinKitCircle(
            color: Theme.of(context).primaryColor,
            duration: Duration(milliseconds: 300),
          );
  }
}

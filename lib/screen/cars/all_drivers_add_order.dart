import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/main.dart';
import 'package:zain/models/driver.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/provider/providerState.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/button.dart';
import 'package:zain/widgets/snackbar.dart';

class AddOrderToDriver extends StatefulWidget {
  DriverModel driverModel;
  AddOrderToDriver({this.driverModel});
  @override
  _AddOrderToDriverState createState() => _AddOrderToDriverState();
}

class _AddOrderToDriverState extends State<AddOrderToDriver> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context,listen: false).getOrders(true);
    });
    super.initState();
  }
  List<String> ordersForDriver =[];
  Widget buildOrderItem({
    OrderModel orderModel,
    int orderNumber,
    String price="0",
    index,
    BuildContext context,}) {
    return Container(
      height: 110,
      child: Card(
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(backgroundColor: Color.fromRGBO(255, 0, 0, 1),child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("#$index",style: TextStyle(color: Colors.white),),
                  ),),
                ],
              ),
              Column(

                children: [
                  Text(LocalizationConst.translate(context, "Product Numbers"),style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w600),),
                  SizedBox(height: 10.0,),
                  Text("$orderNumber",style: TextStyle(fontSize: 15.0),),

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocalizationConst.translate(context, "Status"),style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w600),),
                  SizedBox(height: 10.0,),
                  Text("${orderModel.status}",style: TextStyle(fontSize: 15.0,color: Colors.orange),),
                  Text("${DateFormat.yMd('ar').format(orderModel.createdAt)}"),

                ],
              ),
              Column(
                children: [
                  Text(LocalizationConst.translate(context, "Total Price"),style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w600),),
                  SizedBox(height: 10.0,),
                  Text("$price ${LocalizationConst.translate(context, "LE")}",style: TextStyle(fontSize: 15.0),),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){

                      if(widget.driverModel.orders.contains(orderModel.id)){
                        setState(() {
                          widget.driverModel.orders.remove(orderModel.id);
                        });
                      }else{
                      setState(() {
                        widget.driverModel.orders.add(orderModel.id);
                      });
                      }
                  }, child:!widget.driverModel.orders.contains(orderModel.id)?Text(LocalizationConst.translate(context, "Add to driver")):
                  Text(LocalizationConst.translate(context, "Remove"),style: TextStyle(color: Colors.red),)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  bool isUpdated = true;
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<AppProvider>(context,listen: false);
    var tProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: mainBar("Add Order To Driver", context,disPose: (){}),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children:[
          Container(
            width: double.infinity,
            height: double.infinity,
            child:Provider
                .of<AppProvider>(context)
                .orders.isNotEmpty?ListView.builder(
              itemBuilder: (context,index)=>buildOrderItem(
                context: context,
                orderNumber: tProvider.orders[index].orderList.length,
                index: index+1,
                price: tProvider.orders[index].totalPrice,
                orderModel: tProvider.orders[index],

              ),
              itemCount: tProvider.orders.length,
            ):Center(child: Text(LocalizationConst.translate(context, "No Orders")),)
        ),
          isUpdated?BuildButton(
            onPressed: (){
              setState(() {
                isUpdated = false;
              });
              DriverService().update(widget.driverModel, widget.driverModel.id, context).then((value) {
                BuildSnackBar(
                  color: Colors.greenAccent,
                  context: context,
                  title: "Saved"
                );
                setState(() {
                  isUpdated = true;
                });
              }).catchError((onError){
                BuildSnackBar(
                    color: Colors.greenAccent,
                    context: context,
                    title: "Something went wrong"
                );
                setState(() {
                  isUpdated = true;
                });
              });
            },
            title: "Save",
          ):SpinKitCircle(
            color: Theme.of(context).primaryColor,
            duration: Duration(milliseconds: 300),
          )
      ]
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/models/driver.dart';
import 'package:zain/models/order_model.dart';
class DriverProvider extends ChangeNotifier{
  DriverModel driverModel = new DriverModel();
  List<OrderModel> driverOrders = [];
  List<String> ordersIds =[];
  void removedFromList(OrderModel orderModel){
    driverOrders.remove(orderModel);
    notifyListeners();
  }
  bool isGet = true;
  void getDriver(driverID){
    isGet = false;
    notifyListeners();
    DriverService().getById(driverID).then((value){
      if(value!=null)
        driverModel = value;
      driverModel.orders.forEach((element) {
        ordersIds.add(element);
      });
      getDriverOrders(ordersIds);
    }).catchError((onError){
      print("error on getting driver model");
      isGet = true;
      notifyListeners();
    });
  }
  void getDriverOrders(List<String> ids){
    OrderService().readByIds(ids).then((value){
      if(value==null)
        driverOrders = [];
      driverOrders = value;
      isGet = true;
      notifyListeners();
    }).catchError((onError){
      isGet = true;
      notifyListeners();
      print("error on getting driver orders");
    });
  }
}
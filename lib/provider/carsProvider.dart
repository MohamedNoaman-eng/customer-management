import 'package:flutter/material.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/models/order_model.dart';

class CarsProvider extends ChangeNotifier {
  var driverNameController = TextEditingController();
  var driverPhoneController = TextEditingController();
  var driverIdController = TextEditingController();
  var carIdController = TextEditingController();
  var carCounterController = TextEditingController();
  var carConsumptionController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  List<OrderModel> orders =[];
  bool isGet = true;
  void clearControllers(){
     driverNameController.text = '';
     driverPhoneController .text = '';
     driverIdController .text = '';
     carIdController .text = '';
     carCounterController .text = '';
     carConsumptionController.text = '';
     emailController.text = '';
     passwordController .text = '';
     isGet = true;
     notifyListeners();
  }
  void addOrder(OrderModel orderModel){
    orders.add(orderModel);
    notifyListeners();
  }
  void getDriverId(){
    DriverService().getCount().then((value){
      driverIdController.text = (value+1).toString();
    }).catchError((onError){

    });
  }
  void getAllOrders(){
    isGet = false;
    notifyListeners();
    DriverService().getCount().then((value){
      driverIdController.text = (value+1).toString();
      OrderService().read().then((value) {
        if(value==null) {
          orders = [];
          isGet = true;
          notifyListeners();
        }else {
          orders = value;
          isGet = true;
          notifyListeners();
        }
      }).catchError((onError){
        print("error on getting orders $onError");
      });
    }).catchError((onError){

    });

  }
}
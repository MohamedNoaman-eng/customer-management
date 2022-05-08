import 'package:flutter/material.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/models/clientDetails.dart';
class ClientProvider extends ChangeNotifier{
  ClientDetails clientDetails = new ClientDetails();

  ClientService clientService = new ClientService();

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var governmentController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var ageController = TextEditingController();
  var cityController = TextEditingController();
  var areaController = TextEditingController();
  var discountController = TextEditingController();
  var idController = TextEditingController();
  var officerIdController = TextEditingController();
  bool isAdded = true;
  int count;
  void addPhone(String phone){
    clientDetails.phone.add(phone);
    print("addede");
    notifyListeners();

  }
  void clearControllers() {
    nameController.text = '';
    emailController.text = '';
    ageController.text = '';
    phoneController.text = '';
    officerIdController.text = '';
    governmentController.text = '';
    areaController.text = '';
    cityController.text = '';
    discountController.text = '';

    notifyListeners();
    getClientNumber();
  }
  void clearModel(){
    clientDetails = new ClientDetails();
    notifyListeners();
  }
  bool isGetClientNumber = true;
  void getClientNumber() async{
    isGetClientNumber = false;
    notifyListeners();
    count = await clientService.getCount();
    count+=1+1000;
    idController.text = count.toString();
    isGetClientNumber = true;
    notifyListeners();

  }
}
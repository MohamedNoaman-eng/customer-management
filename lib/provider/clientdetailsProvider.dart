import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/models/clientDetails.dart';

class ClientDetailsProvider extends ChangeNotifier {
  bool isChanged = false;
  var nameEditController = TextEditingController();
  var governmentEditController = TextEditingController();
  var areaController = TextEditingController();
  var phoneEditController = TextEditingController();
  var ageEditController = TextEditingController();
  var cityController = TextEditingController();
  var idEditController = TextEditingController();
  var consumptionController = TextEditingController();
  var createdOnController = TextEditingController();
  var discountController = TextEditingController();
  var emailController = TextEditingController();
  var numberOfOrdersController = TextEditingController();
  var officerIdController = TextEditingController();
  var rateController = TextEditingController();
  void clearControllers(){
      nameEditController.text = '';
      governmentEditController.text = '';
      areaController.text = '';
      phoneEditController.text = '';
      ageEditController.text = '';
      cityController.text = '';
      idEditController.text = '';
      consumptionController.text = '';
      createdOnController.text = '';
      discountController.text = '';
      emailController.text = '';
      numberOfOrdersController.text = '';
      officerIdController.text = '';
      rateController.text = '';
      print("all clearde");
      notifyListeners();

  }
  void clearClientList(){
    clients = [];
    notifyListeners();
  }
  List<ClientDetails> searchClient = [];
  List<String> clientIds=[];
  void setSearchMethod(){
    searchClient = clients;
    notifyListeners();
    clients.forEach((client) {
      clientIds.add(client.clientId);
    });
    notifyListeners();
  }
  void  fillClientFields(ClientDetails clientDetails){

      nameEditController.text = clientDetails.name;
      governmentEditController.text = clientDetails.government;
      ageEditController.text =  clientDetails.age;
      cityController.text = clientDetails.city;
      consumptionController.text = clientDetails.consumption.toString();
      createdOnController.text = formatDate(clientDetails.createdOn, [dd, '/', mm, '/', yyyy]);
      discountController.text =  clientDetails.discount.toString();
      emailController.text =  clientDetails.email;
      officerIdController.text = clientDetails.officerId;
      numberOfOrdersController.text = clientDetails.numberOfOrders.toString();
      rateController.text = clientDetails.rate.toString();
      areaController.text = clientDetails.area;
      idEditController.text = clientDetails.clientId;
      notifyListeners();

  }
  void changeIsChangedToTrue(){
    isChanged = true;
    notifyListeners();
  }
  void changeIsChangedToFalse(){
    isChanged = false;
    notifyListeners();
  }


  bool isGet = false;
  ClientService clientService = new ClientService();
  List<ClientDetails> clients = [];

  void getClients() {
    isGet = false;
    notifyListeners();
    clientService.getAllClients().then((value) {
      clients = value;
      isGet = true;
      setSearchMethod();

      print("all get");
      notifyListeners();
    }).catchError((onError){
      print("error is $onError");
    });

  }
  void clearSearchMethod(){
     searchClient = [];
     clientIds=[];
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/widgets/snackbar.dart';

class OfficerProvider extends ChangeNotifier {
  bool isGet = true;
  bool isAdded = true;
  List<LeaderModel> leaders = [];
  List<String> leadersIds = [];
  OfficerModel officerModel = new OfficerModel();
  OfficerService officerService = new OfficerService();
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var ageController = TextEditingController();
  var passwordController = TextEditingController();
  var orderRewardController = TextEditingController();

  void getOfficerId(int number) {
    idController.text = number.toString();
    notifyListeners();
  }

  void getAllLeaders() {
    isGet = false;
    notifyListeners();
    LeaderService().read().then((value) {
      if (value == null) {
        leaders = [];
      } else {
        leaders = value;
        value.forEach((element) {
          leadersIds.add(element.leaderId);
        });
        isGet = true;
        notifyListeners();
      }
    }).catchError((onError) {
      print("error on getting all leaders is $onError");
    });
  }

  void clearData() {
    nameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    ageController.text = '';
    passwordController.text = '';
    orderRewardController.text = '';
    officerModel = new OfficerModel();
    isGet = true;
    isAdded = true;
    notifyListeners();
  }

  void getAllOfficers() {
    officers = [];
    searchOfficers = [];
    officersIds = [];
    isGet = false;
    notifyListeners();
    OfficerService().read().then((value) {
      if (value == null) {
        officers = [];
      } else {
        officers = value;
        searchOfficers = value;
        officers.forEach((element) {
          officersIds.add(element.leaderId);
        });
      }

      isGet = true;
      notifyListeners();
    }).catchError((onError) {
      print("error on getting officers");
    });
  }

  List<OfficerModel> officers = [];
  List<OfficerModel> searchOfficers = [];
  List<String> officersIds = [];

  void clearDataList() {
    leaders = [];
    leadersIds = [];
    notifyListeners();
  }

  void addOfficer(BuildContext context, String id,LeaderModel leaderModel) {
    officerService.add(officerModel, id).then((value) {
      if(officerModel.leaderId.length!=0){
        leaderModel.officersIds.add(id);
        LeaderService().update(leaderModel, leaderModel.id, context).then((value){
          BuildSnackBar(
              color: Colors.greenAccent,
              context: context,
              title: "Officer Added Successfully");
          clearData();
        }).catchError((onError){
          BuildSnackBar(
              color: Colors.red,
              context: context,
              title: "Something went wrong");
          print(onError);
        });
      }else{
        BuildSnackBar(
            color: Colors.greenAccent,
            context: context,
            title: "Officer Added Successfully");
        clearData();
      }

    }).catchError((onError) {
      BuildSnackBar(
          color: Colors.red,
          context: context,
          title: "Something went wrong");
      print(onError);
    });

  }
}

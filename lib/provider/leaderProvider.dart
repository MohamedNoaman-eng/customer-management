import 'package:flutter/material.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/widgets/snackbar.dart';
class LeaderProvider extends ChangeNotifier{
  bool isGet = true;
  bool isAdded = true;
  List<OfficerModel> officers = [];
  List<String> officersIds =[];
  LeaderModel leaderModel = new LeaderModel();
  LeaderService leaderService = new LeaderService();
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var ageController = TextEditingController();
  var orderRewardController = TextEditingController();
  void getLeaderId() {

    LeaderService().getCount().then((value) {
      if(value!=null){
        idController.text = (value+1).toString();
        notifyListeners();
      }
    });
  }
  void getAllOfficers(){
    isGet = false;
    notifyListeners();
    OfficerService().read().then((value) {
      if(value==null){
        officers = [];
      }else{
        officers = value;
        value.forEach((element) {
          officersIds.add(element.officerId);
        });
        isGet = true;
        notifyListeners();
      }

    }).catchError((onError){
      print("error on getting all officers");
    });
  }
  void clearData(){
    nameController.text = '';
    emailController.text ='';
    phoneController.text ='';
    ageController.text = '';
    passwordController.text = '';
    orderRewardController.text = '';
    leaderModel = new LeaderModel();
    isGet = true;
    isAdded = true;
    notifyListeners();
  }
  void clearDataList(){
    officers = [];
    officersIds = [];
    notifyListeners();
  }
  void changeIsAddedToTrue(){
    isAdded = true;
    notifyListeners();
  }
  void changeIsAddedToFalse(){
    isAdded = false;
    notifyListeners();
  }

  void addLeader(BuildContext context,String id,List<OfficerModel> officer){
    leaderService.add(leaderModel,id).then((value){
      BuildSnackBar(
          color: Colors.greenAccent,
          context: context,
          title: "Leader Added Successfully"
      );
      officer.forEach((element) {
        element.leaderId = id;
        OfficerService().update(element, element.id, context).then((value){
          print("Updated");
          changeIsAddedToTrue();
          clearData();
        }).catchError((onError){
          print("error on updating officer");
        });
      });
      changeIsAddedToTrue();
      clearData();
      getLeaderId();


    }).catchError((onError){
      BuildSnackBar(
          color: Colors.greenAccent,
          context: context,
          title: "Something went wrong"
      );
    });
  }
}
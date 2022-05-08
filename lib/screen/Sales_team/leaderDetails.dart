import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/provider/leaderProvider.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class LeaderDetailsScreen extends StatefulWidget {
  LeaderModel leaderModel;

  LeaderDetailsScreen({this.leaderModel});

  @override
  _LeaderDetailsScreenState createState() => _LeaderDetailsScreenState();
}

class _LeaderDetailsScreenState extends State<LeaderDetailsScreen> {
  LeaderModel testLeaderModel = new LeaderModel();
  var idController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var ageController = TextEditingController();
  var phoneController = TextEditingController();
  var profitController = TextEditingController();
  var orderRewardController = TextEditingController();
  var joiningAtController = TextEditingController();
  var officersIdsController = TextEditingController();
  var ordersController = TextEditingController();
  var leaderIdController = TextEditingController();
  var leaderConsumptionController = TextEditingController();
  bool isGet = true;
  bool isUpdated = true;

  void fillTestModel() {
    setState(() {
      isGet = false;
    });
    testLeaderModel.leaderId = widget.leaderModel.leaderId;
    testLeaderModel.leaderName = widget.leaderModel.leaderName;
    testLeaderModel.leaderEmail = widget.leaderModel.leaderEmail;
    testLeaderModel.leaderPhone = widget.leaderModel.leaderPhone;
    testLeaderModel.leaderAge = widget.leaderModel.leaderAge;
    testLeaderModel.orderReward = widget.leaderModel.orderReward;
    testLeaderModel.joiningAt = widget.leaderModel.joiningAt;
    testLeaderModel.officersIds = widget.leaderModel.officersIds;
    testLeaderModel.id = widget.leaderModel.id;
    testLeaderModel.profit = widget.leaderModel.profit;
    testLeaderModel.orders = widget.leaderModel.orders;
  }

  bool isChanged = false;

  void checkChanges(context) {
    if (widget.leaderModel.orders != testLeaderModel.orders ||
        widget.leaderModel.profit != testLeaderModel.profit ||
        widget.leaderModel.officersIds != testLeaderModel.officersIds ||
        widget.leaderModel.joiningAt != testLeaderModel.joiningAt ||
        widget.leaderModel.orderReward != testLeaderModel.orderReward ||
        widget.leaderModel.leaderAge != testLeaderModel.leaderAge ||
        widget.leaderModel.leaderPhone != testLeaderModel.leaderPhone ||
        widget.leaderModel.leaderEmail != testLeaderModel.leaderEmail ||
        widget.leaderModel.leaderName != testLeaderModel.leaderName ||
        widget.leaderModel.leaderId != testLeaderModel.leaderId) {
      setState(() {
        isChanged = true;
      });
    } else {
      setState(() {
        isChanged = false;
      });
    }
  }

  fillLeaderFields() {
    idController.text = widget.leaderModel.leaderId;
    nameController.text = widget.leaderModel.leaderName;
    emailController.text = widget.leaderModel.leaderEmail;
    leaderConsumptionController.text = widget.leaderModel.totlaConsumpation.toString();
    ageController.text = widget.leaderModel.leaderAge;
    profitController.text = widget.leaderModel.profit.toString();
    orderRewardController.text = widget.leaderModel.orderReward;
    joiningAtController.text =
        formatDate(widget.leaderModel.joiningAt, [dd, '/', mm, '/', yyyy]);
    ordersController.text = widget.leaderModel.orders.length.toString();
  }

  @override
  void initState() {
    fillTestModel();
    fillLeaderFields();
    getAllOfficers();
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  List<OfficerModel> leaderOfficers = [];
  List<OfficerModel> officers = [];

  void getAllOfficers() {
    OfficerService().read().then((value) {
      if (value == null) {
        officers = [];
        leaderOfficers = [];
        setState(() {
          isGet = true;
        });
      }else{
        officers = value;
        officers.forEach((element) {
          if (widget.leaderModel.officersIds.contains(element.id)) {
            leaderOfficers.add(element);
          }
        });
        setState(() {
          isGet = true;
        });
      }

    }).catchError((onError) {});
  }
  void updateOfficers(){
    if(leaderOfficers.isNotEmpty){
      leaderOfficers.forEach((element) {
        OfficerService().update(element, element.id, context).then((value){

        }).catchError((onError){
          print(onError);
        });
      });
    }
  }
  OfficerModel officerModel = new OfficerModel();
  String leaderIdUpdate = '';
  void updateLeaderModel(){
    LeaderService().getById(leaderIdUpdate).then((value){
      value.officersIds.remove(officerModel.id);
      LeaderService().update(value, value.id, context).then((value){

      }).catchError((onError){

      });
    }).catchError((onError){

    });
  }
  @override
  Widget build(BuildContext context) {
    return isGet
        ? Scaffold(
            appBar: mainBar("Leader Details", context,disPose: (){}),
            body: Center(
              child: Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Form(
                      key: formKey,
                      child: LayoutBuilder(
                        builder: (context, constrains) => Container(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(children: <Widget>[
                            BuildTextFormField(
                              label: "Leader ID",
                              readOnly: true,
                              controller: idController,
                            ),
                            BuildTextFormField(
                              label: "Name",
                              controller: nameController,
                              onChanged: (val) {
                                widget.leaderModel.leaderName = val;
                              },
                            ),
                            BuildTextFormField(
                              label: "Email",
                              controller: emailController,
                              onChanged: (val) {
                                widget.leaderModel.leaderEmail = val;
                              },
                            ),
                            BuildTextFormField(
                              label: "Age",
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              type: TextInputType.number,
                              controller: ageController,
                              onChanged: (val) {
                                widget.leaderModel.leaderAge = val;
                              },
                            ),
                            Container(
                              height: 90,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: BuildTextFormField(
                                      controller: phoneController,
                                      label: "Phone",
                                      type: TextInputType.number,
                                      hint: "Enter phone number",
                                      labelValidate: "Enter phone number",
                                      isValidate: true,
                                      validator: (String val) {
                                        if (widget.leaderModel.leaderPhone
                                                .length !=
                                            0) {
                                          return null;
                                        } else {
                                          return LocalizationConst.translate(
                                              context,
                                              "Enter a valid phone number");
                                        }
                                      },
                                    ),
                                    flex: 4,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (!phoneController.text
                                                      .contains(
                                                          RegExp("[a-z]")) &&
                                                  !phoneController.text
                                                      .contains(
                                                          RegExp("[A-Z]")) &&
                                                  !phoneController.text
                                                      .contains(
                                                          RegExp("[ا-ي]"))&&!phoneController.text.contains(RegExp("[٠-٩]"))&&!phoneController.text.contains(RegExp("[۰-۹]"))) {
                                                setState(() {
                                                  widget.leaderModel.leaderPhone
                                                      .add(
                                                          phoneController.text);
                                                });
                                              } else {}
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 30.0,
                                              color: Colors.blue,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            widget.leaderModel.leaderPhone.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(LocalizationConst.translate(
                                          context, "Phone Numbers")),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: widget
                                                .leaderModel.leaderPhone.length,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(widget.leaderModel
                                                                .leaderPhone[
                                                            index]),
                                                        Expanded(
                                                          child: IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  widget
                                                                      .leaderModel
                                                                      .leaderPhone
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons.clear,
                                                                size: 15.0,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  width: 150,
                                                  height: 40,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            BuildTextFormField(
                              controller: orderRewardController,
                              type: TextInputType.number,
                              label: 'orderReward',
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              labelValidate:
                                  "Reward must be less than 100 and more than 0",
                              onChanged: (value) {
                                widget.leaderModel.orderReward = value;
                              },
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              alignment:
                                  LocalizationConst.getCurrentLang(context) == 1
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                              child: Text(
                                LocalizationConst.translate(context, "Officer"),
                              ),
                            ),
                            officers.isNotEmpty
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<
                                            OfficerModel>(
                                          hint: Text(
                                              LocalizationConst.translate(
                                                  context, "Officer")),
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                          iconSize: 28,
                                          elevation: 16,
                                          onChanged: (OfficerModel value) {
                                            setState(() {
                                              officerModel = value;
                                              leaderIdUpdate = officerModel.leaderId;
                                              officerModel.leaderId = widget.leaderModel.id;
                                            });
                                          },
                                          items: officers.map<
                                                  DropdownMenuItem<
                                                      OfficerModel>>(
                                              (OfficerModel value) {
                                            return DropdownMenuItem<
                                                OfficerModel>(
                                              value: value,
                                              child:
                                                  Text("${value.officerName}"),
                                            );
                                          }).toList(),
                                        ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  leaderOfficers
                                                      .add(officerModel);
                                                  widget.leaderModel.officersIds
                                                      .add(officerModel.id);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.blue,
                                                size: 28.0,
                                              )))
                                    ],
                                  )
                                : Text(LocalizationConst.translate(
                                    context, "Sorry there are no officers!")),
                            SizedBox(
                              height: 15.0,
                            ),
                            leaderOfficers.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(LocalizationConst.translate(
                                          context, "Officers Names")),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 70,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: leaderOfficers.length,
                                            itemBuilder: (context, index) =>
                                                Row(
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(leaderOfficers[
                                                                index]
                                                            .officerName),
                                                        Expanded(
                                                          child: IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  widget
                                                                      .leaderModel
                                                                      .officersIds
                                                                      .remove(leaderOfficers[
                                                                              index]
                                                                          .id);
                                                                  leaderOfficers
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons.clear,
                                                                size: 15.0,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  width: 150,
                                                  height: 40,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 15.0,
                            ),
                            BuildTextFormField(
                              label: "Date of joining",
                              readOnly: true,
                              controller: joiningAtController,
                            ),
                            BuildTextFormField(
                              label: "Profit",
                              type: TextInputType.number,
                              controller: profitController,
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              onChanged: (val) {
                                widget.leaderModel.profit = double.parse(val);
                              },
                            ),
                            BuildTextFormField(
                              label: "Consumption",
                              type: TextInputType.number,
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              controller: leaderConsumptionController,
                              onChanged: (val) {
                                widget.leaderModel.totlaConsumpation = double.parse(val);
                              },
                            ),
                            BuildTextFormField(
                              label: "Number Of Orders",
                              controller: ordersController,
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              type: TextInputType.number,
                            ),
                            SizedBox(height: 15.0),
                            isUpdated
                                ? ButtonTheme(
                                    minWidth: 400.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              width: 4.0),
                                        ),
                                        child: Text(
                                          LocalizationConst.translate(
                                              context, 'Update'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                        onPressed: () {
                                         if(whoIs==4){

                                         }else{
                                           if (formKey.currentState.validate()) {
                                             setState(() {
                                               isUpdated = false;
                                             });
                                             LeaderService()
                                                 .update(
                                                 widget.leaderModel,
                                                 widget.leaderModel.id,
                                                 context)
                                                 .then((value) {
                                               BuildSnackBar(
                                                   title:
                                                   "Leader update successfully",
                                                   context: context,
                                                   color: Colors.greenAccent);
                                               updateOfficers();
                                               updateLeaderModel();
                                               setState(() {
                                                 isUpdated = true;
                                               });
                                             }).catchError((onError) {
                                               setState(() {
                                                 isUpdated = true;
                                               });
                                               BuildSnackBar(
                                                   title: "Something went wrong",
                                                   context: context,
                                                   color: Colors.red);
                                             });
                                           }
                                         }
                                        }),
                                  )
                                : Center(
                                    child: SpinKitCircle(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      size: 50.0,
                                      duration: Duration(milliseconds: 300),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                width: 150,
                                height: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: OutlinedButton(
                                  child: Text(
                                    LocalizationConst.translate(
                                        context, "Delete"),
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                  if(whoIs==4){

                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                        new DeleteConfirmation(
                                            id: widget.leaderModel.id,
                                        officersIDs: widget.leaderModel.officersIds,));
                                  }
                                  },
                                ),
                              ),
                            )
                          ]),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Loading();
  }
}

class DeleteConfirmation extends StatefulWidget {
  final String id;
  List officersIDs;
  DeleteConfirmation({this.id,this.officersIDs});

  @override
  State createState() => new DeleteConfirmationState();
}

class DeleteConfirmationState extends State<DeleteConfirmation> {

  Future deleteOfficers(id)async{
      OfficerService().getById(id).then((value){
        value.leaderId = '';
        OfficerService().update(value, value.id, context).then((value){

        }).catchError((onError){
          print(onError);
        });
      }).catchError((onError){
        print(onError);
      });
  }
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocalizationConst.translate(context, "Delete Leader"),
        style: TextStyle(color: Color(0xFF8F5F43)),
      ),
      backgroundColor: Color(0xFFEAEAEA),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              LocalizationConst.translate(context, "Would you like to remove this Leader?"),
              style: TextStyle(
                color: Color(0xFF16071E),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            LocalizationConst.translate(context, "Confirm"),
            style: TextStyle(color: Color(0xFF067254)),
          ),
          onPressed: () {
            LeaderService().deleteClient(widget.id).then((value) {
              BuildSnackBar(
                  color: Colors.greenAccent,
                  context: context,
                  title: "Client deleted successfully");
              Provider.of<LeaderProvider>(context,listen: false).getAllOfficers();
              
              widget.officersIDs.forEach((element) async{
                await deleteOfficers(element);
              });

            }).catchError((onError) {
              print(onError);
              BuildSnackBar(
                  color: Colors.red,
                  context: context,
                  title: "Something went wrong");
            });

          },
        ),
        TextButton(
          child: Text(
            LocalizationConst.translate(context, "Close"),
            style: TextStyle(color: Color(0xFFDA2C2C)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    //     LocalizationConst.translate(context, "DONE"),
  }
}

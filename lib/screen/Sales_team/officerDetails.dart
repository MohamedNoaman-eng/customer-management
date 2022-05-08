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
import 'package:zain/provider/carsProvider.dart';
import 'package:zain/provider/officerProvider.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class OfficerDetailsScreen extends StatefulWidget {
  OfficerModel officerModel;

  OfficerDetailsScreen({this.officerModel});

  @override
  _OfficerDetailsScreenState createState() => _OfficerDetailsScreenState();
}

class _OfficerDetailsScreenState extends State<OfficerDetailsScreen> {
  OfficerModel testOfficerModel = new OfficerModel();
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

  void clearControllers() {
    setState(() {
      isGet = true;
      isUpdated = true;
      idController.text = '';
      nameController.text = '';
      emailController.text = '';
      ageController.text = '';
      phoneController.text = '';
      profitController.text = '';
      orderRewardController.text = '';
      joiningAtController.text = '';
      officersIdsController.text = '';
      ordersController.text = '';
      leaderIdController.text = '';
      testOfficerModel = new OfficerModel();
      widget.officerModel = new OfficerModel();
      isChanged = false;
      leaders = [];
      leaderModel = new LeaderModel();
    });
  }

  void fillTestModel() {
    testOfficerModel.leaderId = widget.officerModel.leaderId;
    testOfficerModel.officerName = widget.officerModel.officerName;
    testOfficerModel.officerEmail = widget.officerModel.officerEmail;
    testOfficerModel.officerPhone = widget.officerModel.officerPhone;
    testOfficerModel.officerAge = widget.officerModel.officerAge;
    testOfficerModel.orderReward = widget.officerModel.orderReward;
    testOfficerModel.joiningAt = widget.officerModel.joiningAt;
    testOfficerModel.leaderId = widget.officerModel.leaderId;
    testOfficerModel.id = widget.officerModel.id;
    testOfficerModel.profit = widget.officerModel.profit;
    testOfficerModel.orders = widget.officerModel.orders;
  }

  bool isChanged = false;

  void checkChanges(context) {
    if (widget.officerModel.orders != testOfficerModel.orders ||
        widget.officerModel.profit != testOfficerModel.profit ||
        widget.officerModel.leaderId != testOfficerModel.leaderId ||
        widget.officerModel.orderReward != testOfficerModel.orderReward ||
        widget.officerModel.officerAge != testOfficerModel.officerAge ||
        widget.officerModel.officerPhone != testOfficerModel.officerPhone ||
        widget.officerModel.officerEmail != testOfficerModel.officerEmail ||
        widget.officerModel.officerName != testOfficerModel.officerName) {
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
    idController.text = widget.officerModel.officerId;
    nameController.text = widget.officerModel.officerName;
    emailController.text = widget.officerModel.officerEmail;
    ageController.text = widget.officerModel.officerAge;
    leaderConsumptionController.text = widget.officerModel.totlaConsumpation.toString();
    profitController.text = widget.officerModel.profit.toString();
    orderRewardController.text = widget.officerModel.orderReward.toString();
    joiningAtController.text =
        formatDate(widget.officerModel.joiningAt, [dd, '/', mm, '/', yyyy]);
    ordersController.text = widget.officerModel.orders.length.toString();
  }

  @override
  void initState() {
    fillTestModel();
    fillLeaderFields();
    getAllOfficers();
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  LeaderModel leaderModel = new LeaderModel();
  List<LeaderModel> leaders = [];
  LeaderModel leaderModel2 = new LeaderModel();

  void getAllOfficers() {
    setState(() {
      isGet = false;
    });
    LeaderService().read().then((value) {
      if (value != null) {
        leaders = value;
        leaderModel = value.singleWhere(
            (element) => element.id == widget.officerModel.leaderId,
            orElse: () => null);
        setState(() {
          isGet = true;
        });
      } else {
        leaders = [];
        setState(() {
          isGet = true;
        });
      }
    }).catchError((onError) {
      print("error on getting leader$onError");
    });
  }

  void updateLeader(LeaderModel leaderModel) {
    LeaderService()
        .update(leaderModel, leaderModel.id, context)
        .then((value) {})
        .catchError((onError) {});
  }

  @override
  Widget build(BuildContext context) {
    return isGet
        ? Scaffold(
            appBar: mainBar("Officer Details", context, disPose: () {}),
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
                              label: "Officer ID",
                              readOnly: true,
                              controller: idController,
                              labelValidate: "Enter ID",
                            ),
                            BuildTextFormField(
                              label: "Name",
                              controller: nameController,
                              onChanged: (val) {
                                widget.officerModel.officerName = val;
                              },
                              labelValidate: "Enter name",
                            ),
                            BuildTextFormField(
                              label: "Email",
                              type: TextInputType.number,
                              controller: emailController,
                              onChanged: (val) {
                                widget.officerModel.officerEmail = val;
                              },
                              labelValidate: "Enter email",
                            ),
                            BuildTextFormField(
                              label: "Age",
                              type: TextInputType.number,
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              controller: ageController,
                              onChanged: (val) {
                                widget.officerModel.officerAge = val;
                              },
                              labelValidate: "Enter age",
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              height: 110,
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
                                        if (widget.officerModel.officerPhone
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
                                                  widget
                                                      .officerModel.officerPhone
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
                            widget.officerModel.officerPhone.isNotEmpty
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
                                            itemCount: widget.officerModel
                                                .officerPhone.length,
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
                                                        Text(widget.officerModel
                                                                .officerPhone[
                                                            index]),
                                                        Expanded(
                                                          child: IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  widget
                                                                      .officerModel
                                                                      .officerPhone
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
                                widget.officerModel.orderReward =
                                    double.parse(value);
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
                                LocalizationConst.translate(context, "Leader"),
                              ),
                            ),
                            leaders.isNotEmpty
                                ? DropdownButtonFormField<LeaderModel>(
                                    hint: Text(LocalizationConst.translate(
                                        context, "Leader")),
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded),
                                    iconSize: 28,
                                    elevation: 16,
                                    validator: (LeaderModel val) {
                                      if (val == null) {
                                        return "Select leader";
                                      } else {
                                        return null;
                                      }
                                    },
                                    value: leaderModel,
                                    onChanged: (LeaderModel value) {
                                      setState(() {

                                        widget.officerModel.leaderId = value.id;
                                       if(widget.officerModel.leaderId!=leaderModel.id){
                                         leaderModel2 = value;
                                         if(!leaderModel2.officersIds.contains(widget.officerModel.id)){
                                           leaderModel2.officersIds.add(widget.officerModel.id);
                                         }

                                         if(widget.officerModel.leaderId!=leaderModel.id){
                                           leaderModel.officersIds.remove(widget.officerModel.id);
                                         }
                                       }
                                      });
                                    },
                                    items: leaders
                                        .map<DropdownMenuItem<LeaderModel>>(
                                            (LeaderModel value) {
                                      return DropdownMenuItem<LeaderModel>(
                                        value: value,
                                        child:
                                            Text("${value.leaderName ?? ''}"),
                                      );
                                    }).toList(),
                                  )
                                : Text(LocalizationConst.translate(
                                    context, "Sorry there are no leaders!")),
                            SizedBox(
                              height: 15.0,
                            ),
                            BuildTextFormField(
                              label: "Date of joining",
                              readOnly: true,
                              controller: joiningAtController,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            BuildTextFormField(
                              label: "Profit",
                              type: TextInputType.number,
                              controller: profitController,
                              onChanged: (val) {
                                widget.officerModel.profit = double.parse(val);
                              },
                              validator: (String val){
                                if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                                  return LocalizationConst.translate(context, "Please enter english number");
                                }else{
                                  return null;
                                }
                              },
                              isValidate: true,
                              labelValidate: "Enter profit",
                            ),
                            SizedBox(
                              height: 15.0,
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
                                widget.officerModel.totlaConsumpation = double.parse(val);
                              },
                              labelValidate: "Enter consumption",
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
                                            OfficerService()
                                                .update(
                                                widget.officerModel,
                                                widget.officerModel.id,
                                                context)
                                                .then((value) {
                                              BuildSnackBar(
                                                  title:
                                                  "Officer update successfully",
                                                  context: context,
                                                  color: Colors.greenAccent);
                                              setState(() {
                                                isUpdated = true;
                                              });
                                              if(widget.officerModel.leaderId!=leaderModel.id) {
                                                updateLeader(leaderModel);
                                                updateLeader(leaderModel2);
                                                leaderModel = leaderModel2;
                                              }
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
                                             id: widget.officerModel.id));
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

  const DeleteConfirmation({this.id});

  @override
  State createState() => new DeleteConfirmationState();
}

class DeleteConfirmationState extends State<DeleteConfirmation> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocalizationConst.translate(context, "Delete Officer"),
        style: TextStyle(color: Color(0xFF8F5F43)),
      ),
      backgroundColor: Color(0xFFEAEAEA),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              LocalizationConst.translate(
                  context, "Would you like to remove this Officer?"),
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
            OfficerService().deleteClient(widget.id).then((value) {
              BuildSnackBar(
                  color: Colors.greenAccent,
                  context: context,
                  title: "Officer deleted successfully");
              Navigator.pop(context);
            }).catchError((onError) {
              BuildSnackBar(
                  color: Colors.red,
                  context: context,
                  title: "Something went wrong");
            });
            Provider.of<OfficerProvider>(context, listen: false)
                .getAllOfficers();
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

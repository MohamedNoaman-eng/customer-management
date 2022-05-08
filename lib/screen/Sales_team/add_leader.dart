import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/auth.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/provider/leaderProvider.dart';
import 'package:zain/provider/officerProvider.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/textformfield.dart';

class AddLeader extends StatefulWidget {
  @override
  _AddLeaderState createState() => _AddLeaderState();
}

var formKey = GlobalKey<FormState>();
GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

class _AddLeaderState extends State<AddLeader> {
 bool isGetLeaderId = true;


  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LeaderProvider>(context, listen: false).getLeaderId();
      Provider.of<LeaderProvider>(context, listen: false).getAllOfficers();
    });
    super.initState();
  }

  List<String> phones = [];
  List<OfficerModel> officerModels = [];
  List<OfficerModel> officers = [];
  List<String> officersIds = [];

  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<LeaderProvider>(context, listen: false);
    var tProvider = Provider.of<LeaderProvider>(context);
    return Scaffold(
      appBar: mainBar("Leader", context, disPose: () {
        fProvider.clearDataList();
        fProvider.clearData();
      }),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
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
                        readOnly: true,
                        label: "Leader ID",

                        controller: tProvider.idController,
                        validator: (value) {
                          if (value == null) {
                            return LocalizationConst.translate(context,
                                "Id is empty, refresh the page to fill it");
                          }
                          return null;
                        },
                        isValidate: true,
                        onChanged: (String value) {
                          fProvider.leaderModel.leaderId = value;
                        },
                        type: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildTextFormField(
                        label: "Leader Name",
                        hint: "Enter leader name",
                        controller: tProvider.nameController,
                        labelValidate: "Enter name",
                        onChanged: (String value) {
                          fProvider.leaderModel.leaderName = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildTextFormField(
                        label: 'Email',
                        hint: "Enter email",
                        type: TextInputType.emailAddress,
                        labelValidate: "Enter email",
                        controller: tProvider.emailController,
                        onChanged: (value) {
                          fProvider.leaderModel.leaderEmail = value;
                        },
                        isValidate: true,
                        validator: (val) => val.isEmpty
                            ? LocalizationConst.translate(
                                context, "Enter email")
                            : null,
                      ),
                      SizedBox(height: 15.0,),
                      BuildTextFormField(
                        label: "Password",
                        hint: "Password",
                        validator: (val) => val.isEmpty
                            ? LocalizationConst.translate(
                                context, "Enter password")
                            : null,
                        isValidate: true,
                        type: TextInputType.visiblePassword,
                        controller: tProvider.passwordController,
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
                                controller: tProvider.phoneController,
                                label: "Phone",
                                type: TextInputType.number,
                                hint: "Enter phone number",
                                labelValidate: "Enter phone number",
                                isValidate: true,
                                validator: (String val) {
                                  if (phones.length != 0) {
                                    return null;
                                  } else {
                                    return LocalizationConst.translate(
                                        context, "Enter a valid phone number");
                                  }
                                },
                              ),
                              flex: 4,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        if (!fProvider.phoneController.text
                                                .contains(RegExp("[a-z]")) &&
                                            !fProvider.phoneController.text
                                                .contains(RegExp("[A-Z]")) &&
                                            !fProvider.phoneController.text
                                                .contains(RegExp("[ا-ي]"))&&fProvider.phoneController.text.length==11&&!fProvider.phoneController.text.contains(RegExp("[٠-٩]"))&&!fProvider.phoneController.text.contains(RegExp("[۰-۹]"))) {
                                          setState(() {
                                            phones.add(
                                                fProvider.phoneController.text);
                                          });
                                          fProvider.phoneController.text = '';
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
                      phones.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LocalizationConst.translate(context, "Phone Numbers")),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: phones.length,
                                      itemBuilder: (context, index) => Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(phones[index]),
                                                  Expanded(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            phones.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.clear,
                                                          size: 15.0,
                                                          color: Colors.red,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
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
                          : SizedBox(width: 0.0,),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildTextFormField(
                        controller: tProvider.ageController,
                        label: 'Age',
                        hint: "Enter age",
                        isValidate: true,
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        type: TextInputType.number,
                        labelValidate: "Enter age",
                        onChanged: (value) {
                          fProvider.leaderModel.leaderAge = value;
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildTextFormField(
                          controller: tProvider.orderRewardController,
                          type: TextInputType.number,
                          label: 'orderReward',
                          hint: "orderReward",
                          isValidate: true,
                          validator: (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                          labelValidate:
                              "Reward must be less than 100 and more than 0",
                          onChanged: (value) {
                            fProvider.leaderModel.orderReward = value;
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
                      tProvider.officers.isNotEmpty
                          ? DropdownButtonFormField<OfficerModel>(
                              hint: Text(LocalizationConst.translate(
                                  context, "Officer")),
                              icon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              iconSize: 28,
                              elevation: 16,
                              validator: (val) {
                                if (val == null) {
                                  return "اختار موظف";
                                }

                                return null;
                              },
                              onChanged: (OfficerModel value) {
                                setState(() {
                                  officers.add(value);
                                  officersIds.add(value.id);
                                  officerModels.add(value);
                                });
                              },
                              items: tProvider.officers
                                  .map<DropdownMenuItem<OfficerModel>>(
                                      (OfficerModel value) {
                                return DropdownMenuItem<OfficerModel>(
                                  value: value,
                                  child: Text("${value.officerName}"),
                                );
                              }).toList(),
                            )
                          : Text(LocalizationConst.translate(context, "There are no officers")),
                      SizedBox(height: 15.0,),
                      officers.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LocalizationConst.translate(context, "Officers Names")),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: officers.length,
                                      itemBuilder: (context, index) => Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(officers[index]
                                                      .officerName),
                                                  Expanded(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            officers.removeAt(
                                                                index);
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.clear,
                                                          size: 15.0,
                                                          color: Colors.red,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
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
                          : SizedBox(width: 0.0,),
                      SizedBox(height: 15.0),
                      tProvider.isAdded
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
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        width: 4.0),
                                  ),
                                  child: Text(
                                    LocalizationConst.translate(
                                        context, 'Save'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                  onPressed: () {
                                    if (formKey.currentState.validate()) {
                                      fProvider.changeIsAddedToFalse();
                                      fProvider.leaderModel.joiningAt =
                                          DateTime.now();
                                      fProvider.leaderModel.leaderPhone =
                                          phones;
                                      fProvider.leaderModel.leaderId =
                                          fProvider.idController.text;
                                      fProvider.leaderModel.officersIds =
                                          officersIds;

                                      AuthService()
                                          .registerWithEmailAndPassword(
                                              tProvider.emailController.text,
                                              tProvider.passwordController.text)
                                          .then((value) {
                                        fProvider.addLeader(context, value,officerModels);
                                        phones = [];
                                        officers = [];
                                        officersIds = [];
                                        officerModels = [];
                                      });

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
                            child: Text(LocalizationConst.translate(
                                context, "Clear Fields")),
                            onPressed: () {
                              fProvider.clearData();
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
    );
  }
}

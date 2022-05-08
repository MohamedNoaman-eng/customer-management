

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/auth.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/provider/officerProvider.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/textformfield.dart';

class AddOfficer extends StatefulWidget {
  @override
  _AddOfficerState createState() => _AddOfficerState();
}
var formKey = GlobalKey<FormState>();
GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
class _AddOfficerState extends State<AddOfficer> {
  bool idGetOfficerId = true;
  void getOfficerId(){
    OfficerService().getCount().then((value){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Provider.of<OfficerProvider>(context,listen: false).getOfficerId(value+1);
      });

    });
  }
  LeaderModel leaderModel = new LeaderModel();
  List<String> phones = [];
  @override
  void initState() {
    getOfficerId();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OfficerProvider>(context,listen: false).getAllLeaders();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<OfficerProvider>(context,listen: false);
    var tProvider = Provider.of<OfficerProvider>(context);
    return Scaffold(
      appBar: mainBar("Officer", context,disPose: (){
        fProvider.clearDataList();
        fProvider.clearData();
      }),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width ,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Form(
                key: formKey,
                child: LayoutBuilder(
                  builder:(context,constrains)=> Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: <Widget>[
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, "Officer ID"),
                            ),
                          ),
                          TextFormField(
                            readOnly: true,
                            controller: tProvider.idController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Color(0xff16071E)),
                            onChanged: (String value) {
                              fProvider.officerModel.officerId = value;
                            },
                            validator: (value){
                              if(value==null){
                                return LocalizationConst.translate(context, "Id is empty, refresh the page to fill it");
                              }
                              return null;
                            },

                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, "Officer Name"),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: tProvider.nameController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Color(0xff16071E)),
                            onChanged: (String value) {
                              fProvider.officerModel.officerName = value;
                            },
                            decoration: textInputDecoration.copyWith(
                              hintText: LocalizationConst.translate(
                                  context, "Enter name"),
                            ),
                            validator: (val) => val.isEmpty
                                ? LocalizationConst.translate(
                                context, "Enter name")
                                : null,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, 'Email'),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: tProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Color(0xff16071E)),
                            decoration: textInputDecoration.copyWith(
                                hintText: LocalizationConst.translate(
                                    context, "Enter email")),
                            validator:(val) => val.isEmpty
                                ? LocalizationConst.translate(
                                context, "Enter email")
                                : null,
                            onChanged: (value) {
                              fProvider.officerModel.officerEmail = value;
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, 'Password'),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            controller: tProvider.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(color: Color(0xff16071E)),
                            decoration: textInputDecoration.copyWith(
                                hintText: LocalizationConst.translate(
                                    context, "Enter password")),
                            validator: (val) => val.isEmpty
                                ? LocalizationConst.translate(
                                context, "Enter password")
                                : null,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(

                            child: Row(
                              children: [
                                Expanded(
                                  child: BuildTextFormField(
                                    controller:  tProvider.phoneController,
                                    label: "Phone",
                                    type: TextInputType.number,
                                    hint: "Enter phone number",
                                    labelValidate: "Enter phone number",
                                    isValidate: true,
                                    validator: (String val) {
                                      if (phones.length!=0) {
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
                                            if(!fProvider.phoneController.text.contains(RegExp("[a-z]"))
                                                &&!fProvider.phoneController.text.contains(RegExp("[A-Z]"))
                                                &&!fProvider.phoneController.text.contains(RegExp("[ا-ي]"))&&
                                                fProvider.phoneController.text.length==11&&!fProvider.phoneController.text.contains(RegExp("[٠-٩]"))&&!fProvider.phoneController.text.contains(RegExp("[۰-۹]"))){
                                              setState(() {
                                                phones.add(fProvider.phoneController.text);
                                              });
                                              fProvider.phoneController.text = '';
                                            }else{

                                            }
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
                          SizedBox(height: 10.0,),
                          phones.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LocalizationConst.translate(context, "Phone Numbers")),
                              SizedBox(
                                height: 15.0,
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
                              : SizedBox(),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, 'Age'),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(

                            controller: tProvider.ageController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Color(0xff16071E)),
                            decoration: textInputDecoration.copyWith(
                                hintText:
                                LocalizationConst.translate(context, "Enter age")),
                            validator: (String val){
                              if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                return LocalizationConst.translate(context, "Please enter english number");
                              }else{
                                return null;
                              }
                            },
                            onChanged: (value) {
                              fProvider.officerModel.officerAge = value;
                            },
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, 'orderReward'),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          TextFormField(
                            controller: tProvider.orderRewardController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Color(0xff16071E)),
                            decoration: textInputDecoration.copyWith(
                                hintText:
                                LocalizationConst.translate(context, "orderReward")),
                            validator: (String val){
                              if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                return LocalizationConst.translate(context, "Please enter english number");
                              }else{
                                return null;
                              }
                            },
                            onChanged: (value) {
                              fProvider.officerModel.orderReward = double.parse(value);
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: LocalizationConst.getCurrentLang(context) == 1
                                ? Alignment.topLeft
                                : Alignment.topRight,
                            child: Text(
                              LocalizationConst.translate(context, "Leader"),
                            ),
                          ),
                          tProvider.leaders.isNotEmpty? DropdownButtonFormField<LeaderModel>(
                            hint: Text(LocalizationConst.translate(
                                context, "Leader")),
                            icon: const Icon(
                                Icons.keyboard_arrow_down_rounded),
                            iconSize: 28,
                            elevation: 16,
                            validator: (val){
                              if(val==null){
                                return "اختار قائد";
                              }

                              return null;
                            },
                            onChanged: (LeaderModel value) {
                              fProvider.officerModel.leaderId = value.id;
                              leaderModel = value;
                            },
                            items: tProvider.leaders.map<DropdownMenuItem<LeaderModel>>(
                                    (LeaderModel value) {
                                  return DropdownMenuItem<LeaderModel>(
                                    value: value,
                                    child: Text(
                                        "${value.leaderName}"),
                                  );
                                }).toList(),
                          ):
                          Text(LocalizationConst.translate(context, "Sorry there are no leaders!")),
                          SizedBox(height: 15.0),
                          tProvider.isAdded? ButtonTheme(
                            minWidth: 400.0,
                            height: 50.0,
                            child: RaisedButton(
                                color: Color.fromRGBO(255, 0, 0, 1),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color:Color.fromRGBO(255, 0, 0, 1), width: 4.0),
                                ),
                                child: Text(
                                  LocalizationConst.translate(context, 'Save'),
                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                ),
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    setState(() {
                                      fProvider.isAdded = false;
                                    });
                                    fProvider.officerModel.officerId = fProvider.idController.text;
                                    fProvider.officerModel.joiningAt = DateTime.now();
                                    fProvider.officerModel.officerPhone = phones;
                                    AuthService().registerWithEmailAndPassword(fProvider.emailController.text, fProvider.passwordController.text)
                                        .then((value){
                                      fProvider.addOfficer(context,value,leaderModel);
                                      getOfficerId();
                                      phones = [];
                                    });


                                  }
                                }),
                          ):Center(child:SpinKitCircle(
                            color: Color.fromRGBO(255, 0, 0, 1),
                            size: 50.0,
                            duration: Duration(milliseconds: 300),
                          ),),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: OutlinedButton(
                                child: Text(LocalizationConst.translate(context, "Clear Fields")),
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

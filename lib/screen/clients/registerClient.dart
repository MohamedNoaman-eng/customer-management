import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/provider/clientProvider.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class RegisterClient extends StatefulWidget {
  @override
  _RegisterClientState createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClientProvider>(context, listen: false).getClientNumber();
    });

    super.initState();
  }

  RegExp hexColor = RegExp("[0-9]");
  List<String> photos = [];

  void addPhotos(String number){
    setState(() {
      photos.add(number);
    });
  }
  StreamSubscription ps;
  var per;
  bool getLocation = false;
  double late=0.0;
  double lang = 0.0;
  void getLatAndLong(context) {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((value) async{
      setState(() {
        late = value.latitude;
        lang = value.longitude;
        getLocation = true;
      });
      BuildSnackBar(
        color: Colors.greenAccent,
        title: "Uploaded",
        context: context
      );

    }).catchError((onError){
        print("error on getting location");
        getLocation = true;
    });
  }
  Future requestpermission(context) async {
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied) {
      per = await Geolocator.requestPermission().then((value) {
        if (per == LocationPermission.whileInUse ||
            per == LocationPermission.always) {
          getLatAndLong(context);
        }
      });
    } else {
      getLatAndLong(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<ClientProvider>(context, listen: false);
    var tProvider = Provider.of<ClientProvider>(context);

    return tProvider.isGetClientNumber?Scaffold(
      appBar: mainBar("Register client", context,disPose: (){
        fProvider.clearControllers();
      }),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Form(
                key: tProvider.formKey,
                child: LayoutBuilder(
                  builder: (context, constrains) => Container(
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: <Widget>[

                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 8.0,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                LocalizationConst.translate(
                                    context, "Client information"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        label: "Client ID",
                        controller: fProvider.idController,
                        readOnly: true,
                        isValidate: true,
                        validator: (value){
                          if(value==null){
                            return LocalizationConst.translate(context, "Id is empty, refresh the page to fill it");
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      BuildTextFormField(
                        controller: fProvider.nameController,
                        label: "Name",
                        hint: "Enter name",
                        labelValidate: "Enter name",
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      BuildTextFormField(
                        controller: fProvider.emailController,
                        label: "Email Optional",
                        hint: "Enter email",
                        labelValidate: "Enter email",
                        isValidate: true,

                      ),
                      SizedBox(
                        height: 5.0,
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
                                  if (photos.length!=0) {
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
                                  //if(val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty)
                                  IconButton(
                                      onPressed: () {
                                        if(!fProvider.phoneController.text.contains(RegExp("[a-z]"))
                                            &&!fProvider.phoneController.text.contains(RegExp("[A-Z]"))
                                            &&!fProvider.phoneController.text.contains(RegExp("[ا-ي]"))&&fProvider.phoneController.text.contains(RegExp("[0-9]"))
                                        &&fProvider.phoneController.text.length==11&&!fProvider.phoneController.text.contains(RegExp("[٠-٩]"))&&!fProvider.phoneController.text.contains(RegExp("[۰-۹]"))){
                                          addPhotos(
                                              fProvider.phoneController.text);
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
                      photos.isNotEmpty
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
                                itemCount: photos.length,
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            Text(photos[index]),
                                            Expanded(
                                              child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      photos.removeAt(
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
                      SizedBox(height: 5.0),
                      BuildTextFormField(
                        controller: fProvider.ageController,
                        label: "Age",
                        hint: "Enter age",
                        type: TextInputType.number,
                        isValidate: true,
                        labelValidate: "Enter age",
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 8.0,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                LocalizationConst.translate(
                                    context, "Shop information"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        controller: fProvider.governmentController,
                        label: "Government",
                        hint: "Enter government",
                        labelValidate: "Enter government",
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        controller: fProvider.cityController,
                        label: "City",
                        hint: "Enter city",
                        labelValidate: "Enter city",
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        controller: fProvider.areaController,
                        label: "Area",
                        hint: "Enter area",
                        labelValidate: "Enter area",
                      ),
                      SizedBox(height: 15.0),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(LocalizationConst.translate(context,"Location")),
                         Container(
                           decoration: BoxDecoration(
                               border: Border.all(color: Colors.grey)
                           ),
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 !getLocation?Text(LocalizationConst.translate(context, "Upload Location")):
                                 Text(LocalizationConst.translate(context, "Uploaded"),style: TextStyle(color: Colors.green[900]),),
                                 SizedBox(width: 20.0,),
                                 Visibility(
                                   visible: !getLocation,
                                   child: OutlinedButton(onPressed: (){
                                     requestpermission(context);
                                   },
                                       child: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Icon(getLocation? Icons.location_on:Icons.add_location_outlined,color: Colors.blue,size: 25.0,),
                                       )),
                                 )
                               ],
                             ),
                           ),
                         ),
                       ],
                     ),
                      SizedBox(height: 15.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 8.0,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                LocalizationConst.translate(
                                    context, "Supplier information"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        controller: fProvider.discountController,
                        label: "Discount",
                        isValidate: true,
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        type: TextInputType.number,
                        hint: "Enter client discount",
                        labelValidate: "Enter client discount",
                      ),
                      BuildTextFormField(
                        label: "Date of joining",
                        hint: "Automatically record",
                        readOnly: true,
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Color.fromRGBO(255, 0, 0, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 8.0,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                LocalizationConst.translate(
                                    context, "Officer information"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      BuildTextFormField(
                        controller: fProvider.officerIdController,
                        label: "Your Id",
                        hint: "Enter your id",
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        isValidate: true,
                        type: TextInputType.number,
                        labelValidate: "Enter your id",
                      ),
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
                                    if (tProvider.formKey.currentState.validate()) {

                                      fProvider.clientDetails.late = late;
                                      fProvider.clientDetails.lang = lang;
                                      fProvider.clientDetails.clientId = fProvider.idController.text;
                                      fProvider.clientDetails.name = fProvider.nameController.text;
                                      fProvider.clientDetails.email = fProvider.emailController.text;
                                      fProvider.clientDetails.createdOn =DateTime.now();
                                      fProvider.clientDetails.age = fProvider.ageController.text;
                                      fProvider.clientDetails.phone = photos;
                                      fProvider.clientDetails.government = fProvider.governmentController.text;
                                      fProvider.clientDetails.area = fProvider.areaController.text;
                                      fProvider.clientDetails.city = fProvider.cityController.text;
                                      fProvider.clientDetails.officerId = fProvider.officerIdController.text;
                                      fProvider.clientDetails.discount = double.parse(fProvider.discountController.text);
                                      if(fProvider.clientDetails.lang==0.0||fProvider.clientDetails.late==0.0){
                                        BuildSnackBar(
                                          context: context,
                                          title: "Please upload location",
                                          color: Colors.red
                                        );
                                      }else{
                                        setState(() {
                                          tProvider.isAdded = false;
                                        });
                                        fProvider.clientService.add(fProvider.clientDetails).then((value) {
                                          setState(() {
                                            fProvider.isAdded = true;
                                          });
                                          BuildSnackBar(
                                              title: "Client added successfully",
                                              context: context,
                                              color: Colors.greenAccent);
                                          fProvider.clearModel();
                                          fProvider.clearControllers();
                                          setState(() {
                                            photos = [];
                                            getLocation=false;
                                            late=0.0;
                                            lang=0.0;
                                          });

                                        }).catchError((error) {
                                          BuildSnackBar(
                                              color: Colors.red,
                                              context: context,
                                              title: "Something went wrong");
                                        });
                                      }
                                    }
                                  }),
                            )
                          : Center(
                              child: SpinKitCircle(
                                color:Theme.of(context).primaryColor,
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
                                  context, "Clear Fields"),
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              fProvider.clearControllers();
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
    ):Loading();
  }
}

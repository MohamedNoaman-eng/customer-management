import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/clientDetails.dart';

import 'package:zain/provider/clientdetailsProvider.dart';

import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class ClientDetailsScreen extends StatefulWidget {
  ClientDetails clientDetails;

  ClientDetailsScreen({Key key, this.clientDetails}) : super(key: key);

  @override
  _ClientDetailsScreenState createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  ClientDetails testClientDetails = new ClientDetails();
  bool isGet = true;

  var formKey = GlobalKey<FormState>();

  void fillTestModel() {
    testClientDetails.clientId = widget.clientDetails.clientId;
    testClientDetails.name = widget.clientDetails.name;
    testClientDetails.email = widget.clientDetails.email;
    testClientDetails.age = widget.clientDetails.age;
    testClientDetails.phone = widget.clientDetails.phone;
    testClientDetails.createdOn = widget.clientDetails.createdOn;
    testClientDetails.numberOfOrders = widget.clientDetails.numberOfOrders;
    testClientDetails.rate = widget.clientDetails.rate;
    testClientDetails.discount = widget.clientDetails.discount;
    testClientDetails.consumption = widget.clientDetails.consumption;
    testClientDetails.government = widget.clientDetails.government;
    testClientDetails.area = widget.clientDetails.area;
    testClientDetails.city = widget.clientDetails.city;
    testClientDetails.officerId = widget.clientDetails.officerId;
  }

  void checkChanges(context) {
    if (widget.clientDetails.name != testClientDetails.name ||
        widget.clientDetails.phone != testClientDetails.phone ||
        widget.clientDetails.age != testClientDetails.age ||
        widget.clientDetails.email != testClientDetails.email ||
        widget.clientDetails.area != testClientDetails.area ||
        widget.clientDetails.officerId != testClientDetails.officerId ||
        widget.clientDetails.city != testClientDetails.city ||
        widget.clientDetails.government != testClientDetails.government ||
        widget.clientDetails.consumption != testClientDetails.consumption ||
        widget.clientDetails.discount != testClientDetails.discount ||
        widget.clientDetails.rate != testClientDetails.rate ||
        widget.clientDetails.numberOfOrders !=
            testClientDetails.numberOfOrders) {
      Provider.of<ClientDetailsProvider>(context, listen: false)
          .changeIsChangedToTrue();
    } else {
      Provider.of<ClientDetailsProvider>(context, listen: false)
          .changeIsChangedToFalse();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ClientDetailsProvider>(context, listen: false)
          .fillClientFields(widget.clientDetails);
    });
    fillTestModel();
    super.initState();
  }

  void clearClientList({@required BuildContext context}) {
    Provider.of<ClientDetailsProvider>(context, listen: false)
        .clearClientList();
  }

  @override
  Widget build(BuildContext context) {
    var tProvider = Provider.of<ClientDetailsProvider>(context);
    var fProvider = Provider.of<ClientDetailsProvider>(context, listen: false);

    return Scaffold(
      appBar: mainBar("Client Details", context, isClear: true,disPose: (){}),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Form(
                key: formKey,
                child: LayoutBuilder(
                  builder: (context, constrains) => Container(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
                        readOnly: true,
                        controller: tProvider.idEditController,
                      ),
                      BuildTextFormField(
                        label: "Name",
                        controller: tProvider.nameEditController,
                        labelValidate: "Enter name",
                        onChanged: (val) {
                          widget.clientDetails.name = val;
                          print("name is ${widget.clientDetails.name}");
                        },
                      ),
                      BuildTextFormField(
                        label: "Email",

                        controller: tProvider.emailController,
                        onChanged: (val) {
                          widget.clientDetails.email = val;
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
                        labelValidate: "Enter age",
                        controller: tProvider.ageEditController,
                        onChanged: (val) {
                          widget.clientDetails.age = val;
                        },
                      ),
                      BuildTextFormField(
                        label: "Date of joining",
                        readOnly: true,
                        controller: tProvider.createdOnController,
                      ),
                      Container(
                        height: 110,
                        child: Row(
                          children: [
                            Expanded(
                              child: BuildTextFormField(
                                controller: tProvider.phoneEditController,
                                label: "Phone",
                                type: TextInputType.number,
                                hint: "Enter phone number",
                                labelValidate: "Enter phone number",
                                isValidate: true,
                                validator: (String val) {
                                  if (widget.clientDetails.phone.length != 0) {
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
                                        if (!fProvider.phoneEditController.text
                                                .contains(RegExp("[a-z]")) &&
                                            !fProvider.phoneEditController.text
                                                .contains(RegExp("[A-Z]")) &&
                                            !fProvider.phoneEditController.text
                                                .contains(RegExp("[ا-ي]")) &&
                                            fProvider.phoneEditController.text
                                                    .length ==
                                                11&&!fProvider.phoneEditController.text.contains(RegExp("[٠-٩]"))&&!fProvider.phoneEditController.text.contains(RegExp("[۰-۹]"))) {
                                          setState(() {
                                            widget.clientDetails.phone.add(
                                                fProvider
                                                    .phoneEditController.text);
                                            fProvider.phoneEditController.text =
                                                '';
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
                      widget.clientDetails.phone.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount:
                                          widget.clientDetails.phone.length,
                                      itemBuilder: (context, index) => Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                children: [
                                                  Text(widget.clientDetails
                                                      .phone[index]),
                                                  Expanded(
                                                    child: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            widget.clientDetails
                                                                .phone
                                                                .removeAt(
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
                      BuildTextFormField(
                        label: "Discount",
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        isValidate: true,
                        type: TextInputType.number,
                        labelValidate: "Enter discount",
                        controller: tProvider.discountController,
                        onChanged: (val) {
                          widget.clientDetails.discount = double.parse(val);
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
                        controller: tProvider.consumptionController,
                        onChanged: (val) {
                          widget.clientDetails.consumption = double.parse(val);
                        },
                      ),
                      BuildTextFormField(
                        label: "Rate",
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        isValidate: true,
                        type: TextInputType.number,
                        controller: tProvider.rateController,
                        onChanged: (val) {
                          widget.clientDetails.rate = double.parse(val);
                        },
                      ),
                      BuildTextFormField(
                        label: "Number Of Orders",
                        type: TextInputType.number,
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        isValidate: true,
                        controller: tProvider.numberOfOrdersController,
                        onChanged: (val) {
                          widget.clientDetails.numberOfOrders = int.parse(val);
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
                        label: "Government",
                        labelValidate: "Enter government",
                        controller: tProvider.governmentEditController,
                        onChanged: (val) {
                          widget.clientDetails.government = val;
                        },
                      ),
                      BuildTextFormField(
                        label: "Area",
                        labelValidate: "Enter area",
                        controller: tProvider.areaController,
                        onChanged: (val) {
                          widget.clientDetails.area = val;
                        },
                      ),
                      BuildTextFormField(
                        label: "City",
                        labelValidate: "Enter city",
                        controller: tProvider.cityController,
                        onChanged: (val) {
                          widget.clientDetails.city = val;
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
                        label: "Officer ID",
                        labelValidate: "Enter officer id",
                        type: TextInputType.number,
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        isValidate: true,
                        controller: tProvider.officerIdController,
                        onChanged: (val) {
                          widget.clientDetails.officerId = val;
                        },
                      ),
                      SizedBox(height: 15.0),
                      isGet
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
                                        context, 'Update'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  onPressed: () {
                                   if(whoIs==4){

                                   }else{
                                     if (widget.clientDetails.phone.length !=
                                         0) {
                                       if (formKey.currentState.validate()) {
                                         setState(() {
                                           isGet = false;
                                         });
                                         ClientService()
                                             .update(
                                             widget.clientDetails,
                                             widget.clientDetails.id,
                                             context)
                                             .then((value) {
                                           BuildSnackBar(
                                               title:
                                               "Client updated successfully",
                                               context: context,
                                               color: Colors.greenAccent);
                                           setState(() {
                                             isGet = true;
                                           });
                                           fillTestModel();
                                         }).catchError((onError) {
                                           BuildSnackBar(
                                               title: "Something went wrong",
                                               context: context,
                                               color: Colors.red);
                                         });
                                       }
                                     } else {
                                       BuildSnackBar(
                                           title: "Please enter phone number",
                                           context: context,
                                           color: Colors.amber);
                                     }
                                   }
                                  }),
                            )
                          : Center(
                              child: SpinKitCircle(
                                color: Theme.of(context).primaryColor,
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
                              LocalizationConst.translate(context, "Delete"),
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                             if(whoIs==4){

                             }else{
                               showDialog(
                                   context: context,
                                   builder: (context) => new DeleteConfirmation(
                                       id: widget.clientDetails.id));
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
    );
  }
}

class DeleteConfirmation extends StatefulWidget {
  final String id;

  const DeleteConfirmation({this.id});

  @override
  State createState() => new DeleteConfirmationState();
}

class DeleteConfirmationState extends State<DeleteConfirmation> {
  ClientService clientService = new ClientService();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocalizationConst.translate(context, "Delete Client"),
        style: TextStyle(color: Color(0xFF8F5F43)),
      ),
      backgroundColor: Color(0xFFEAEAEA),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              LocalizationConst.translate(
                  context, "Would you like to remove this client?"),
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
            clientService.deleteClient(widget.id).then((value) {
              BuildSnackBar(
                  color: Colors.greenAccent,
                  context: context,
                  title: "Client deleted successfully");
              Navigator.pop(context);
              Provider.of<ClientDetailsProvider>(context, listen: false)
                  .clearControllers();
              Provider.of<ClientDetailsProvider>(context, listen: false)
                  .getClients();
            }).catchError((onError) {
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

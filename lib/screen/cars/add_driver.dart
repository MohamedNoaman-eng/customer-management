import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/auth.dart';
import 'package:zain/database_services/driver_services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/driver.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/provider/carsProvider.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/button.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class AddDriverScreen extends StatefulWidget {
  @override
  _AddDriverScreenState createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {
  var key = GlobalKey<FormState>();
  bool isAdded = true;
  OrderModel orderModel = new OrderModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CarsProvider>(context, listen: false).getAllOrders();
    });
    super.initState();
  }

  List<OrderModel> driverOrders = [];
  bool driverAdded = false;
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<CarsProvider>(context, listen: false);
    var tProvider = Provider.of<CarsProvider>(context);
    return tProvider.isGet
        ? Scaffold(
            appBar: mainBar("Add Driver", context,disPose: (){
              fProvider.clearControllers();
            }),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          color: Color.fromRGBO(255, 0, 0, 1),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 20.0, top: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 8.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  LocalizationConst.translate(
                                      context, "Driver Details"),
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.driverIdController,
                          readOnly: true,
                          label: "Driver ID",
                          labelValidate:
                              "Please refresh the page to upload driver Id",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.driverNameController,
                          label: "Driver Name",
                          hint: "Enter driver name",
                          labelValidate: "Enter driver name",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.emailController,
                          label: "Email",
                          hint: "Enter email",
                          labelValidate: "Enter email",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.passwordController,
                          label: "Password",
                          hint: "Enter password",
                          labelValidate: "Enter password",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.driverPhoneController,
                          label: "Driver Phone",
                          validator: (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                          isValidate: true,
                          type: TextInputType.number,
                          hint: "Enter driver phone",
                          labelValidate: "Enter driver phone",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.carIdController,
                          label: "Car ID",
                          validator: (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                          isValidate: true,
                          hint: "Enter car id",
                          labelValidate: "Enter car id",
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: tProvider.carCounterController,
                          label: "Car Counter",
                          isValidate: true,
                          validator: (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                          type: TextInputType.number,
                          hint: "Enter car counter",
                          labelValidate: "Enter car counter",
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
                            LocalizationConst.translate(context, "Order"),
                          ),
                        ),
                        tProvider.orders.isNotEmpty
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<OrderModel>(
                                      hint: Text(LocalizationConst.translate(
                                          context, "Orders")),
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                      iconSize: 28,
                                      elevation: 16,
                                      onChanged: (OrderModel value) {
                                        orderModel = value;
                                      },
                                      items: tProvider.orders
                                          .map<DropdownMenuItem<OrderModel>>(
                                              (OrderModel value) {
                                        return DropdownMenuItem<OrderModel>(
                                          value: value,
                                          child: Text("${value.totalPrice}"),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          driverOrders.add(orderModel);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 30,
                                        color: Colors.blue,
                                      )),
                                ],
                              )
                            : Text("Sorry there are no orders!"),
                        SizedBox(
                          height: 15.0,
                        ),
                        driverOrders.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Orders"),
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
                                        itemCount: driverOrders.length,
                                        itemBuilder: (context, index) => Row(
                                          children: [
                                            Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  children: [
                                                    Text(driverOrders[index]
                                                        .totalPrice),
                                                    Expanded(
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              driverOrders
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
                        isAdded?BuildButton(
                          title: "Add",
                          onPressed: () {
                            if (key.currentState.validate()) {
                             if(driverAdded){
                               BuildSnackBar(
                                 title: "This driver is already added",
                                 color: Colors.amber,
                                 context: context
                               );
                             }else{
                               setState(() {
                                 isAdded = false;
                               });
                               List<String> ids = [];
                               driverOrders.forEach((element) {
                                 ids.add(element.id);
                               });
                               AuthService()
                                   .registerWithEmailAndPassword(
                                   fProvider.emailController.text,
                                   fProvider.passwordController.text)
                                   .then((value) {
                                 DriverService()
                                     .add(
                                     DriverModel(
                                         driverId: fProvider
                                             .driverIdController.text,
                                         driverName: fProvider
                                             .driverNameController.text,
                                         driverPhone: fProvider
                                             .driverPhoneController.text,
                                         carId:
                                         fProvider.carIdController.text,
                                         carCounter: fProvider
                                             .carCounterController.text,
                                         orders: ids),
                                     value)
                                     .then((value) {
                                   setState(() {
                                     isAdded = true;
                                     driverAdded = true;
                                   });
                                   BuildSnackBar(
                                       title: "Driver Added Successfully",
                                       color: Colors.greenAccent,
                                       context: context);
                                   fProvider.clearControllers();
                                   fProvider.getDriverId();
                                 }).catchError((onError) {
                                   setState(() {
                                     isAdded = true;
                                   });
                                   BuildSnackBar(
                                       title: "Something went wrong",
                                       color: Colors.red,
                                       context: context);
                                 });
                               }).catchError((onError) {});
                             }
                            }
                          },
                        ):SpinKitCircle(
                          color: Theme.of(context).primaryColor,
                          duration: Duration(milliseconds: 300),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Loading();
  }
}

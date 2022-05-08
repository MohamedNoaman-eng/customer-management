import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/clientDetails.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/models/productModel.dart';
import 'package:zain/provider/orderProvider.dart';
import 'package:zain/provider/providerState.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/button.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';


class OrderDetails extends StatefulWidget {
  OrderDetails({this.order});
  OrderModel order;
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isGetOrder = true;
  ClientDetails clientDetailsOrder = new ClientDetails();
  ProductModel productModelOrder = new ProductModel();
  CategoryModel categoryModelOrder = new CategoryModel();
  var priceController = TextEditingController();
  var countController = TextEditingController();
  List<ProductModel> products =[];
  List<CategoryModel> categories = [];
  List<ClientDetails> clients =[];
  void getClient(){
    setState(() {
      isGetOrder = false;
    });
    ClientService().getAllClients().then((value) {
      print("client get true");
      clients = value;
      getProduct();
    }).catchError((onError){
      print("error while getting client is $onError");
    });
  }
  void getProduct(){
    ProductsService().read().then((value) {
      products = value;
      print("get product true");
      priceController.text = widget.order.totalPrice;

      getCategory();
    }).catchError((onError){
      print("error while getting product is $onError");
    });
  }
  OfficerModel officerModel = new OfficerModel();
  LeaderModel  leaderModel  =new LeaderModel();
  void getOfficer(){
  if(whoIs==2){
    OfficerService().getById(userDetailId).then((value){
      if(value!=null){
        officerModel = value;
        if(officerModel.leaderId.length!=0){
          LeaderService().getById(officerModel.leaderId).then((value){
            if(value!=null){
              leaderModel = value;
            }else{
              leaderModel = new LeaderModel();
            }
          }).catchError((onError){

          });
        }
      }
    }).catchError((onError){

    });
  }else if(whoIs==5){
    LeaderService().getById(userDetailId).then((value){
      if(value!=null){
        leaderModel = value;
      }else{
        leaderModel = new LeaderModel();
      }
    }).catchError((onError){

    });
  }
  }
  void calcProfitClient(context) {

      clientDetails.consumption =
          clientDetails.consumption + double.parse(paidNow.text);
      ClientService()
          .update(clientDetails, clientDetails.id, context)
          .then((value) {})
          .catchError((onError) {
        print("error on update client profit $onError");
      });

  }

  void calcProfitOfficer(String orderId, context) {

      double reward = officerModel.orderReward / 100;
      double netProfit = reward * double.parse(paidNow.text);
      officerModel.profit = officerModel.profit + netProfit;
      officerModel.totlaConsumpation = officerModel.totlaConsumpation +double.parse(paidNow.text);
      OfficerService()
          .update(officerModel, officerModel.id, context)
          .then((value) {})
          .catchError((onError) {
        print("error on update officer profit");
      });

  }

  void calcProfitLeader(String orderId, context) {
    print(leaderModel.leaderName);
      double reward = double.parse(leaderModel.orderReward) / 100;
      double netProfit = reward * double.parse(paidNow.text);
      leaderModel.profit = leaderModel.profit + netProfit;
      leaderModel.totlaConsumpation = leaderModel.totlaConsumpation +double.parse(paidNow.text);
      LeaderService()
          .update(leaderModel, leaderModel.id, context)
          .then((value) {
        BuildSnackBar(
            color: Colors.greenAccent,
            context: context,
            title: "Order Added Successfully");
      }).catchError((onError) {
        print("error on update leader profit $onError");
      });

  }
  void getCategory(){
    CategoryService().read().then((value) {
      categories = value;
      print("get category true");
      setState(() {
        isGetOrder = true;
      });
    }).catchError((onError){
      print("error while getting category is $onError");
    });
  }
  bool isUpdated = true;
  ClientDetails clientDetails = new ClientDetails();
  @override
  void initState() {
    getClient();
    if(whoIs!=1){
      getOfficer();
    }
    super.initState();
  }

  var paidPrice = TextEditingController();
  var paidNow = TextEditingController();
  var key = GlobalKey<FormState>();
  String id;
  void updateClient(id){

    ClientService().getById(id).then((value){
      value.numberOfOrders-=1;
      value.consumption = value.consumption - double.parse(widget.order.totalPrice);
      ClientService().update(value, value.id, context).then((value){
print("updated");
      }).catchError((onError){

      });
    }).catchError((onError){

    });
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<OrderProvider>(context,listen: false);
    var tProvider = Provider.of<OrderProvider>(context);
    return isGetOrder? Scaffold(
      appBar: mainBar("Order Details", context,disPose: (){

        paidNow.text  ='';
      }),
      body: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              children: [
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: Column(
                   children: [
                     Container(
                       alignment:
                       LocalizationConst.getCurrentLang(context) == 1
                           ? Alignment.topLeft
                           : Alignment.topRight,
                       child: Text(
                         LocalizationConst.translate(context, "Client ID"),
                         style: TextStyle(color: Color(0xff8F5F43)),
                       ),
                     ),
                     Container(
                       child: DropdownButtonFormField<ClientDetails>(
                         icon:
                         const Icon(Icons.keyboard_arrow_down_rounded),
                         iconSize: 28,
                         value: clients.singleWhere((element) => element.id==widget.order.orderClientId),
                         elevation: 16,
                         validator: (val) {
                           if (val == null) {
                             return "Select client code";
                           }
                           return null;
                         },
                         onChanged: (ClientDetails value) {
                           id = widget.order.orderClientId;
                           widget.order.orderClientId = value.id;

                         },
                         items: clients
                             .map<DropdownMenuItem<ClientDetails>>(
                                 (ClientDetails value) {
                               return DropdownMenuItem<ClientDetails>(
                                 value: value,
                                 child: Text("${value.name}"),
                               );
                             }).toList(),
                       ),
                     ),
                   ],
                 ),
               ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.order.orderList.length,
                        itemBuilder: (context,index){
                          countController.text = widget.order.orderList[index]['count'].toString();
                          paidPrice.text = widget.order.paidPrice;
                          clientDetails = clients.singleWhere((element) => element.id==widget.order.orderClientId);
                          return Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 40.0,
                                color: Color.fromRGBO(255, 0, 0, 1),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10.0,
                                        backgroundColor: Colors.white,
                                      ),
                                      SizedBox(width: 10.0,),
                                      Text("المنتج ${index+1}",style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocalizationConst.translate(context, "Description"),
                                    style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Column(
                                children: [
                                  Container(
                                    alignment:
                                    LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, "Product Name"),
                                    ),
                                  ),
                                  Container(
                                    child: DropdownButtonFormField<ProductModel>(
                                      icon:
                                      const Icon(Icons.keyboard_arrow_down_rounded),
                                      iconSize: 28,
                                      value: products.singleWhere((element) => element.id==widget.order.orderList[index]['productId']),
                                      elevation: 16,
                                      validator: (val) {
                                        if (val == null) {
                                          return "Select product name";
                                        }
                                        return null;
                                      },
                                      onChanged: (ProductModel value) {
                                        widget.order.orderList[index].orderProductId = value.id;
                                      },
                                      items: products
                                          .map<DropdownMenuItem<ProductModel>>(
                                              (ProductModel value) {
                                            return DropdownMenuItem<ProductModel>(
                                              value: value,
                                              child: Text("${value.name}"),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Column(
                                children: [
                                  Container(
                                    alignment:
                                    LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, "Category Name Order"),
                                    ),
                                  ),
                                  categories.isNotEmpty?Container(
                                      child: DropdownButtonFormField<CategoryModel>(
                                        icon:
                                        const Icon(Icons.keyboard_arrow_down_rounded),
                                        iconSize: 28,
                                        value: categories.singleWhere((element) => element.id==widget.order.orderList[index]['categoryId'],orElse: ()=>null),
                                        elevation: 16,
                                        validator: (val) {
                                          if (val == null) {
                                            return "Select category";
                                          }
                                          return null;
                                        },
                                        onChanged: (CategoryModel value) {
                                          widget.order.orderList[index].orderCategoryId = value.id;
                                        },
                                        items: categories
                                            .map<DropdownMenuItem<CategoryModel>>(
                                                (CategoryModel value) {
                                              return DropdownMenuItem<CategoryModel>(
                                                value: value,
                                                child: Text("${value.name}"),
                                              );
                                            }).toList(),
                                      ),
                                    ):SizedBox(),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              Column(
                                children: [
                                  Container(
                                    alignment:
                                    LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Row(
                                      children: [
                                        Text(
                                          LocalizationConst.translate(context, "Status"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: DropdownButtonFormField<String>(
                                      icon:
                                      const Icon(Icons.keyboard_arrow_down_rounded),
                                      iconSize: 28,
                                      value: widget.order.orderList[index]['status'],
                                      elevation: 16,
                                      validator: (val) {
                                        if (val.isEmpty) {
                                          return "Select status";
                                        }
                                        return null;
                                      },
                                      onChanged: (String value) {
                                        widget.order.orderList[index].status = value;
                                      },
                                      items: Provider.of<OrderProvider>(context).statusOrder
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text("$value"),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0,),
                              BuildTextFormField(
                                controller: countController,
                                type: TextInputType.number,
                                isValidate: true,
                                onChanged: (value){
                                  widget.order.orderList[index]['count'] = value;
                                },
                                validator: (String val){
                                  if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                    return LocalizationConst.translate(context, "Please enter english number");
                                  }else{
                                    return null;
                                  }
                                },
                                label: "Product Counts",
                              ),
                              SizedBox(height: 10.0,),
                              BuildTextFormField(
                                controller: paidPrice,
                                type: TextInputType.number,
                                isValidate: true,
                                onChanged: (value){
                                  widget.order.paidPrice = value;
                                },
                                validator: (String val){
                                  if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                    return LocalizationConst.translate(context, "Please enter english number");
                                  }else{
                                    return null;
                                  }
                                },
                                label: "Paid Price Previously",
                              ),
                              SizedBox(height: 10.0,),
                              if(widget.order.isPremium==true)
                                BuildTextFormField(
                                  controller: paidNow,
                                  type: TextInputType.number,
                                  isValidate: true,
                                  validator: (String val){
                                    if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                      return null;
                                    }else{
                                      if(double.parse(val)>double.parse(widget.order.totalPrice)){
                                        return LocalizationConst.translate(context, "Please enter english number");
                                      }else{
                                        return null;
                                      }
                                    }
                                  },
                                  hint: "Is there a current payment?",
                                  label: "Paid Now",

                                ),
                            ],
                          );
                        }
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: BuildTextFormField(
                    controller: priceController,
                    isValidate: true,
                    type: TextInputType.number,
                    validator:  (String val){
                      if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                        return LocalizationConst.translate(context, "Please enter english number");
                      }else{
                        return null;
                      }
                    },
                    label: "Total Price",
                    onChanged: (va){
                      widget.order.totalPrice = va;
                    },
                  ),
                ),
                SizedBox(height: 15.0,),
                Container(
                  child: BuildButton(title: "Update",onPressed: (){
                 if(whoIs==4){
                 }else{
                   if(key.currentState.validate()){
                     if(widget.order.orderClientId!=id){
                       updateClient(id);
                     }
                    if(paidNow.text.length!=0){
                        print("in if");
                  widget.order.paidPrice = (double.parse(widget.order.paidPrice)  + double.parse(paidNow.text)).toString();
                    if(widget.order.paidPrice==widget.order.totalPrice){
                      widget.order.isPremium = false;
                    }else if(widget.order.paidPrice !=widget.order.totalPrice){
                      widget.order.isPremium = true;
                    }
                    OrderService().updateOrder(widget.order, widget.order.id).then((value){
                      BuildSnackBar(
                          context: context,
                          title: "Order Updated Successfully",
                          color: Colors.greenAccent
                      );
                      print(whoIs);
                      if(whoIs==2) {
                        print("in if 2");
                        calcProfitClient(context);
                        calcProfitOfficer(widget.order.id, context);
                        calcProfitLeader(widget.order.id, context);

                      }else if(whoIs==5){
                        print("in else 2");
                        calcProfitClient(context);
                        calcProfitLeader(widget.order.id, context);


                      }
                    }).catchError((onError){
                      BuildSnackBar(
                          context: context,
                          title: "Something went wrong",
                          color: Colors.red
                      );
                      print(onError);
                    });

                }else{
                  print("in else");
                    if(widget.order.paidPrice==widget.order.totalPrice){
                    widget.order.isPremium = false;
                  }else if(widget.order.paidPrice !=widget.order.totalPrice){
                    widget.order.isPremium = true;
                  }
                  OrderService().updateOrder(widget.order, widget.order.id).then((value){
                    BuildSnackBar(
                        context: context,
                        title: "Order Updated Successfully",
                        color: Colors.greenAccent
                    );
                    // if(whoIs==2&&paidNow.text.length!=0) {
                    //   calcProfitClient(context);
                    //   calcProfitOfficer(widget.order.id, context);
                    //   calcProfitLeader(widget.order.id, context);
                    //
                    // }else if(whoIs==5&&paidNow.text.length!=0){
                    //   calcProfitClient(context);
                    //   calcProfitLeader(widget.order.id, context);
                    //
                    // }

                  }).catchError((onError){
                    BuildSnackBar(
                        context: context,
                        title: "Something went wrong",
                        color: Colors.red
                    );
                    print(onError);
                  });
                }
                   }
                 }
                  },)
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: 30,
                    width: 150,
                    child: OutlinedButton(
                      child: Text(LocalizationConst.translate(context, "Delete")),
                      onPressed: (){
                       if(whoIs==4){

                       }else{
                         showDialog(
                             context: context,
                             builder: (context) =>
                             new DeleteConfirmation(
                                 id: widget.order.id));
                       }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

    ):Loading();
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
  bool isDeleted = true;
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        LocalizationConst.translate(context, "Delete Order"),
        style: TextStyle(color: Color(0xFF8F5F43)),
      ),
      backgroundColor: Color(0xFFEAEAEA),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              LocalizationConst.translate(context, "Would you like to remove this order?"),
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
            setState(() {
              isDeleted = false;
            });
            Navigator.of(context).pop();
            OrderService().deleteOrder(widget.id).then((value){

              Provider.of<AppProvider>(context,listen: false).getOrders(false);
              BuildSnackBar(
                  context: context,
                  title: "Order Deleted Successfully",
                  color: Colors.greenAccent
              );
              setState(() {
                isDeleted = true;
              });
            }).catchError((onError){
              setState(() {
                isDeleted = true;
              });
              BuildSnackBar(
                  context: context,
                  title: "Something went wrong",
                  color: Colors.red
              );
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

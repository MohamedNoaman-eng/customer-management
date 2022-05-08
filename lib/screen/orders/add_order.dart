import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/models/productModel.dart';
import 'package:zain/provider/orderProvider.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  var formKey = GlobalKey<FormState>();

  bool isAdded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var clientController = TextEditingController();
  Map<String,dynamic> orderMap;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrderProvider>(context, listen: false)
          .getAllClients();
    });
    super.initState();
  }

  List<dynamic> orderList =[];
  String productName;
  String categoryName;
  String status;
  bool isPremium = false;

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<OrderProvider>(context, listen: false);
    var tProvider = Provider.of<OrderProvider>(context);
    return tProvider.isGetData? Scaffold(
      key: _scaffoldKey,
      appBar: mainBar("Add Order", context, disPose: () {
        Provider.of<OrderProvider>(context,listen: false).clearDate();
        productName = '';
        categoryName = '';
        status = '';
        Provider.of<OrderProvider>(context,listen: false).orderModel = new OrderModel();
        Provider.of<OrderProvider>(context,listen: false).filterProducts = [];
        Provider.of<OrderProvider>(context,listen: false).categoryList = [];
        Provider.of<OrderProvider>(context,listen: false).productList = [];
        Provider.of<OrderProvider>(context,listen: false).productPrice = '';
        Provider.of<OrderProvider>(context,listen: false).clientList = [];
        Provider.of<OrderProvider>(context,listen: false).clientsIds = [];
        Provider.of<OrderProvider>(context,listen: false).orderCount =1;
      },isClear: true),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                  child: SimpleAutoCompleteTextField(
                    key: key,
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      hintText: LocalizationConst.translate(
                          context, "Search for client"),
                      suffixIcon: new Icon(Icons.search),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    controller: TextEditingController(text: ""),
                    suggestions: tProvider.clientsIds,

                    textChanged: (text) {
                      if(fProvider.clientList.isNotEmpty){
                        fProvider.filterClients(text,context);
                      }

                    },
                    clearOnSubmit: false,
                    onFocusChanged: (value) {
                      return null;
                    },
                    textSubmitted: (text) {
                      setState(() {
                        fProvider.filterClients(text,context);
                      });
                    },
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(
                  alignment: LocalizationConst.getCurrentLang(context) == 1
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    LocalizationConst.translate(context, "Category"),
                  ),
                ),
                tProvider.categoryList != null
                    ? DropdownButtonFormField<CategoryModel>(
                        hint: Text(
                            LocalizationConst.translate(context, 'Category')),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 28,
                        elevation: 16,
                        validator: (val) {
                          if (val == null) {
                            return "Select category";
                          }
                          return null;
                        },
                        onChanged: (CategoryModel value) {
                          fProvider.fillOrderModel(categoryId: value.id);
                          fProvider.filterProductsByCategory(value.id);
                          categoryName = value.name;
                        },
                        items: tProvider.categoryList
                            .map<DropdownMenuItem<CategoryModel>>(
                                (CategoryModel value) {
                          return DropdownMenuItem<CategoryModel>(
                            value: value,
                            child: Text("${value.name}"),
                          );
                        }).toList(),
                      )
                    : Text(LocalizationConst.translate(context, "Sorry there are no categories!")),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  alignment: LocalizationConst.getCurrentLang(context) == 1
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    LocalizationConst.translate(context, "Product"),
                  ),
                ),
                tProvider.filterProducts.length!=0
                    ? DropdownButtonFormField<ProductModel>(
                        hint:
                            Text(LocalizationConst.translate(context, 'Product')),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 28,
                        elevation: 16,
                        validator: (val) {
                          if (val == null) {
                            return "Select Product";
                          }
                          return null;
                        },
                        onChanged: (ProductModel value) {
                          fProvider.fillOrderModel(productId: value.id);
                          fProvider.fillOrderPrice(value.price,tProvider.orderCount);
                          productName = value.name;
                        },
                        items: tProvider.filterProducts
                            .map<DropdownMenuItem<ProductModel>>(
                                (ProductModel value) {
                          return DropdownMenuItem<ProductModel>(
                            value: value,
                            child: Text("${value.name}"),
                          );
                        }).toList(),
                      )
                    : Text(LocalizationConst.translate(context, "Sorry there are no products!")),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  alignment: LocalizationConst.getCurrentLang(context) == 1
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Text(
                    LocalizationConst.translate(context, "Status"),
                  ),
                ),
                DropdownButtonFormField<String>(
                  hint: Text(LocalizationConst.translate(context, 'Status')),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 28,
                  elevation: 16,
                  validator: (val) {
                    if (val == null) {
                      return "Select Status";
                    }
                    return null;
                  },
                  onChanged: (String value) {
                    fProvider.fillOrderModel(status: value);
                  },
                  items: tProvider.statusOrder
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text("$value"),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.7,
                      child: BuildTextFormField(
                        type: TextInputType.number,
                        label: "Paid Price",
                        isValidate:  !isPremium,
                        validator: (String val){
                          if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                            return LocalizationConst.translate(context, "Please enter english number");
                          }else{
                            return null;
                          }
                        },
                        labelValidate: "Enter paid price",
                        hint: "Enter paid price",
                        readOnly: !isPremium,
                        onChanged: (String val){
                          fProvider.orderModel.paidPrice = val;
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocalizationConst.translate(context, "Paid Premium")),
                        Switch(value: isPremium, onChanged: (val){
                         setState(() {
                           isPremium = val;
                           fProvider.orderModel.isPremium = val;
                         });
                        },
                        activeTrackColor: Colors.green,),
                      ],
                    ),

                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                          ),
                          height: 30,
                          child:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(onPressed: tProvider.filterProducts.isNotEmpty?(){
                                fProvider.incrementOrderCount();
                              }:(){}, icon: Icon(Icons.add,size: 15.0,)),
                              Text("${tProvider.orderCount}"),
                              IconButton(onPressed: tProvider.filterProducts.isNotEmpty?(){
                                fProvider.decrementOrderCount();
                              }:(){}, icon: Icon(Icons.remove,size: 15.0,))
                            ],
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocalizationConst.translate(
                                            context, "Price Of Product"),
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                      Text(
                                        "${tProvider.productPrice} ${LocalizationConst.translate(context, "LE")}",
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: OutlinedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(LocalizationConst.translate(context, "Add To Order List"),style: TextStyle(color: Colors.black),),
                    ),
                    onPressed: (){
                     if(productName!=null&&categoryName!=null&&fProvider.orderModel.status!=null
                     &&fProvider.orderModel.orderProductId!=null&&fProvider.orderModel.orderCategoryId!=null){
                       setState(() {
                         orderList.add({
                           'productName':productName,
                           'categoryName':categoryName,
                           'status':fProvider.orderModel.status,
                           'productId':fProvider.orderModel.orderProductId,
                           'categoryId':fProvider.orderModel.orderCategoryId,
                           'count':fProvider.orderCount,
                           'price':fProvider.productPrice
                         });
                          fProvider.addToAllProductsPrice(double.parse(fProvider.productPrice),fProvider.clientDetailsProfit.discount);
                       });
                     }
                    },
                  ),
                ),
                orderList.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(LocalizationConst.translate(context, "Orders List")),
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
                          itemCount: orderList.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Row(children: [Text(orderList[index]['productName']),
                                        SizedBox(width: 7.0,),
                                        Text(orderList[index]['categoryName']),
                                        SizedBox(width: 7.0,),
                                        Text(orderList[index]['status']),],),
                                      IconButton(
                                          onPressed: () {
                                            fProvider.removeFromAllProductsPrice(orderList[index]['price'],fProvider.clientDetailsProfit.discount);
                                            setState(() {
                                              orderList.removeAt(
                                                  index);
                                            });

                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            size: 15.0,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey
                                        .withOpacity(0.2),
                                    borderRadius:
                                    BorderRadius.circular(5.0)),
                                height: 60,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                    : SizedBox(),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        elevation: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocalizationConst.translate(
                                    context, "Total Price"),
                                style: TextStyle(fontSize: 17.0),
                              ),
                              Text(
                                "${tProvider.allProductsPrice} ${LocalizationConst.translate(context, "LE")}",
                                style: TextStyle(fontSize: 17.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                tProvider.isGet
                    ? ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.7,
                        height: 50.0,
                        child: Column(
                          children: [

                            RaisedButton(
                              color: Color.fromRGBO(255, 0, 0, 1),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    width: 4.0),
                              ),
                              child: Text(
                                LocalizationConst.translate(context, 'Add'),
                                style:
                                    TextStyle(color: Colors.white, fontSize: 17),
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  if(fProvider.filteredClients.length==1){
                                    if(fProvider.categoryList !=null||fProvider.productList!=null){
                                      if(orderList.isNotEmpty ){
                                        fProvider.orderModel.createdBy = userDetailId;
                                        fProvider.orderModel.orderList = orderList;
                                        fProvider.orderModel.orderClientId = fProvider.clientDetailsProfit.id;
                                        fProvider.addOrder(context: context);
                                        setState(() {
                                          orderList = [];
                                        });
                                      }else{
                                        BuildSnackBar(
                                            color: Colors.amber,
                                            context: context,
                                            title: "Please add order item to order list"
                                        );
                                      }
                                    }else{
                                      BuildSnackBar(
                                          color: Colors.amber,
                                          context: context,
                                          title: "Please add category or product, you should to add both"
                                      );
                                    }
                                  }else{
                                    BuildSnackBar(
                                      title: "Please select client",
                                      context: context,
                                      color: Colors.amber
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: SpinKitCircle(
                          color: Colors.deepOrange,
                          size: 50.0,
                          duration: Duration(milliseconds: 300),
                        ),
                      ),
              ]),
            ),
          ),
        ),
      ),
    ):Loading();
  }
}

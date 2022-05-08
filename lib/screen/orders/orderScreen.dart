import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/provider/providerState.dart';
import 'order_details.dart';
import 'package:zain/widgets/appBar.dart';


class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}


class _MyOrderState extends State<MyOrder> {
  Widget buildOrderItem({
    OrderModel orderModel,
    int orderNumber,
    String price="0",
    index,
    BuildContext context,}) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: LayoutBuilder(
        builder:(context,constrains)=> Card(
          elevation: 1.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: Color.fromRGBO(255, 0, 0, 1),child:
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text("#$index",style: TextStyle(color: Colors.white),),
                        ),),
                    ],
                  ),
                ),
                Container(
                  width: constrains.maxWidth *.2,
                  child: Column(

                    children: [
                      Text(LocalizationConst.translate(context, "Product Numbers"),style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w600),),
                      SizedBox(height: 5.0,),
                      Text("$orderNumber",style: TextStyle(fontSize: 10.0),),

                    ],
                  ),
                ),
                Container(
                  width: constrains.maxWidth *.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(LocalizationConst.translate(context, "Status"),style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w600),),
                      SizedBox(height: 5.0,),
                      Text("${orderModel.status}",style: TextStyle(fontSize: 10.0,color: Colors.orange),),
                      Text("${DateFormat.yMd('ar').format(orderModel.createdAt)}"),

                    ],
                  ),
                ),
                Container(
                  width: constrains.maxWidth *.2,
                  child: Column(
                    children: [
                      Text(LocalizationConst.translate(context, "Total Price"),style: TextStyle(fontSize: 13.0,fontWeight: FontWeight.w600),),
                      SizedBox(height: 5.0,),
                      Text("$price ${LocalizationConst.translate(context, "LE")}",style: TextStyle(fontSize: 10.0),),
                    ],
                  ),
                ),
                Container(
                  width: constrains.maxWidth *.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetails(order: orderModel,)));
                      }, child: Text(LocalizationConst.translate(context, "View Details"))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context,listen: false).getOrders(false);
    });
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<AppProvider>(context,listen: false);
    var tProvider = Provider.of<AppProvider>(context);
    return tProvider.isGet? Scaffold(
      appBar: mainBar("Orders", context,disPose: (){
        Provider.of<AppProvider>(context,listen: false).clearData();
      }),
      body:Container(
            width: double.infinity,
            height: double.infinity,
            child:Column(
              children: [
                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: TextButton(onPressed: (){
                            setState(() {
                              fProvider.changIsCash();
                              fProvider.filterOrders();
                            });

                          }
                          , child: Text(LocalizationConst.translate(context, "Cash")
                              ,style: TextStyle(color: tProvider.isCsh?Colors.blue:Colors.grey,fontSize: 15.0),),
                          ),
                          width: MediaQuery.of(context).size.width *0.4,
                        ),
                        Container(
                          width: 0.5,
                          height: 20,
                          color: Colors.black,
                        ),
                        Container(
                          child: TextButton(onPressed: (){
                            setState(() {
                              fProvider.changIsCash();
                              fProvider.filterOrders();
                            });
                          }, child: Text(LocalizationConst.translate(context, "Premium"),
                            style: TextStyle(color: tProvider.isCsh?Colors.grey:Colors.blue,fontSize: 15.0),),
                          ),
                          width: MediaQuery.of(context).size.width *0.4,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.0,),
                tProvider.searchOrders !=null?Container(
                  width: double.infinity,
                      height: MediaQuery.of(context).size.height*0.8,
                      child: ListView.builder(
                  itemBuilder: (context,index)=>buildOrderItem(
                      context: context,
                      orderNumber: tProvider.searchOrders[index].orderList.length,
                      index: index+1,
                      price: tProvider.searchOrders[index].totalPrice,
                      orderModel: tProvider.searchOrders[index],

                  ),
                  itemCount: tProvider.searchOrders.length,
                ),
                    ):Center(child: Text(LocalizationConst.translate(context, "No Orders")),)
              ],
            )
          )
    ):SpinKitCircle(duration: Duration(milliseconds: 300),color:Color.fromRGBO(255, 0, 0, 1),);
  }
}

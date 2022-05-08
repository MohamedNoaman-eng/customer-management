import 'package:flutter/material.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/client.service.dart';
import 'package:zain/database_services/leader_services.dart';
import 'package:zain/database_services/officer_services.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/clientDetails.dart';
import 'package:zain/models/leader.dart';
import 'package:zain/models/officer.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/models/productModel.dart';
import 'package:zain/widgets/snackbar.dart';

class OrderProvider extends ChangeNotifier {
  List<ClientDetails> clientList = [];
  List<String> clientsIds = [];
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  OrderModel orderModel = new OrderModel(
    createdBy: '',
    orderCategoryId: '',
    orderProductId: '',
    status: '',
    orderClientId: '',
    totalPrice: '',
    createdAt: DateTime.now(),
  );
  OrderService orderService = new OrderService();
  String productPrice = '';
  List<String> categoryKind = [];
  int oldPrice;

  void fillOrderPrice(String price, int count) {
    oldPrice = int.parse(price);
    productPrice = (count * int.parse(price)).toString();
    notifyListeners();
  }

  List<OrderModel> orderList = [];
  bool getOrders = true;

  Future getAllOrders() async {
    try {
      getOrders = false;
      notifyListeners();
      orderList = await OrderService().read();
      getOrders = true;
      notifyListeners();
    } catch (e) {
      getOrders = true;
      notifyListeners();
      print("error on getting allOrders is $e");
    }
  }

  bool isGet = true;
  List<String> clientIdsOrder = [];

  void getClientIds() {
    ClientService().getAllClients().then((value) {
      value.forEach((element) {
        clientIdsOrder.add(element.clientId);
      });
      notifyListeners();
      getProductsIds();
    }).catchError((onError) {});
  }

  List<String> productsIdsOrder = [];
  List<ProductModel> productsOrdr = [];

  void getProductsIds() {
    ProductsService().read().then((value) {
      productsOrdr = value;
      value.forEach((element) {
        productsIdsOrder.add(element.name);
      });
      // getCategoriesIds();
      notifyListeners();
    }).catchError((onError) {
      print("error on getting all products ids");
    });
  }

  List<String> categoryIdsOrder = [];
  List<CategoryModel> categoriesOrdr = [];

  // void getCategoriesIds(){
  //   CategoryService().read().then((value) {
  //     categoriesOrdr = value;
  //     value.forEach((element) {
  //       categoryIdsOrder.add(element.name);
  //     });
  //       isGetOrder = true;
  //       notifyListeners();
  //
  //   }).catchError((onError){
  //     print("on getting categories ids");
  //   });
  // }
  double allProductsPrice = 0.0;

  // void clearDataOrder(){
  //   isGetOrder = true;
  //   clientIdsOrder = [];
  //   productsOrdr = [];
  //   productsIdsOrder = [];
  //   categoriesOrdr = [];
  //   categoryIdsOrder = [];
  // }

  List<ClientDetails> filteredClients = [];
  ClientDetails clientDetailsProfit = new ClientDetails();
  OfficerModel officerModelProfit = new OfficerModel();
  LeaderModel leaderModelProfit = new LeaderModel();

  void getLeader(String id) {
    LeaderService().getById(id).then((value) {
      leaderModelProfit = value;
    }).catchError((error) {
      print("error on getting leader profit");
    });
  }

  void calcProfitClient(context) {
   if(orderModel.isPremium){
     clientDetailsProfit.numberOfOrders += 1;
     double netProfit = (clientDetailsProfit.discount / 100) * double.parse(orderModel.paidPrice);
     clientDetailsProfit.consumption =
         clientDetailsProfit.consumption + double.parse(orderModel.paidPrice);
     ClientService()
         .update(clientDetailsProfit, clientDetailsProfit.id, context)
         .then((value) {})
         .catchError((onError) {
       print("error on update client profit");
     });
   }else{
     clientDetailsProfit.numberOfOrders += 1;
     double netProfit = (clientDetailsProfit.discount / 100) * allProductsPrice;
     clientDetailsProfit.consumption =
         clientDetailsProfit.consumption + allProductsPrice;
     ClientService()
         .update(clientDetailsProfit, clientDetailsProfit.id, context)
         .then((value) {})
         .catchError((onError) {
       print("error on update client profit");
     });
   }
  }

  void calcProfitOfficer(String orderId, context) {
    if(orderModel.isPremium){
      double reward = officerModelProfit.orderReward / 100;
      double netProfit = reward * double.parse(orderModel.paidPrice);
      officerModelProfit.profit = officerModelProfit.profit + netProfit;
      officerModelProfit.totlaConsumpation = officerModelProfit.totlaConsumpation+double.parse(orderModel.paidPrice);
      officerModelProfit.orders.add({
        'orderId': orderId,
        'clientId': clientDetailsProfit.id,
      });
      OfficerService()
          .update(officerModelProfit, officerModelProfit.id, context)
          .then((value) {})
          .catchError((onError) {
        print("error on update officer profit");
      });
    }else{
      double reward = officerModelProfit.orderReward / 100;
      double netProfit = reward * allProductsPrice;
      officerModelProfit.profit = officerModelProfit.profit + netProfit;
      officerModelProfit.totlaConsumpation = officerModelProfit.totlaConsumpation+allProductsPrice;
      officerModelProfit.orders.add({
        'orderId': orderId,
        'clientId': clientDetailsProfit.clientId,
      });
      OfficerService()
          .update(officerModelProfit, officerModelProfit.id, context)
          .then((value) {})
          .catchError((onError) {
        print("error on update officer profit");
      });
    }
  }

  void calcProfitLeader(String orderId, context) {
  if(orderModel.isPremium){
    double reward = double.parse(leaderModelProfit.orderReward) / 100;
    double netProfit = reward * double.parse(orderModel.paidPrice);
    leaderModelProfit.profit = leaderModelProfit.profit + netProfit;
   leaderModelProfit.totlaConsumpation = leaderModelProfit.totlaConsumpation+double.parse(orderModel.paidPrice);
    leaderModelProfit.orders
        .add({'orderId': orderId, 'officerId': officerModelProfit.id});
    LeaderService()
        .update(leaderModelProfit, leaderModelProfit.id, context)
        .then((value) {
      allProductsPrice = 0.0;
      notifyListeners();
      BuildSnackBar(
          color: Colors.greenAccent,
          context: context,
          title: "Order Added Successfully");
      changeIsGetToTrue();
    }).catchError((onError) {
      print("error on update leader profit");
    });
  }else{
    double reward = double.parse(leaderModelProfit.orderReward) / 100;
    double netProfit = reward * allProductsPrice;
    leaderModelProfit.profit = leaderModelProfit.profit + netProfit;
    leaderModelProfit.totlaConsumpation = leaderModelProfit.totlaConsumpation+allProductsPrice;
    if(whoIs==2){
      leaderModelProfit.orders
          .add({'orderId': orderId, 'officerId': officerModelProfit.id});
    }else if(whoIs==5){
      leaderModelProfit.orders
          .add({'orderId': orderId, 'leaderId': leaderModelProfit.id});
    }
    LeaderService()
        .update(leaderModelProfit, leaderModelProfit.id, context)
        .then((value) {
      allProductsPrice = 0.0;
      notifyListeners();
      BuildSnackBar(
          color: Colors.greenAccent,
          context: context,
          title: "Order Added Successfully");
      changeIsGetToTrue();
    }).catchError((onError) {
      print("error on update leader profit");
    });
  }
  }

  void removeFromAllProductsPrice(String price,double discount) {
    double dis = (discount/100) * double.parse(price);
    double newPrice =  double.parse(price) - dis;
    allProductsPrice = allProductsPrice - newPrice;
    notifyListeners();
  }

  filterClients(String id, context) {
    filteredClients = [];
    if (id != "") {
      filteredClients =
          clientList.where((element) => element.clientId.contains(id)).toList();
      notifyListeners();
      if (filteredClients.length == 1) {
        clientDetailsProfit = filteredClients[0];
      }
    } else {
      filteredClients = [];
      filteredClients = clientList;
      notifyListeners();
    }
  }

  int orderCount = 1;

  void incrementOrderCount() {
    orderCount += 1;
    productPrice = (oldPrice * orderCount).toString();
    notifyListeners();
  }

  void decrementOrderCount() {
    if (orderCount != 1) {
      orderCount -= 1;
      productPrice = (oldPrice * orderCount).toString();
      notifyListeners();
    }
  }

  void fillOrderModel({
    String categoryId,
    String productId,
    String clientId,
    String status,
    String totalPrice,
  }) {
    if (categoryId != null)
      orderModel.orderCategoryId = categoryId;
    else if (productId != null)
      orderModel.orderProductId = productId;
    else if (clientId != null)
      orderModel.orderClientId = clientId;
    else if (totalPrice != null)
      orderModel.totalPrice = totalPrice;
    else
      orderModel.status = status;
  }

  void changeIsGetToTrue() {
    isGet = true;
    notifyListeners();
  }

  void changeIsGetToFalse() {
    isGet = false;
    notifyListeners();
  }

  List<String> statusOrder = ["Pending", "Approved", "Canceled"];

  void updateProductCount(context) {
    ProductModel productModel = new ProductModel();
    ProductsService().getById(orderModel.orderProductId).then((value) {
      if (value != null) {
        productModel = value;
      }
      if(productModel.count!=0){
        productModel.count = productModel.count - orderCount;
      }
      ProductsService().update(productModel).then((value) {
        allProductsPrice = 0.0;
        notifyListeners();
        BuildSnackBar(
            color: Colors.greenAccent,
            context: context,
            title: "Order Added Successfully");
        changeIsGetToTrue();
      }).catchError((onError) {});
    });
  }

  void addOrder({BuildContext context}) {
    orderModel.totalPrice = allProductsPrice.toString();
    changeIsGetToFalse();
    orderService.add(orderModel).then((value) {
      calcProfitClient(context);
      String orderId = value;
      if (whoIs==2) {
        OfficerService().getById(userDetailId).then((value) {
          officerModelProfit = value;
          calcProfitOfficer(orderId, context);
          if (officerModelProfit.leaderId.length!=0) {
            LeaderService().getById(officerModelProfit.leaderId).then((value) {
              if (value != null) {
                leaderModelProfit = value;
                calcProfitLeader(orderId, context);
              }else{
                allProductsPrice = 0.0;
                notifyListeners();
                BuildSnackBar(
                    color: Colors.greenAccent,
                    context: context,
                    title: "Order Added Successfully");
                changeIsGetToTrue();
              }
              updateProductCount(context);
            });
          } else {
            updateProductCount(context);
          }
        });
      }else if(whoIs==5){
        LeaderService().getById(userDetailId).then((value) {
          if (value != null) {
            leaderModelProfit = value;
            calcProfitLeader(orderId, context);
          }
          updateProductCount(context);
        });
      } else {
        updateProductCount(context);
      }
    }).catchError((onError) {
      BuildSnackBar(
          color: Colors.red, context: context, title: "Something went wrong");
      changeIsGetToTrue();
    });
  }

  void addToAllProductsPrice(double price, double discount) {
    double dis = (discount / 100) * price;
    double newPrice = double.parse((price - dis).toStringAsFixed(3));
    allProductsPrice = allProductsPrice + newPrice;
    notifyListeners();
  }

  void clearDate() {
    officerModelProfit = new OfficerModel();
    clientDetailsProfit = new ClientDetails();
    leaderModelProfit = new LeaderModel();
    allProductsPrice = 0.0;
    isGet = true;
    notifyListeners();
  }

  bool isGetData = true;

  void getAllClients() {
    isGetData = false;
    notifyListeners();
    ClientService().getAllClients().then((value) {
      clientList = value;
      clientList.forEach((element) {
        clientsIds.add(element.clientId);
      });
      notifyListeners();
      getAllProducts();
    }).catchError((onError) {
      print("error on getting all clients $onError");
    });
  }

  void getAllCategories() {
    CategoryService().read().then((value) {
      categoryList = value;
      isGetData = true;
      notifyListeners();
    }).catchError((onError) {
      print("error on getting all categories");
    });
  }

  List<ProductModel> filterProducts = [];

  void filterProductsByCategory(String categoryId) {
    filterProducts = [];
    filterProducts = productList
        .where((element) => element.categoryId == categoryId)
        .toList();
    notifyListeners();
  }

  void getAllProducts() {
    ProductsService().read().then((value) {
      productList = value;
      notifyListeners();
      getAllCategories();
    }).catchError((onError) {
      print("error on getting all products");
    });
  }
}

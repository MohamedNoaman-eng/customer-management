import 'package:flutter/cupertino.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/order_services.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/models/productModel.dart';

class AppProvider extends ChangeNotifier{
  bool donLang = true;
  List<OrderModel> searchOrders = [];
  bool isCsh = true;
  void changIsCash(){
    isCsh = !isCsh;
    notifyListeners();
  }
  void filterOrders(){
    searchOrders = orders.where((element) =>element.isPremium==!isCsh).toList();
    notifyListeners();
  }
  Future changLang() async{

      donLang = false;
      notifyListeners();
    await Future.delayed(Duration(
        seconds: 5));

      donLang = true;
    notifyListeners();
  }
  void clearData(){
    isGet = true;
    products = [];
    productIds = [];
    categories = [];
    categoryIds = [];
    orders = [];
  }
  bool isGet = true;
  List<ProductModel> products=[];
  List<String> productIds =[];
  List<CategoryModel> categories = [];
  List<OrderModel> orders = [];
  List<String> categoryIds = [];
  void getOrders(bool isDrive){
    if(whoIs==1||whoIs==4){
      print("who is =1");
      isGet = false;
      notifyListeners();
      OrderService().read().then((value){
        if(value==null){
          orders = [];
          searchOrders = [];
          notifyListeners();
        }else{
          value.forEach((element) {
            if(element.status!="Approved"||isDrive == false){
              orders.add(element);
            }
          });
          filterOrders();
          notifyListeners();
        }
        getProductByIds();
      }).catchError((onError){
        print(onError);
      });
    }else if(whoIs==2||whoIs==5){
      isGet = false;
      notifyListeners();
      OrderService().read().then((value){
        if(value==null){
          orders = [];
        }else{
         value.forEach((element) {
           if(element.createdBy==userDetailId){
             orders.add(element);
           }

         });
         filterOrders();
          notifyListeners();
        }
        getProductByIds();
      }).catchError((onError){

      });
    }
  }
  void getProductByIds(){
    ProductsService().read().then((value){
      if(value==null){
        products  =[];
      }else{
        products = value;
        notifyListeners();
      }
      getCategoriesByIds();
    }).catchError((onError){
      print("error on getting products by ids is $onError");
    });
  }
  void getCategoriesByIds(){
    CategoryService().read().then((value){
      if(value==null){
        categories = [];
        isGet = true;
        notifyListeners();
      }else {
        categories = value;
        isGet = true;
        notifyListeners();
      }
    }).catchError((onError){
      print("error on getting categories by ids is $onError");
    });
  }
}
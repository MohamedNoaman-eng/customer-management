

import 'package:flutter/material.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/models/category.dart';
class CategoryProvider extends ChangeNotifier{
  bool isGet = true;
  List<CategoryModel> categories = [];
  CategoryService categoryService = new CategoryService();
  void getAllCategories(){
    isGet = false;
    notifyListeners();
    categoryService.read().then((value) {
      if(value==null) {
        categories = [];
      }else{
      categories = value;
      }
      isGet = true;
      notifyListeners();
    }).catchError((onError){
      print("error on getting all categories");
      isGet = true;
      notifyListeners();
    });
  }
}
import 'dart:html';
import 'package:firebase/firebase.dart' as db;
import 'package:flutter/cupertino.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/productModel.dart';



class ProductProvider extends ChangeNotifier{
  String chooseProductImage='Nothing';
  String chooseCategoryImage='Nothing';
  String imageName ="ProductImage";
  String imageCategoryName ="CategoryImage";
  var fileProductPicker;
  var fileCategoryPicker;
  void fillChooseProductImage(String temp){
    chooseProductImage = temp;
    notifyListeners();
  }
  void fillChooseCategoryImage(String temp){
    chooseCategoryImage = temp;
    notifyListeners();
  }
  Future<Uri> downloadUrl({String imageName='image'}) {
    return db.storage().refFromURL("gs://zain-8bc21.appspot.com").
    child(imageName).getDownloadURL();
  }
  void clearData(){
    chooseProductImage = "Nothing";
    chooseCategoryImage='Nothing';
    fileProductPicker = null;
    fileCategoryPicker= null;
    notifyListeners();
  }
  void setImageName (String imageName){
    chooseProductImage =imageName;
    notifyListeners();
  }
  void setImageCategoryName (String imageName){
    chooseCategoryImage =imageName;
    notifyListeners();
  }
  uploadProductImageToStorage({String imageName='ProductImage'}) async{
    final path = imageName;
      uploadProductImage(onSelected: (file){
       db.storage().refFromURL("gs://zain-8bc21.appspot.com").child(path).put(file);

      print("done");
    });


  }
  void uploadProductImage({ Function(File file) onSelected}){
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      fileProductPicker  = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(fileProductPicker);
      reader.onLoadEnd.listen((event) {
        onSelected(fileProductPicker);
        setImageName(fileProductPicker.name);
      });
    });
  }
  uploadCategoryImageToStorage({String imageName='CategoryImage'}) async{
    final path = imageName;
    uploadCategoryImage(onSelected: (file){
      db.storage().refFromURL("gs://zain-8bc21.appspot.com").child(path).put(file);
    });
  }
  List<CategoryModel> categoryList =[];
  void getAllCategoriesProvider(){
    CategoryService().read().then((value) {
      categoryList = value;
      notifyListeners();
    });
    notifyListeners();
  }
  void uploadCategoryImage({ Function(File file) onSelected}){
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      fileCategoryPicker  = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(fileCategoryPicker);
      reader.onLoadEnd.listen((event) {
        onSelected(fileCategoryPicker);
        setImageCategoryName(fileCategoryPicker.name);
      });
    });
  }
  List<ProductModel> products = [];
  bool isGetProducts = true;
  void getAllProducts(){
    isGetProducts = false;
    notifyListeners();
    ProductsService().read().then((value){
      if(value==null) {
        products = [];
      }else {
        products = value;

      }
      isGetProducts = true;
      notifyListeners();
    }).catchError((onError){
      isGetProducts = true;
      notifyListeners();
      print("error on getting products");
    });
  }



}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:zain/components/loading/loading.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/productModel.dart';
import 'package:zain/provider/productProvider.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';
import 'package:zain/widgets/textformfield.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}


class _ProductsScreenState extends State<ProductsScreen> {
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  var categoryKindController = TextEditingController();
  var categoryNameController = TextEditingController();
  var categoryImageController = TextEditingController();
  var categoryCodeController = TextEditingController();
  var idController = TextEditingController();
  void clearControllers() {
    setState(() {
      nameController.text = '';
      codeController.text = '';
      priceController.text = '';
      countController.text = '';
      categoryKindController.text = '';
      categoryImageController.text = '';
      categoryCodeController.text = '';
      categoryNameController.text = '';
    });
  }
  List<String> EnNumbers=['0','1','2','3','4','5','6','7','8','9'];
  List<String> AnNumbers=['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  String convertToEn(String text){
    if(AnNumbers.contains(text)){
      return EnNumbers[AnNumbers.indexOf(text)];
    }else{
      return text;
    }
  }
  bool isAdded = true;
  bool isAdded2 = true;
  bool isGet = false;
  CategoryModel categoryModel = new CategoryModel();
  ProductModel productModel = new ProductModel();
  List<CategoryModel> categoryList =[];
  CategoryService categoryService = new CategoryService();
  void getAllCategories(){
    setState(() {
      isGet = false;
    });
    categoryService.read().then((value) {
      setState(() {
        categoryList = value;
        isGet = true;
      });
    });
  }
  void getAllCategoriesWithout(){

    categoryService.read().then((value) {
      setState(() {
        categoryList = value;
        print("get done");
      });
    });
  }

  @override
  void initState() {
    getAllCategories();
    super.initState();
  }
  bool visible =false;
  var priceController = TextEditingController();
  var countController = TextEditingController();
  void changeVisible(){
    setState(() {
      visible = !visible;
    });
  }
  @override
  Widget build(BuildContext context) {
    var tProvider = Provider.of<ProductProvider>(context);
    var fProvider = Provider.of<ProductProvider>(context,listen: false);

    return isGet? Scaffold(
      appBar: mainBar("Add Products", context,disPose: (){
        fProvider.clearData();
        clearControllers();
      }),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:LayoutBuilder(
          builder:(context,constrains)=> SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15.0,),
                Container(
                  width: constrains.maxWidth,
                  height: 50,
                  color: Color.fromRGBO(255, 0, 0, 1),
                  child:Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0,top: 10.0,bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 8.0,
                        ),
                        SizedBox(width: 10.0,),
                        Text(LocalizationConst.translate(context, "Add Product"),style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w500,color: Colors.white),)

                      ],
                    ),
                  ),
                ),
                Container(
                  width: constrains.maxWidth ,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Form(
                        key: formKey,
                        child: LayoutBuilder(
                          builder:(context,constrains)=> Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  Container(
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, "Category")
                                    ),
                                  ),
                                  categoryList !=null? DropdownButtonFormField<CategoryModel>(
                                    hint: Text(LocalizationConst.translate(
                                        context, 'Category')),
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded),
                                    iconSize: 28,
                                    elevation: 16,
                                    validator: (val){
                                      if(val==null){
                                        return "Select category";
                                      }
                                      productModel.categoryId = val.id;
                                      return null;
                                    },
                                    onChanged: (CategoryModel value) {
                                      productModel.categoryId = value.id;
                                    },
                                    items: categoryList.map<DropdownMenuItem<CategoryModel>>(
                                            (CategoryModel value) {
                                          return DropdownMenuItem<CategoryModel>(
                                            value: value,
                                            child: Text(
                                                "${value.name}"),
                                          );
                                        }).toList(),
                                  ):
                                  Text(LocalizationConst.translate(context, "Sorry"
                                      " there are no categories!")),
                                  BuildTextFormField(
                                    onChanged:  (String value) {
                                      
                                      productModel.name = value;
                                    },
                                    label: "Name",
                                    hint: "Enter Product name",
                                    labelValidate: "Enter Product name",
                                    controller: nameController,
                                    type: TextInputType.text,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  BuildTextFormField(
                                    controller: codeController,
                                    onChanged: (String value) {
                                      productModel.productId = convertToEn(value);
                                    },
                                    hint: "Enter product code",
                                    type: TextInputType.number,
                                    isValidate: true,
                                    validator: (String val){
                                      if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                        return LocalizationConst.translate(context, "Please enter english number");
                                      }else{
                                        return null;
                                      }
                                    },
                                    labelValidate: "Enter product code",
                                    label: 'Product Code',
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),

                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)
                                    ),
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          tProvider.fileProductPicker==null?Container(

                                              child: Text(LocalizationConst.translate(context, "Nothing"),),
                                            width: 80,
                                          ):
                                          Container(
                                            width: 80,
                                            child: Text("${tProvider.chooseProductImage}"),
                                          ),

                                          IconButton(onPressed: (){
                                           fProvider.uploadProductImageToStorage(imageName: fProvider.imageName);


                                          }, icon: Icon(Icons.camera_alt,size: 30.0,))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  BuildTextFormField(
                                    label: "Price",
                                    hint: "Enter product price",
                                    type: TextInputType.number,
                                    isValidate: true,
                                    validator: (String val){
                                      if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                        return LocalizationConst.translate(context, "Please enter english number");
                                      }else{
                                        return null;
                                      }
                                    },
                                    controller: priceController,
                                    onChanged: (String value) {
                                      productModel.price = convertToEn(value);
                                    },
                                    labelValidate: "Enter product price",
                                  ),
                                  SizedBox(height: 15.0,),

                                  BuildTextFormField(
                                    label: "Count",
                                    hint:"Enter product count" ,
                                    type: TextInputType.number,
                                    isValidate: true,
                                    validator: (String val){
                                      if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                        return LocalizationConst.translate(context, "Please enter english number");
                                      }else{
                                        return null;
                                      }
                                    },
                                    controller: countController,
                                    onChanged: (String value) {
                                      productModel.count = int.parse(convertToEn(value));
                                    },
                                    labelValidate: "Enter product count",
                                  ),
                                  SizedBox(height: 15.0),
                                  isAdded? ButtonTheme(
                                    minWidth: 400.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                        color: Color.fromRGBO(255, 0, 0, 1),
                                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(5.0),
                                          side: BorderSide(
                                              color: Color.fromRGBO(255, 0, 0, 1), width: 4.0),
                                        ),
                                        child: Text(
                                          LocalizationConst.translate(context, 'Add'),
                                          style: TextStyle(color: Colors.white, fontSize: 17),
                                        ),
                                        onPressed: () {
                                          if(formKey.currentState.validate()){

                                             if(categoryList!=null){
                                               setState(() {
                                                 isAdded = false;
                                               });
                                               if(fProvider.fileProductPicker!=null){
                                                 fProvider.downloadUrl(imageName: fProvider.imageName).then((value) {
                                                   productModel.image = value.normalizePath().toString();
                                                   ProductsService().add(productModel).then((value){
                                                     setState(() {
                                                       isAdded = true;
                                                     });

                                                     BuildSnackBar(
                                                         title: "Product Add Successfully",
                                                         color: Colors.greenAccent,
                                                         context: context
                                                     );
                                                     fProvider.clearData();
                                                     clearControllers();
                                                   }).catchError((onError){
                                                     print("error is $onError");
                                                     BuildSnackBar(
                                                         title: "Something went wrong",
                                                         color: Colors.red,
                                                         context: context
                                                     );
                                                   });
                                                 }).catchError((onError){
                                                   print("error is $onError");
                                                   BuildSnackBar(
                                                       title:  "Something went wrong",
                                                       color: Colors.red,
                                                       context: context
                                                   );
                                                 });
                                               }else{
                                                 ProductsService().add(productModel).then((value){
                                                   setState(() {
                                                     isAdded = true;
                                                   });

                                                   BuildSnackBar(
                                                       title: "Product Add Successfully",
                                                       color: Colors.greenAccent,
                                                       context: context
                                                   );
                                                   fProvider.clearData();
                                                   clearControllers();
                                                 }).catchError((onError){
                                                   print("error is $onError");
                                                   BuildSnackBar(
                                                       title: "Something went wrong",
                                                       color: Colors.red,
                                                       context: context
                                                   );
                                                 });
                                               }
                                             }else{
                                               BuildSnackBar(
                                                   title:  "Sorry there are no categories!",
                                                   color: Colors.red,
                                                   context: context
                                               );
                                             }

                                          }
                                        },
                                    ),
                                  ):Center(child:SpinKitCircle(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    size: 50.0,
                                    duration: Duration(milliseconds: 300),
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0)),
                                      child: OutlinedButton(
                                        child: Text(LocalizationConst.translate(context, "Clear Fields")),
                                        onPressed: () {
                                          clearControllers();
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
                SizedBox(height: 15.0,),
                Divider(height: 2,),
                SizedBox(height: 10.0,),
                Container(
                  width: constrains.maxWidth,
                  child: ListView(
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Form(
                        key: formKey2,
                        child: LayoutBuilder(
                          builder:(context,constrains)=> Container(

                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: <Widget>[
                                  SizedBox(height: 15.0,),
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    child:Padding(
                                      padding: const EdgeInsetsDirectional.only(start: 20.0,top: 10.0,bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 8.0,
                                          ),
                                          SizedBox(width: 10.0,),
                                          Text(LocalizationConst.translate(context, "Add Category"),style: TextStyle(fontSize: 19.0,fontWeight: FontWeight.w500,color: Colors.white),)

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, "Name"),
                                    ),
                                  ),
                                  SizedBox(height: 15.0,),
                                  TextFormField(
                                    controller: categoryNameController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Color(0xff16071E)),
                                    onChanged: (String value) {
                                      categoryModel.name = value;
                                    },
                                    decoration: textInputDecoration.copyWith(
                                      hintText: LocalizationConst.translate(
                                          context, "Enter Category name"),
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? LocalizationConst.translate(
                                        context, "Enter Category name")
                                        : null,
                                  ),
                                  SizedBox(height: 15.0,),
                                  Container(
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, "Category Code"),

                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    controller: categoryCodeController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Color(0xff16071E)),
                                    onChanged: (String value) {

                                      categoryModel.code = convertToEn(value);
                                    },
                                    decoration: textInputDecoration.copyWith(
                                      hintText: LocalizationConst.translate(
                                          context, "Enter Category Code"),
                                    ),
                                    validator: (String val){
                                      if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                                        return LocalizationConst.translate(context, "Please enter english number");
                                      }else{
                                        return null;
                                      }
                                    }
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      LocalizationConst.translate(context, 'Category kind'),
                                      style: TextStyle(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    controller: categoryKindController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(color: Color(0xff16071E)),
                                    decoration: textInputDecoration.copyWith(
                                        hintText: LocalizationConst.translate(
                                            context, "Enter Category Kind")),
                                    validator: (val) => val.isEmpty
                                        ? LocalizationConst.translate(
                                        context, "Enter Category Kind")
                                        : null,
                                    onChanged: (String value) {
                                      categoryModel.kind = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),


                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)
                                    ),
                                    alignment: LocalizationConst.getCurrentLang(context) == 1
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            LocalizationConst.translate(context, 'Image'),
                                            style: TextStyle(),
                                          ),

                                          tProvider.fileCategoryPicker==null?Container(
                                            width: 80,
                                              child: Text(LocalizationConst.translate(context, "Nothing"))):
                                          Container(
                                            width: 80,
                                              child: Text("${tProvider.chooseCategoryImage}")
                                          ),
                                          IconButton(onPressed: (){
                                            fProvider.uploadCategoryImageToStorage();
                                          }, icon: Icon(Icons.camera_alt,size: 30.0,))
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  isAdded2? ButtonTheme(
                                    minWidth: 400.0,
                                    height: 50.0,
                                    child: RaisedButton(
                                      color: Color.fromRGBO(255, 0, 0, 1),
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color.fromRGBO(255, 0, 0, 1), width: 4.0),
                                      ),
                                      child: Text(
                                        LocalizationConst.translate(context, 'Add'),
                                        style: TextStyle(color: Colors.white, fontSize: 17),
                                      ),
                                      onPressed: () {
                                        if(formKey2.currentState.validate()){
                                            setState(() {
                                              isAdded2 = false;
                                            });
                                            if(fProvider.fileCategoryPicker!=null){
                                              fProvider.downloadUrl(imageName: fProvider.imageCategoryName).then((value) {
                                                print("url is ${value.normalizePath().toString()}");
                                                categoryModel.image = value.normalizePath().toString();
                                                CategoryService().add(categoryModel).then((value){
                                                  setState(() {
                                                    isAdded2 = true;
                                                  });
                                                  BuildSnackBar(
                                                      title: "Category Add Successfully",
                                                      color: Colors.greenAccent,
                                                      context: context
                                                  );
                                                  getAllCategoriesWithout();
                                                  fProvider.clearData();
                                                  clearControllers();
                                                }).catchError((onError){
                                                  print(onError);
                                                  BuildSnackBar(
                                                      title: "Something went wrong",
                                                      color: Colors.red,
                                                      context: context
                                                  );
                                                });
                                              }).catchError((onError){
                                                BuildSnackBar(
                                                    title:"Something went wrong",
                                                    color: Colors.red,
                                                    context: context
                                                );
                                                print(onError);
                                              });

                                            }else{
                                              CategoryService().add(categoryModel).then((value){
                                                setState(() {
                                                  isAdded2 = true;
                                                });
                                                BuildSnackBar(
                                                    title: "Category Add Successfully",
                                                    color: Colors.greenAccent,
                                                    context: context
                                                );
                                                getAllCategoriesWithout();
                                                fProvider.clearData();
                                                clearControllers();
                                              }).catchError((onError){
                                                print(onError);
                                                BuildSnackBar(
                                                    title: "Something went wrong",
                                                    color: Colors.red,
                                                    context: context
                                                );
                                              });
                                            }
                                        }
                                      },
                                    ),
                                  ):Center(child:SpinKitCircle(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    size: 50.0,
                                    duration: Duration(milliseconds: 300),
                                  ),),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0)),
                                      child: OutlinedButton(
                                        child: Text(LocalizationConst.translate(context, "Clear Fields")),
                                        onPressed: () {
                                          clearControllers();
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
              ],
            ),
          ),
        ),
      ),
    ):Loading();
  }
}

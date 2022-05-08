import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/database_services/product.services.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/category.dart';
import 'package:zain/models/productModel.dart';
import 'package:zain/provider/productProvider.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';

class ProductDetailsScreen extends StatefulWidget {
 ProductModel productModel;
 ProductDetailsScreen({this.productModel});
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var formKey2 = GlobalKey<FormState>();
  var productCountController = TextEditingController();
  var productNameController = TextEditingController();
  var productPriceController = TextEditingController();
  var productCodeController = TextEditingController();
  bool isUpdated = true;
  String imageName='';
  bool isGet  = true;
  bool isDeleted =true;
  List<CategoryModel> categories = [];
  void fillController(){
    setState(() {
      isGet = false;
    });
    productCodeController.text = widget.productModel.productId;
    productNameController.text = widget.productModel.name;
    productPriceController.text = widget.productModel.price;
    productCountController.text = widget.productModel.count.toString();
    if(widget.productModel.image.length!=0){
      imageName = 'تم الاختيار';
    }else{
      imageName = '';
    }

  }
  void clearControllers() {
    setState(() {
      productCountController.text = '';
      productPriceController.text = '';
      productNameController.text = '';
      productCodeController.text = '';
    });
  }
  void getCategories(){
    CategoryService().read().then((value){
      if(value==null)
        categories = [];
      categories = value;
      setState(() {
        isGet = true;
      });
    }).catchError((onError){
      print("error on getting categories");
    });
  }
  @override
  void initState() {
    fillController();
    getCategories();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<ProductProvider>(context, listen: false);
    var tProvider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: mainBar("Product Details",  context,disPose: (){}),
      body: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Form(
              key: formKey2,
              child: LayoutBuilder(
                builder: (context, constrains) => Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
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
                                      context, "Category Details"),
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
                        Container(
                          alignment: LocalizationConst.getCurrentLang(context) == 1
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                            LocalizationConst.translate(context, "Name"),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: productNameController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Color(0xff16071E)),
                          onChanged: (String value) {
                            widget.productModel.name = value;
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: LocalizationConst.translate(
                                context, "Enter Product name"),
                          ),
                          validator: (val) => val.isEmpty
                              ? LocalizationConst.translate(
                              context, "Enter Product name")
                              : null,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          alignment: LocalizationConst.getCurrentLang(context) == 1
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                            LocalizationConst.translate(context, "Product Code"),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: productCodeController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Color(0xff16071E)),
                          onChanged: (String value) {
                            widget.productModel.productId = value;
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: LocalizationConst.translate(
                                context, "Enter product code"),
                          ),
                          validator:  (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          alignment: LocalizationConst.getCurrentLang(context) == 1
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                            LocalizationConst.translate(context, "Count"),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: productCountController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Color(0xff16071E)),
                          onChanged: (String value) {
                            if(value.isNotEmpty){
                              widget.productModel.count = int.parse(value);
                            }
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: LocalizationConst.translate(
                                context, "Enter product count"),
                          ),
                          validator:  (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: productPriceController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Color(0xff16071E)),
                          onChanged: (String value) {
                            if(value.isNotEmpty){
                              widget.productModel.price = value;
                            }
                          },
                          decoration: textInputDecoration.copyWith(
                            hintText: LocalizationConst.translate(
                                context, "Enter price"),
                          ),
                          validator:  (String val){
                            if(val.contains(RegExp("[٠-٩]"))||val.contains(RegExp("[۰-۹]"))||val.contains(RegExp("[ا-ى]"))||val.contains(RegExp("[a-z]"))||val.contains(RegExp("[A-Z]"))||val.isEmpty){
                              return LocalizationConst.translate(context, "Please enter english number");
                            }else{
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          alignment: LocalizationConst.getCurrentLang(context) == 1
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Text(
                              LocalizationConst.translate(context, "Category")
                          ),
                        ),
                        categories !=null? DropdownButtonFormField<CategoryModel>(
                          hint: Text(LocalizationConst.translate(
                              context, 'Category')),
                          icon: const Icon(
                              Icons.keyboard_arrow_down_rounded),
                          iconSize: 28,
                          elevation: 16,
                          value: categories.singleWhere((element) => element.id==widget.productModel.categoryId,orElse: ()=>null) ,
                          validator: (val){
                            if(val==null){
                              return "Select category";
                            }
                            widget.productModel.categoryId = val.id;
                            return null;
                          },
                          onChanged: (CategoryModel value) {
                            widget.productModel.categoryId = value.id;
                          },
                          items: categories.map<DropdownMenuItem<CategoryModel>>(
                                  (CategoryModel value) {
                                return DropdownMenuItem<CategoryModel>(
                                  value: value,
                                  child: Text(
                                      "${value.name}"),
                                );
                              }).toList(),
                        ):
                        Text(LocalizationConst.translate(context, "Sorry there are no categories!")),
                        SizedBox(
                          height: 15.0,
                        ),
                        
                        Container(
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
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
                                Text("$imageName",style: TextStyle(color: Colors.greenAccent),),
                                IconButton(
                                    onPressed: () {
                                      fProvider.uploadCategoryImageToStorage();
                                    },
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 30.0,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        isUpdated
                            ? ButtonTheme(
                          minWidth: 400.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: Color.fromRGBO(255, 0, 0, 1),
                            padding:
                            const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Color.fromRGBO(255, 0, 0, 1),
                                  width: 4.0),
                            ),
                            child: Text(
                              LocalizationConst.translate(context, 'Update'),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                            onPressed: () {
                             if(whoIs==4){

                             }else{
                               if (formKey2.currentState.validate()) {
                                 if(imageName.isNotEmpty){
                                   if (tProvider.fileCategoryPicker != null) {
                                     setState(() {
                                       isUpdated = false;
                                     });
                                     fProvider
                                         .downloadUrl(
                                         imageName:
                                         fProvider.imageCategoryName)
                                         .then((value) {
                                       print(
                                           "url is ${value.normalizePath().toString()}");
                                       widget.productModel.image =
                                           value.normalizePath().toString();
                                       ProductsService().update(widget.productModel)
                                           .then((value) {
                                         setState(() {
                                           isUpdated = true;
                                         });
                                         BuildSnackBar(
                                             title:
                                             "؛Product Updated Successfully",
                                             color: Colors.greenAccent,
                                             context: context);
                                       }).catchError((onError) {
                                         BuildSnackBar(
                                             title: "Something went wrong",
                                             color: Colors.red,
                                             context: context);
                                       });
                                     }).catchError((onError) {
                                       BuildSnackBar(
                                           title: "Something went wrong",
                                           color: Colors.red,
                                           context: context);
                                     });
                                   } else {
                                     ProductsService().update(widget.productModel)
                                         .then((value) {
                                       setState(() {
                                         isUpdated = true;
                                       });
                                       BuildSnackBar(
                                           title:
                                           "؛Product Updated Successfully",
                                           color: Colors.greenAccent,
                                           context: context);
                                     }).catchError((onError) {
                                       BuildSnackBar(
                                           title: "Something went wrong",
                                           color: Colors.red,
                                           context: context);
                                     });
                                   }
                                 }else{
                                   setState(() {
                                     isUpdated = false;
                                   });
                                   ProductsService().update(widget.productModel)
                                       .then((value) {
                                     setState(() {
                                       isUpdated = true;
                                     });
                                     BuildSnackBar(
                                         title:
                                         "Product Updated Successfully",
                                         color: Colors.greenAccent,
                                         context: context);
                                   }).catchError((onError) {
                                     BuildSnackBar(
                                         title: "Something went wrong",
                                         color: Colors.red,
                                         context: context);
                                   });
                                 }
                               }
                             }
                            },
                          ),
                        )
                            : Center(
                          child: SpinKitCircle(
                            color: Color.fromRGBO(255, 0, 0, 1),
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
                            child: isDeleted?OutlinedButton(
                              child: Text(LocalizationConst.translate(
                                  context, "Delete")),
                              onPressed: () {
                               if(whoIs==4){

                               }else{
                                 setState(() {
                                   isDeleted = false;
                                 });
                                 ProductsService().delete(widget.productModel.id).then((value) {
                                   BuildSnackBar(
                                       context: context,
                                       color: Colors.greenAccent,
                                       title: "Product Deleted Successfully"
                                   );
                                   setState(() {
                                     isDeleted = true;
                                   });
                                   clearControllers();
                                   imageName='';
                                 }).catchError((onError){
                                   BuildSnackBar(
                                       context: context,
                                       color: Colors.red,
                                       title: "Something went wrong"
                                   );
                                 });

                               }
                              },
                            ):SpinKitCircle(
                              color: Color.fromRGBO(255, 0, 0, 1),
                              duration: Duration(milliseconds: 300),
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
    );
  }
}

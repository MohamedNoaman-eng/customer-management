import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/database_services/category.service.dart';
import 'package:zain/localization/localization_constants.dart';
import 'package:zain/models/category.dart';
import 'package:zain/provider/category_provider.dart';
import 'package:zain/provider/productProvider.dart';
import 'package:zain/theme/input.dart';
import 'package:zain/widgets/appBar.dart';
import 'package:zain/widgets/snackbar.dart';

class CategoryDetailsScreen extends StatefulWidget {
  CategoryModel categoryModel;

  CategoryDetailsScreen(this.categoryModel);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  var formKey2 = GlobalKey<FormState>();
  var categoryKindController = TextEditingController();
  var categoryNameController = TextEditingController();
  var categoryImageController = TextEditingController();
  var categoryCodeController = TextEditingController();
  bool isUpdated = true;
  String imageName='';
  bool isGet  = true;
  bool isDeleted =true;
  void fillController(){
    setState(() {
      isGet = false;
    });
    categoryKindController.text = widget.categoryModel.kind;
    categoryCodeController.text = widget.categoryModel.code;
    categoryNameController.text = widget.categoryModel.name;
    if(widget.categoryModel.image.length!=0){
      imageName = 'تم الاختيار';
    }else{
      imageName = '';
    }
    setState(() {
      isGet = true;
    });
  }
  void clearControllers() {
    setState(() {
      categoryKindController.text = '';
      categoryImageController.text = '';
      categoryCodeController.text = '';
      categoryNameController.text = '';
    });
  }
  @override
  void initState() {
    fillController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var fProvider = Provider.of<ProductProvider>(context, listen: false);
    var tProvider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: mainBar("Category Details", context,disPose: (){}),
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
                      controller: categoryNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Color(0xff16071E)),
                      onChanged: (String value) {
                        widget.categoryModel.name = value;
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
                    SizedBox(
                      height: 15.0,
                    ),
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
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Color(0xff16071E)),
                      onChanged: (String value) {
                        widget.categoryModel.code = value;
                      },
                      decoration: textInputDecoration.copyWith(
                        hintText: LocalizationConst.translate(
                            context, "Enter Category Code"),
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
                        widget.categoryModel.kind = value;
                      },
                    ),
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
                            Text("$imageName",style: TextStyle(color: Colors.green),),
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
                                   if(imageName.isEmpty){
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
                                         widget.categoryModel.image =
                                             value.normalizePath().toString();
                                         CategoryService().update(widget.categoryModel, widget.categoryModel.id)
                                             .then((value) {
                                           setState(() {
                                             isUpdated = true;
                                           });
                                           BuildSnackBar(
                                               title:
                                               "Category Updated Successfully",
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
                                       BuildSnackBar(
                                           title: "Please select image",
                                           color: Colors.red,
                                           context: context);
                                     }
                                   }else{
                                     setState(() {
                                       isUpdated = false;
                                     });
                                     CategoryService().update(widget.categoryModel, widget.categoryModel.id)
                                         .then((value) {
                                       setState(() {
                                         isUpdated = true;
                                       });
                                       BuildSnackBar(
                                           title:
                                           "Category Updated Successfully",
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
                            CategoryService().delete(widget.categoryModel.id).then((value) {
                              BuildSnackBar(
                                  context: context,
                                  color: Colors.greenAccent,
                                  title: "Category Deleted Successfully"
                              );
                              setState(() {
                                isDeleted = true;
                              });
                            }).catchError((onError){
                              BuildSnackBar(
                                  context: context,
                                  color: Colors.red,
                                  title: "Something went wrong"
                              );
                              print("error is $onError");
                            });
                            clearControllers();
                            imageName = '';
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

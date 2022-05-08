

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/models/category.dart';

class CategoryService {
  Repository _rep = Repository("category");
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  final db = FirebaseFirestore.instance.collection("category");

  Future<List<CategoryModel>> read() async {
    var result = await _rep.getDataCollection();

    if (result.docs.isEmpty) return null;
    List<CategoryModel> categories=[];
    result.docs.forEach((element) {
      categories.add(CategoryModel.fromMap(element.data(), element.id));
    });

    return categories;
  }
  Future add(CategoryModel data) async {
    return await _rep.addDocument(data.toJson());
  }
  Future delete(String id) async {
    return await _rep.removeDocument(id);
  }
  Future update(CategoryModel data, String id) async {
    return await _rep.updateDocument(data.toJson(), data.id);
  }
  Future<CategoryModel> getById(String categoryId) async {
    var result = await _rep.getDocumentById(categoryId);
    if (result ==null) return null;
    var user = result;
    return CategoryModel.fromMap(user, user.id);
  }
  Future<List<CategoryModel>> getByIds(List<String> productId) async {
    List<CategoryModel> categories =[];
    productId.forEach((element) async{
      var result = await _rep.getDocumentById(element);
      if (result==null) return null;
      categories.add( CategoryModel.fromMap(result.data(), result.id));
    });
    return categories;
  }
}

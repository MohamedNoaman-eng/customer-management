import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/models/productModel.dart';

class ProductsService {
  Repository _rep = Repository("products");
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  final db = FirebaseFirestore.instance.collection("products");
  Future add(ProductModel data) async {
    return await _rep.addDocument(data.toJson());
  }
  Future update(ProductModel data) async {
    return await _rep.updateDocument(data.toJson(), data.id);
  }
  Future delete(id) async {
    return await _rep.removeDocument(id);
  }
  Future<List<ProductModel>> read() async {
    var result = await fr.collection("products").get();
    if (result.docs.isEmpty) return null;
    List<ProductModel> products=[];
    result.docs.forEach((element) {
      products.add(ProductModel.fromMap(element.data(), element.id));
    });

    return products;
  }

  Future<ProductModel> getById(String productId) async {
    print("id is $productId");
    var result = await _rep.getDocumentById(productId);
    if (result==null) return null;
    return ProductModel.fromMap(result.data(), result.id);
  }
  Future<List<ProductModel>> getByIds(List<String> productId) async {
    List<ProductModel> products =[];
    productId.forEach((element) async{
      var result = await _rep.getDocumentById(element);
      if (result==null) return null;
      products.add( ProductModel.fromMap(result.data(), result.id));
    });
    return products;
  }
}

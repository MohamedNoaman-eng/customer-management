import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/models/order_model.dart';
import 'package:zain/models/productModel.dart';

class OrderService {
  Repository _rep = Repository("orders");
  final FirebaseFirestore fr = FirebaseFirestore.instance;
  Future add(OrderModel data) async {
     var value= await _rep.addDocument(data.toJson());
     return value.id;
  }
  Future<List<OrderModel>> read() async {
    var result = await _rep.getDataCollection();
    if (result.docs.isEmpty) return null;
    List<OrderModel> orders=[];
    result.docs.forEach((element) {
      orders.add(OrderModel.fromMap(element.data(), element.id));
    });

    return orders;
  }
  Future<List<OrderModel>> readByIds(List<String> ids) async {
    var result = await _rep.getDataCollection();
    if (result.docs.isEmpty) return null;
    List<OrderModel> orders=[];
    result.docs.forEach((element) {
      if(ids.contains(element.id)){
        orders.add(OrderModel.fromMap(element.data(), element.id));
      }
    });
    return orders;
  }
  Future updateOrder(OrderModel data, id) async{
    _rep.updateDocument(data.toJson(), id);
  }
  Future deleteOrder(id) async{
    _rep.removeDocument(id);
  }
  Future<List<OrderModel>> readByServiceId(serviceId) async {
    var result = await fr
        .collection('category')
        .where('serviceId', isEqualTo: serviceId)
        .get();

    if (result.docs.isEmpty) return null;

    List<OrderModel> orders = result.docs
        .map<OrderModel>(
            (data) => OrderModel.fromMap(data.data(), data.id))
        .toList();

    return orders;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/models/driver.dart';

class DriverService {
  Repository _rep = Repository("drivers");
  final db = FirebaseFirestore.instance.collection("drivers");

  Future add(DriverModel data,String id) async {
    return await db.doc(id).set(data.toJson());
  }
  Future<int> getCount() async{
    var result= await db.get();
    int size=0;
    result.docs.forEach((element) {
      size+=1;
    });
    return size;
  }
  Future<List<DriverModel>> read() async {
    var result = await _rep.getDataCollection();
    if (result.docs.isEmpty) return null;
    List<DriverModel> drivers = [];
    result.docs.forEach((element) {
      drivers.add(DriverModel.fromMap(element.data(), element.id));
    });
    return drivers;
  }

  Future deleteClient(String driverID) async{
    return await db.doc(driverID).delete();
  }

  Future<DriverModel> getById(String driverID) async {
    var result = await db.doc(driverID).get();
    if (result==null) return null;
    return DriverModel.fromMap(result.data(), result.id);
  }


  Future update(DriverModel data, String driverID,context) async {
    await db.doc(driverID).update(data.toJson());

  }


}

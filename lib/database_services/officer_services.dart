import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';

import 'package:zain/models/clientDetails.dart';
import 'package:zain/models/officer.dart';


class OfficerService {
  Repository _rep = Repository("officers");
  final db = FirebaseFirestore.instance.collection("officers");

  Future add(OfficerModel data,String id) async {
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
  Future<List<OfficerModel>> read() async {
    var result = await _rep.getDataCollection();
    if (result.docs.isEmpty) return null;
    List<OfficerModel> officers = [];
    result.docs.forEach((element) {
      officers.add(OfficerModel.fromMap(element.data(), element.id));
    });
    return officers;
  }
  Future deleteClient(String officerID) async{
    return await _rep.removeDocument(officerID);
  }

  Future<OfficerModel> getById(String officerID) async {
    var result = await db.doc(officerID).get();
    if(result==null)
      return null;
    return OfficerModel.fromMap(result.data(), result.id);
  }


  Future update(OfficerModel data, String officerID,context) async {
    await db.doc(officerID).update(data.toJson());

  }


}

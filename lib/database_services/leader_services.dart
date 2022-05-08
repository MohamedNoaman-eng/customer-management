import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/models/leader.dart';



class LeaderService {
  Repository _rep = Repository("leaders");
  final db = FirebaseFirestore.instance.collection("leaders");

  Future add(LeaderModel data,String id) async {
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
  Future<List<LeaderModel>> read() async {
    var result = await _rep.getDataCollection();
    if (result.docs.isEmpty) return null;
    List<LeaderModel> leaders = [];
    result.docs.forEach((element) {
      leaders.add(LeaderModel.fromMap(element.data(), element.id));
    });
    return leaders;
  }

  Future deleteClient(String leaderID) async{
    return await _rep.removeDocument(leaderID);
  }

  Future<LeaderModel> getById(String leaderID) async {
    var result = await db.doc(leaderID).get();
    if (result==null){
      return null;
    }
    return LeaderModel.fromMap(result.data(), result.id);
  }


  Future update(LeaderModel data, String leaderID,context) async {
    await db.doc(leaderID).update(data.toJson());

  }


}

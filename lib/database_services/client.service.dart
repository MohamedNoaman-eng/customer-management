import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zain/common/Repository.dart';
import 'package:zain/common/constant.dart';
import 'package:zain/models/clientDetails.dart';


class ClientService {
  Repository _rep = Repository("client");
  final db = FirebaseFirestore.instance.collection("client");



  Future add(ClientDetails data) async {
    return await _rep.addDocument(data.toJson());
  }
  Future<int> getCount() async{
     var result= await db.get();
     int size=0;
     result.docs.forEach((element) {
       size+=1;
     });
     return size;
  }
  Future<List<ClientDetails>> getAllClients() async{
    List<ClientDetails> clients =[];
    var result = await _rep.getDataCollection();
    result.docs.forEach((client) {
      clients.add(ClientDetails.fromMap(client, client.id));
    });
    return clients;
  }
  Future deleteClient(String clientID) async{
     return await _rep.removeDocument(clientID);
  }

  Future<ClientDetails> getById(String clientId) async {
    var result = await db.doc(clientId).get();
    if (result ==null) return null;
    var user = result;
    return ClientDetails.fromMap(user.data(), user.id);
  }


  Future update(ClientDetails data, String userId,context) async {
    await db.doc(userId).update(data.toJson());

  }


}

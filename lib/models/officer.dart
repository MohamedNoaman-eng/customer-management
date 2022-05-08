class OfficerModel {
  String id;
  String officerName;
  String officerEmail;
  String officerId;
  List officerPhone;
  String officerAge;
  List orders=[];
  String leaderId;
  DateTime joiningAt;
  double totlaConsumpation;
  double orderReward;
  double profit;

  OfficerModel({this.leaderId='',
    this.officerAge,
    this.officerEmail,
    this.officerName,
    this.officerId,
    this.totlaConsumpation=0,
    this.officerPhone,
    this.orderReward=0.0,
    this.profit=0.0,
    this.orders,
  this.joiningAt});

  toJson() {
    return {
      'officerId': officerId,
      'officerName': officerName,
      'officerEmail': officerEmail,
      'officerPhone': officerPhone,
      'officerAge': officerAge,
      'leaderId': leaderId,
      'orderReward': orderReward,
      'joiningAt':joiningAt,
      'totlaConsumpation':totlaConsumpation,
      'orders':orders,
      'profit':profit

    };
  }

  OfficerModel.fromMap(snapshot, id)
      : id =id,
  officerName = snapshot['officerName']??'',
  officerEmail = snapshot['officerEmail']??'',
  officerPhone = snapshot['officerPhone']??[],
  officerAge = snapshot['officerAge']??'',
  leaderId = snapshot['leaderId']??'',
  orderReward = snapshot['orderReward']??0.0,
  officerId = snapshot['officerId']??'',
  orders = snapshot['orders']??[],
  totlaConsumpation = snapshot['totlaConsumpation']??0,
  profit = snapshot['profit']??0.0,
  joiningAt = snapshot['joiningAt'].toDate();

}

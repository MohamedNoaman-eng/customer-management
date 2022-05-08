class LeaderModel {
  String id;
  String leaderName;
  String leaderEmail;
  String leaderId;
  List leaderPhone;
  String leaderAge;
  List officersIds=[];
  List orders=[];
  double profit;
  double totlaConsumpation;
  DateTime joiningAt;
  String orderReward;

  LeaderModel(
      {this.leaderId,
        this.totlaConsumpation=0,
      this.leaderAge,
      this.leaderEmail,
      this.leaderName,
      this.officersIds,
      this.leaderPhone,
      this.orderReward,
      this.orders,
      this.profit=0,
      this.joiningAt});

  toJson() {
    return {
      'leaderId': leaderId,
      'leaderName': leaderName,
      'leaderEmail': leaderEmail,
      'leaderPhone': leaderPhone,
      'leaderAge': leaderAge,
      'officersIds': officersIds,
      'orderReward': orderReward,
      'orders': orders,
      'profit': profit,
      'joiningAt': joiningAt,
      'totlaConsumpation':totlaConsumpation
    };
  }

  LeaderModel.fromMap(snapshot, id)
      : id = id,
        leaderName = snapshot['leaderName'] ?? '',
        leaderEmail = snapshot['leaderEmail'] ?? '',
        leaderPhone = snapshot['leaderPhone'] ?? [],
        leaderAge = snapshot['leaderAge'] ?? '',
        officersIds = snapshot['officersIds'] ?? [],
        orderReward = snapshot['orderReward'] ?? '',
        leaderId = snapshot['leaderId'] ?? '',
        orders = snapshot['orders'] ?? [],
        profit = snapshot['profit'] ?? 0.0,
        totlaConsumpation = snapshot['totlaConsumpation']??0,
        joiningAt = snapshot['joiningAt'].toDate();
}

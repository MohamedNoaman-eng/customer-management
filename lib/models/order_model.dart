class OrderModel {
  String id;
  String orderClientId;
  String orderProductId;
  String orderCategoryId;
  DateTime createdAt;
  bool isPremium;
  String paidPrice;
  List<dynamic> orderList=[];
  String createdBy;
  String totalPrice;
  String status;

  OrderModel(
      {this.status='',
      this.paidPrice='0',
      this.createdAt,
      this.totalPrice="0",
      this.isPremium=false,
      this.createdBy="",
      this.orderList,
      this.orderCategoryId='',
      this.orderClientId='',
      this.orderProductId=''});

  toJson() {
    return {
      'isPremium': isPremium,
      'clientID': orderClientId,
      'paidPrice': paidPrice,
      'orderList': orderList,
      'totalPrice': totalPrice,
      'createdBy': createdBy,
      'createdAt': DateTime.now(),
      'status': status,
    };
  }

  OrderModel.fromMap(snapshot, String id)
      : id = id ?? '',
        orderList = snapshot['orderList'] ?? [],
        createdBy = snapshot['createdBy'] ?? '',
        paidPrice = snapshot['paidPrice'] ?? '',
        status = snapshot['status'] ?? '',
        createdAt = snapshot['createdAt'].toDate(),
        orderClientId = snapshot['clientID'] ?? '',
        isPremium = snapshot['isPremium'] ?? false,
        totalPrice = snapshot['totalPrice'] ?? '';
}

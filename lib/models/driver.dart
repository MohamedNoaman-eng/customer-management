class DriverModel {
  String id;
  String driverName;
  String driverPhone;
  String driverId;
  List orders;
  String carId;
  String carCounter;
  String carConsumption;

  DriverModel(
      {this.orders,
      this.driverId,
      this.driverName,
      this.driverPhone,
      this.carConsumption='0',
      this.carCounter='0',
      this.carId});

  toJson() {
    return {
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverId': driverId,
      'orders': orders,
      'carId': carId,
      'carCounter': carCounter,
      'carConsumption': carConsumption
    };
  }

  DriverModel.fromMap(data, id)
      : id = id,
        driverName = data['driverName'] ?? '',
        driverPhone = data['driverPhone'] ?? '',
        driverId = data['driverId'] ?? '',
        carId = data['carId'] ?? '',
        carConsumption = data['carConsumption'] ?? '',
        carCounter = data['carCounter'] ?? '',
        orders = data['orders'] ?? [];
}

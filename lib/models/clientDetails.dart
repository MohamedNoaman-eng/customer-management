class ClientDetails {
  String id;
  String name;
  String age;
  String email;
  String government;
  String area;
  String city;
  double discount;
  List phone;
  String clientId;
  String officerId;
  double late;
  double rate;
  double consumption;
  int numberOfOrders;
  double lang;
  DateTime createdOn;

  ClientDetails({
    this.government,
    this.area,
    this.officerId,
    this.numberOfOrders=0,
    this.rate=0.0,
    this.city,
    this.consumption=0.0,
    this.discount,
    this.late=0.0,
    this.lang=0.0,
    this.clientId,
    this.name,
    this.age,
    this.phone,
    this.email,
    this.createdOn,
  });

  toJson() {
    return {
      "clientId": clientId,
      "name": name,
      "age": age,
      "phone": phone,
      "discount": discount,
      "email": email,
      "government": government,
      "area": area,
      "city": city,
      "createdOn": DateTime.now(),
      "officerId": officerId,
      "late": late,
      "lang": lang,
      "numberOfOrder": numberOfOrders,
      "rate": rate,
      "consumption": consumption
    };
  }

  ClientDetails.fromMap(snapshot, id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        phone = snapshot['phone'] ?? [],
        clientId = snapshot['clientId'] ?? '',
        age = snapshot['age'] ?? '',
        officerId = snapshot['officerId'] ?? '',
        government = snapshot['government'] ?? '',
        area = snapshot['area'] ?? '',
        city = snapshot['city'] ?? '',
        discount = snapshot['discount'] ?? 0.0,
        late = snapshot['late'] ?? 0.0,
        lang = snapshot['lang'] ?? 0.0,
        numberOfOrders = snapshot['numberOfOrder'] ?? 0,
        rate = snapshot['rate'] ?? 0.0,
        consumption = snapshot['consumption'] ?? 0,
        createdOn = snapshot['createdOn'].toDate() ?? '',
        email = snapshot['email'] ?? '';
}

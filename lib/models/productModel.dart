class ProductModel {
  String id;
  String name;
  String image;
  String productId;
  int count;
  String categoryId;
  String price;

  ProductModel(
      { this.name,  this.image='',  this.productId,  this.price,  this.categoryId,this.count});

  toJson() {
    return {
      'name': name,
      'image': image,
      'productId': productId,
      'categoryId': categoryId,
      'price': price,
      'count':count
    };
  }

  ProductModel.fromMap(snapshot, String id)
      : id = id,
        name = snapshot['name']??'',
        productId = snapshot['productId']??'',
        categoryId = snapshot['categoryId']??'',
        price = snapshot['price']??'',
        count = snapshot['count']??0,
        image = snapshot['image']??'';
}

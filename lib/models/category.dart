class CategoryModel {
  String id;
  String name;
  String image;
  String code;
  String kind;


  CategoryModel({this.id,  this.name , this.image='', this.kind, this.code});
  toJson(){
    return {
      'name':name,
      'code':code,
      'image':image,
      'kind':kind
    };
  }
  CategoryModel.fromMap(snapshot, String id)
      : id = id??'',
        name = snapshot['name']??'',
        kind = snapshot['kind']??'',
        code = snapshot['code']??'',
        image = snapshot['image']??'';
}
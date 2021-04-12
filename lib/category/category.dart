class Category{
  int cid;
  String category;
  String pictureurl;
  String description;

  Category({
    this.cid,
    this.category,
    this.pictureurl,
    this.description
  });


  String getCategory() {
    return this.category;
  }

  factory Category.fromJson(Map<String, dynamic> parsedJson){
    return Category(
        cid: parsedJson['c_id'],
        category : parsedJson['category'],
        pictureurl: parsedJson['pictureurl'],
        description: parsedJson['description'],
    );
  }
}
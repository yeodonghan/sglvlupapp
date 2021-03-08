class Category{
  int cid;
  String category;

  Category({
    this.cid,
    this.category,
  });


  String getCategory() {
    return this.category;
  }

  factory Category.fromJson(Map<String, dynamic> parsedJson){
    return Category(
        cid: parsedJson['c_id'],
        category : parsedJson['category']
    );
  }
}
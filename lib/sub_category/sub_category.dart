class SubCategory{
  String category;
  int level;

  SubCategory({
    this.category,
    this.level,
  });


  factory SubCategory.fromJson(Map<String, dynamic> parsedJson){
    return SubCategory(
        level: parsedJson['difficulty'],
        category : parsedJson['category']
    );
  }
}

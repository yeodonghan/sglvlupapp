class UserScore {
  final String category;
  final String points;
  final String user_name;
  final String user_pictureurl;

  UserScore({
    this.category,
    this.points,
    this.user_name,
    this.user_pictureurl,
  });

  factory UserScore.fromJson(Map parsedJson) {
    if (parsedJson["category"] == null) {
      return UserScore(
        category: "Overall",
        points: parsedJson["points"],
        user_name: parsedJson["user_name"],
        user_pictureurl: parsedJson["user_pictureurl"],
      );
    } else {
      return UserScore(
        category: parsedJson["category"],
        points: parsedJson["points"].toString(),
        user_name: parsedJson["user_name"],
        user_pictureurl: parsedJson["user_pictureurl"],

      );
    }

  }
}
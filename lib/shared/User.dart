class User{
  String name;
  String email;
  String pictureURL;
  String type;
  int coins;

  User({
    this.name,
    this.email,
    this.pictureURL,
    this.type,
  });

  String getUrl() {
    return this.pictureURL;
  }

  void setCoins(int coins) {
    this.coins = coins;
  }



  String toString() {
    return this.name + " " + this.email + " " + this.pictureURL + " " + this.type;
  }

}
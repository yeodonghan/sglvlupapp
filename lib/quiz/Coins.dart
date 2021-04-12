class Coins{
  // ignore: non_constant_identifier_names
  int user_coins;

  Coins({
    // ignore: non_constant_identifier_names
    this.user_coins
  });


  int getCoins() {
    return this.user_coins;
  }

  factory Coins.fromJson(Map<String, dynamic> parsedJson){
    return Coins(
        user_coins: parsedJson['user_coins'],
    );
  }
}
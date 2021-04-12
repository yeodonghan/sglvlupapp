import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class UserProfile {
  final int user_id;
  final String user_pictureurl;
  String user_name;
  final String user_email;
  String user_mobile;
  final String user_accounttype;
  final String user_registerdate;
  int user_coins;
  int user_notification;

  UserProfile({
    @required this.user_id,
    @required this.user_pictureurl,
    @required this.user_name,
    @required this.user_email,
    this.user_mobile,
    @required this.user_accounttype,
    @required this.user_registerdate,
    @required this.user_coins,
    @required this.user_notification
  });

  factory UserProfile.fromJson(Map parsedJson) {
    return UserProfile(
        user_id: parsedJson["user_id"],
        user_pictureurl: parsedJson["user_pictureurl"],
        user_name: parsedJson["user_name"],
        user_email: parsedJson["user_email"],
        user_mobile: parsedJson["user_mobile"],
        user_accounttype: parsedJson["user_accounttype"],
        user_registerdate: parsedJson["user_registerdate"],
        user_coins: parsedJson["user_coins"],
        user_notification: parsedJson["user_notification"]
    );
  }

  void setCoins(int coins) {
    this.user_coins = coins;
  }

  void setUsername(String name) {
    this.user_name = name;
  }

  void setUserNotification(int notif) {
    this.user_notification = notif;
  }

  void updateProfile(String name, String mobile) {
    this.user_name = name;
    this.user_mobile = mobile;
  }

  String toString() {
    return this.user_id.toString() + " " + this.user_name + " " + this.user_email + " " + this.user_mobile + " " + this.user_accounttype + " " + this.user_registerdate + " " + this.user_coins.toString();
  }
}
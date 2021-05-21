import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:SGLvlUp/login/login_page.dart';
import 'package:SGLvlUp/shared/UserPreferences.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class SettingWidget extends StatefulWidget {
  final UserProfile user;

  SettingWidget({Key key, @required this.user}) : super(key: key);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  // To get data from a saved appdata

  bool tapSound = SoundsHandler().tapSound;
  bool sound = SoundsHandler().sound;
  bool pushNotification;
  BannerAd _bannerAd;

  //InterstitialAd _ad;
  bool isLoaded = true;
  String apiUrl =
      "http://ec2-54-255-217-149.ap-southeast-1.compute.amazonaws.com:5000";

  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    if (widget.user.user_notification == 1) {
      pushNotification = true;
    } else {
      pushNotification = false;
    }

    _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.fullBanner,
        listener: AdListener(onAdLoaded: (_) {
          setState(() {
            isLoaded = false;
          });
        }, onAdFailedToLoad: (_, error) {
          print('Ad Fail to Load with Error: $error');
        }));
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    print("Ads Disposed");
    super.dispose();
  }

  Widget checkForAd() {
    return isLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: AdWidget(
              ad: _bannerAd,
            ),
            width: _bannerAd.size.width.toDouble(),
            height: _bannerAd.size.height.toDouble(),
            alignment: Alignment.center,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/informationBG.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
            child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Settings'),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Game Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SwitchListTile(
                        dense: true,
                        activeColor: Color(0xFFFFC823),
                        contentPadding: EdgeInsets.all(0),
                        value: tapSound,
                        title: Text("Sound"),
                        onChanged: (val) {
                          SoundsHandler().playTap();
                          setState(() {
                            tapSound = val;
                            UserPreferences().setTapSound(val);
                            SoundsHandler().tapSound = val;
                          });
                        },
                        secondary: const Icon(Icons.volume_up_outlined),
                      ),
                      SwitchListTile(
                        dense: true,
                        activeColor: Color(0xFFFFC823),
                        contentPadding: EdgeInsets.all(0),
                        value: sound,
                        title: Text("Background Music"),
                        onChanged: (val) {
                          SoundsHandler().playTap();
                          setState(() {
                            sound = val;
                            UserPreferences().setSound(val);
                            SoundsHandler().sound = val;
                            SoundsHandler().update();
                          });
                        },
                        secondary: const Icon(Icons.music_note_outlined),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Notification Settings",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SwitchListTile(
                        dense: true,
                        activeColor: Color(0xFFFFC823),
                        contentPadding: EdgeInsets.all(0),
                        value: pushNotification,
                        title: Text("Push Notification"),
                        onChanged: (val) {
                          setState(() {
                            SoundsHandler().playTap();
                            pushNotification = val;
                            // Update notification
                            Future<void> updateNotification() async {
                              var value;
                              if (val == true) {
                                value = "1";
                              } else {
                                value = "0";
                              }
                              print("Updating Notification...");
                              var response = await http.put(
                                  apiUrl + "/api/user/notification",
                                  body: {
                                    "user_email": "${widget.user.user_email}",
                                    "user_notification": "$value"
                                  });
                              print(response.body);

                              if (response.statusCode == 200) {
                                print("Passed");
                              } else {
                                print("Failed");
                                throw Exception(
                                    'Failed to update Notification');
                              }
                            }

                            updateNotification();
                            if (val == true) {
                              widget.user.setUserNotification(1);
                            } else {
                              widget.user.setUserNotification(0);
                            }
                          });
                        },
                        secondary: const Icon(Icons.notifications_none),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      buildFeedback(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildPrivacyPolicy(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildTosPolicy(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildShare(context),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 15,
                        thickness: 2,
                      ),
                      buildLogout(context),
                      Divider(
                        height: 15,
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ),
              checkForAd(),
            ],
          ),

          //bottomNavigationBar: NavBar(),
          // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }

  GestureDetector buildFeedback(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundsHandler().playTap();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Feedback',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        TextField(
                          maxLines: 10,
                          onChanged: (String value) {
                            message = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Please leave a feedback",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (message.length == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Please fill in the feedback field!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else if (message.length > 1000) {
                              Fluttertoast.showToast(
                                  msg:
                                      'Please keep the message under 1000 Characters!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);
                            } else {
                              print(message);
                              print(DateTime.now().toString());
                              Future<void> sendFeedback() async {
                                print("Sending Feedback...");
                                var response = await http.post(
                                    apiUrl + "/api/feedback/newfeedback",
                                    body: {
                                      "feedback": "$message",
                                      "receive_date":
                                          "${DateTime.now().toString()}"
                                    });
                                print(response.body);
                                if (response.statusCode == 200) {
                                  print("Passed");
                                } else {
                                  print("Failed");
                                  throw Exception('Failed to send Feedback');
                                }
                              }

                              sendFeedback();
                              Fluttertoast.showToast(
                                  msg: 'Feedback Sent!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER);

                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            primary: Color(0xFFFFC823),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Theme.of(context).buttonColor,
                            onPressed: () => Navigator.of(context).pop(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8))),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8))),
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).textTheme.button.color,
                                ),
                              ),
                            ))
                      ],
                    )),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Feedback',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  GestureDetector buildPrivacyPolicy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundsHandler().playTap();
        showDialog(
          context: context,
          builder: (context) {
            return PolicyDialog(mdFileName: 'privacy_policy.md');
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  GestureDetector buildTosPolicy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundsHandler().playTap();
        showDialog(
          context: context,
          builder: (context) {
            return PolicyDialog(mdFileName: 'terms_and_services.md');
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Terms and Services',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  GestureDetector buildShare(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundsHandler().playTap();
        Share.share(
            "Hi Friends! I'm playing SgLvlUp! Come join me at https://www.xplorers.com.sg/about-2");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Share this App',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = "Check out SGLVLUP app!";

    /*Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
    */
  }

  GestureDetector buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SoundsHandler().playTap();
        Future.delayed(Duration(seconds: 1), () {
          UserPreferences.clearSession();
          SoundsHandler().pause();
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => LoginPage(),
            ),
            (route) => false,
          );
          //Navigator.pop(context);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Logout',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

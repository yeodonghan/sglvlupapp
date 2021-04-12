
import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/information_tab/accountform.dart';
import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:SGLvlUp/shared/User.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InformationWidget extends StatefulWidget{
  final UserProfile user;

  InformationWidget(this.user);

  @override
  _InformationWidgetState createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  BannerAd _ad;
  bool isLoaded;


  @override
  void initState() {
    print(widget.user.toString());
    // TODO: implement initState
    _ad = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.fullBanner,
        listener: AdListener(
            onAdLoaded: (_) {
              setState(() {
                isLoaded = true;
              });
            },
            onAdFailedToLoad: (_, error){
              print('Ad Fail to Load with Error: $error');
            }
        )
    );

    _ad.load();
    super.initState();
  }

  @override
  void dispose() {
    _ad?.dispose();
    print("Ads Disposed");
    super.dispose();
  }

  Widget checkForAd() {
    if(isLoaded == true) {
      return Container(
        child: AdWidget(
          ad: _ad,
        ),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container (

      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background/informationBG.png'),
            fit: BoxFit.cover
        ),
      ),

      child: Scaffold(
          resizeToAvoidBottomInset: false,

          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Profile'),
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(0),
              child:

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.04,
                                    ),
                                  ],
                                ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        height: MediaQuery.of(context).size.height * 0.15,
                                        width: MediaQuery.of(context).size.height * 0.15,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(widget.user.user_pictureurl)
                                            )
                                        ),
                                      ),

                                    ]
                                ),

                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    MyAccountForm(widget.user),
                                  ],

                                ),
                              ],
                            ),
                          ),
                        ),
                        checkForAd()
                      ],
              )
          )
      ),

      //bottomNavigationBar: NavBar(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );





  }

}
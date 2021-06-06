import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/information_tab/accountform.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InformationWidget extends StatefulWidget {
  final UserProfile user;

  InformationWidget({Key key, @required this.user}) : super(key: key);

  @override
  _InformationWidgetState createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  BannerAd _bannerAd;
  bool isLoaded = true;

  @override
  void initState() {

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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
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
                title: Text('Profile'),
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(0),
                  child: Column(
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
                                    height:
                                        MediaQuery.of(context).size.height * 0.04,
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      height:
                                          MediaQuery.of(context).size.height * 0.15,
                                      width:
                                          MediaQuery.of(context).size.height * 0.15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                  widget.user.user_pictureurl))),
                                    ),
                                  ]),
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
                  ))),
        ),
      ),
    );
  }
}

import 'package:SGLvlUp/ads/ad_helper.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './categories_container.dart';

class CategoriesLayout extends StatefulWidget {

  final UserProfile user;

  CategoriesLayout(this.user);

  @override
  CategoriesLayoutState createState() => CategoriesLayoutState();

}

class CategoriesLayoutState extends State<CategoriesLayout>{

  BannerAd _ad;
  bool isLoaded;

  @override
  void initState() {
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
    super.dispose();
  }

  Widget checkForAd() {
    if(isLoaded == true) {
      return Container(
        padding: EdgeInsets.all(0),
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
    return Scaffold(
      backgroundColor: Color(0xff47443F),
      appBar: AppBar(
        backgroundColor: Color(0xff47443F),
        leading: BackButton(
          color: Color(0xFFFFC823),
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CategoriesContainer(widget.user),
            checkForAd(),
          ],
        ),
      ),
    );
  }

}

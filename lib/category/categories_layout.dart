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

class CategoriesLayoutState extends State<CategoriesLayout> {
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
    return Scaffold(
      backgroundColor: Color(0xff47443F),
      appBar: AppBar(
        backgroundColor: Color(0xff47443F),
        leading: BackButton(
          color: Color(0xFFFFC823),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(child: CategoriesContainer(widget.user)),
          checkForAd(),
        ],
      ),
    );
  }
}

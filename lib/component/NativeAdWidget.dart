// lib/component/NativeAdWidget.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../main.dart'; // To access authStore
import '../utils/constant.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/appWidget.dart';
import '../utils/colors.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!authStore.isPremiumUser) {
      _loadNativeBanner();
    }
  }

  void _loadNativeBanner() {
     _bannerAd = BannerAd(
      adUnitId: kReleaseMode
          ? 'ca-app-pub-2970306107465777/4585793055' 
          : 'ca-app-pub-3940256099942544/6300978111', // Test
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          print('Native Ad failed: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (authStore.isPremiumUser) return SizedBox.shrink();
    if (!_isLoaded) return SizedBox.shrink();

    // Bu tasarım lib/component/ItemWidget.dart ve lib/component/CategoryItemWidget.dart 
    // ile birebir uyumlu olacak şekilde yapılmıştır.
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        // Reklam tıklandığında AdMob zaten hallediyor.
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Reklam alanı (Görsel alanı gibi davranır)
              Container(
                width: 105,
                height: 140,
                decoration: boxDecorationWithRoundedCornersWidget(
                  backgroundColor: context.dividerColor.withOpacity(0.1),
                  borderRadius: radius(defaultRadius),
                ),
                child: ClipRRect(
                  borderRadius: radius(defaultRadius),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
              // Sponsorlu Etiketi
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(defaultRadius.toDouble()),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                  child: Text('AD', style: primaryTextStyle(color: Colors.white, size: 8, weight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(
                       color: primaryColor.withOpacity(0.1),
                       borderRadius: radius(4),
                     ),
                     child: Text("Sponsorlu", style: boldTextStyle(size: 10, color: primaryColor)),
                   ),
                   Icon(Icons.more_horiz, size: 16, color: context.dividerColor),
                ],
              ),
              4.height,
              Text(
                "Harika Bir Öneri Senin İçin!", // Reklam başlığı simülasyonu
                maxLines: 2, 
                overflow: TextOverflow.ellipsis, 
                style: boldTextStyle()
              ),
              8.height,
              Text(
                "İlgini çekebilecek bu içeriğe göz atmak için tıkla. Sponsorlu reklamlar uygulamamızı geliştirmemize yardımcı olur.",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                maxLines: 3,
                style: secondaryTextStyle(size: 13)
              ).paddingRight(16),
            ],
          ).expand()
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 12),
    );
  }
}


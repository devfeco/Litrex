// lib/component/NativeAdWidget.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
    _loadRealBanner();
  }

  void _loadRealBanner() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-2970306107465777/4585793055', // SƏNİN ORİJİNAL ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('REAL BANNER YÜKLƏNDİ!');
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          print('XƏTA: $err');
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Başlıq
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Icon(Icons.menu_book, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Tövsiyə olunan kitab', style: TextStyle(fontWeight: FontWeight.w600)),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                    child: Text('Ad', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ],
              ),
            ),

            // REAL BANNER
            if (_isLoaded)
              Container(
                width: double.infinity,
                height: 50,
                child: AdWidget(ad: _bannerAd!),
              )
            else
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.grey[200],
                child: Center(child: Text('Reklam yüklənir...', style: TextStyle(fontSize: 12))),
              ),
          ],
        ),
      ),
    );
  }
}
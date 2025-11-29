import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/colors.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';

class PDFViewerComponent extends StatefulWidget {
  static String tag = '/PDFViewerComponent';
  final String url;
  final String title;
  final bool isAdsLoad;

  const PDFViewerComponent({
    required this.url,
    required this.title,
    this.isAdsLoad = false,
  });

  @override
  PDFViewerComponentState createState() => PDFViewerComponentState();
}

class PDFViewerComponentState extends State<PDFViewerComponent> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;

  int lastPageNumber = 0;
  bool isHorizontal = false;
  bool isPrefsLoaded = false;

  // Rewards Ads
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  int _freePagesLeft = 0;   // Mükafatdan sonra pulsuz səhifələr
  int _skipCount = 0;       // "Sonra" basma sayı
  final int MAX_SKIPS = 3;  // Maksimum "Sonra" sayısı

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadViewerSettings();
    _loadRewardedAd();
  }

  /// SharedPreferences-dən yüklə
  Future<void> _loadViewerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lastPageNumber = prefs.getInt('pdf_last_page_${widget.url}') ?? 0;
      isHorizontal = prefs.getBool('pdf_is_horizontal_${widget.url}') ?? false;
      _freePagesLeft = prefs.getInt('pdf_free_pages_${widget.url}') ?? 0;
      _skipCount = prefs.getInt('pdf_skip_count_${widget.url}') ?? 0;
      isPrefsLoaded = true;
    });
  }

  /// SharedPreferences-ə yaz
  Future<void> _saveViewerSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pdf_last_page_${widget.url}', lastPageNumber);
    await prefs.setBool('pdf_is_horizontal_${widget.url}', isHorizontal);
    await prefs.setInt('pdf_free_pages_${widget.url}', _freePagesLeft);
    await prefs.setInt('pdf_skip_count_${widget.url}', _skipCount);
  }

  /// Rewarded Ad yüklə
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _getRewardAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          setState(() => _isAdLoaded = true);
        },
        onAdFailedToLoad: (error) {
          print('Rewarded Ad yüklenemedi: $error');
          _rewardedAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  String _getRewardAdUnitId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2970306107465777/7070208369'; // Test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-2970306107465777/7070208369'; // Test
    }
    return '';
  }

  /// Reklamı göstər
  void _showRewardedAd() {
    if (_rewardedAd == null || !_isAdLoaded) {
      toast("Reklam henüz hazır değil. Biraz bekleyin.");
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        setState(() {
          _freePagesLeft = 5;   // 5 sayfa reklamsız
          _skipCount = 0;       // Skip sayacını sıfırla
        });
        _saveViewerSettings();
        toast("Ödül kazandınız! Sonraki 5 sayfa reklamsız açılacak.");
      },
    );
  }

  /// Reklam təklifi dialogu
  void _showRewardDialog() {
    final bool canSkip = _skipCount < MAX_SKIPS;

    showDialog(
      context: context,
      barrierDismissible: canSkip,
      builder: (context) => WillPopScope(
        onWillPop: () async => canSkip,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(canSkip ? "Reklam İzle" : "Reklam İzlemek Zorunlu"),
          content: Text(
            canSkip
                ? "Reklam izlerseniz sonraki 5 sayfa reklamsız açılacak.\n"
                "($MAX_SKIPS kezden $_skipCount kez geçtiniz)"
                : "Artık $MAX_SKIPS kez geçtiniz. Reklam izlemeden devam edemezsiniz.",
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            if (canSkip)
              TextButton(
                onPressed: () {
                  setState(() => _skipCount++);
                  _saveViewerSettings();
                  Navigator.pop(context);
                },
                child: const Text("Sonra", style: TextStyle(color: Colors.grey)),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () {
                Navigator.pop(context);
                _showRewardedAd();
              },
              child: Text(
                canSkip ? "Reklam İzle" : "Reklam İzle & Devam Et",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Metin seçildiğinde “Kopyala” popup
  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
    _overlayEntry?.remove();
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.center.dx - 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          child: const Text('Kopyala', style: TextStyle(fontSize: 14, color: Colors.white)),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText.validate()));
            _pdfViewerController.clearSelection();
            _overlayEntry?.remove();
            _overlayEntry = null;
          },
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _saveViewerSettings();
    _rewardedAd?.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPrefsLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: primaryColor,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isHorizontal ? Icons.swap_vert : Icons.swap_horiz),
            tooltip: isHorizontal ? "Dikey Okuma" : "Yatay Okuma",
            onPressed: () {
              setState(() => isHorizontal = !isHorizontal);
              _saveViewerSettings();
            },
          ),
        ],
      ),
      bottomNavigationBar: mWebBannerAds == '1' ? showBannerAds() : const SizedBox(),
      body: SfPdfViewer.network(
        widget.url.validate(),
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        initialPageNumber: lastPageNumber == 0 ? 1 : lastPageNumber,
        scrollDirection: isHorizontal ? PdfScrollDirection.horizontal : PdfScrollDirection.vertical,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        enableTextSelection: true,
        otherSearchTextHighlightColor: primaryColor,
        currentSearchTextHighlightColor: primaryColor,
        canShowPaginationDialog: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) => toast(details.description),
        onTextSelectionChanged: (details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
          }
        },
        onPageChanged: (details) {
          lastPageNumber = details.newPageNumber;
          _saveViewerSettings();

          // İlk 10 sayfa reklamsız, sonra her 5 sayfa kontrol
          if (details.newPageNumber <= 10) return;

          if (_freePagesLeft <= 0 && details.newPageNumber % 5 == 0) {
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) _showRewardDialog();
            });
          } else if (_freePagesLeft > 0) {
            setState(() => _freePagesLeft--);
            _saveViewerSettings();
          }
        },
      ),
    );
  }
}
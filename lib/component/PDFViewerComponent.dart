import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';      // <<< SON SAYFA KAYDI İÇİN

import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';

class PDFViewerComponent extends StatefulWidget {
  static String tag = '/PDFViewerComponent';
  final String url;
  final String title;
  final bool isAdsLoad;
  final Uint8List? fileBytes;

  PDFViewerComponent({required this.url, required this.title, this.isAdsLoad = false, this.fileBytes});

  @override
  PDFViewerComponentState createState() => PDFViewerComponentState();
}

class PDFViewerComponentState extends State<PDFViewerComponent> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController? _pdfViewerController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    print("PDF Path=>" + widget.url);
    _pdfViewerController = PdfViewerController();

    /// 🔥 PDF yeniden açıldığında son kaldığın sayfaya otomatik gider
    // Use URL or a unique ID for local files if possible, here using URL as key fallback
    String key = widget.fileBytes != null ? "local_${widget.title}" : widget.url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // We can use the title or a passed ID for local files to store page num
    int? lastPage = prefs.getInt("last_page_$key"); 

    Future.delayed(Duration(seconds: 1), () {  // PDF tam yüklənsin deyə 1 saniyə gecikmə
      if (lastPage != null && lastPage > 1) {
        _pdfViewerController!.jumpToPage(lastPage);
        print("📌 Son kaldığın sayfaya gidildi ➜ $lastPage");
      }
    });
  }


  /// 🔥 Metin seçilince kopyalama menüsü
  void _showContextMenu(BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState? _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
            child: Text('Copy', style: TextStyle(fontSize: 16)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: details.selectedText.validate()));
              _pdfViewerController!.clearSelection();
            }),
      ),
    );
    _overlayState!.insert(_overlayEntry!);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.title,textSize: 18, color: primaryColor, textColor: Colors.white, showBack: true),
      bottomNavigationBar: mWebBannerAds == '1' ? showBannerAds() : SizedBox(),

      body: widget.fileBytes != null
        ? SfPdfViewer.memory(
            widget.fileBytes!,
            key: _pdfViewerKey,
            controller: _pdfViewerController,
            otherSearchTextHighlightColor: primaryColor,
            enableTextSelection: true,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            scrollDirection: PdfScrollDirection.vertical,
            canShowPaginationDialog: true,
            canShowScrollStatus: true,
            onPageChanged: (PdfPageChangedDetails details) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt("last_page_local_${widget.title}", details.newPageNumber);
              print("💾 Son sayfa kaydedildi: ${details.newPageNumber}");
            },
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry!.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null && _overlayEntry == null) {
                _showContextMenu(context, details);
              }
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              toast(details.description);
            },
          )
        : SfPdfViewer.network(
        widget.url.validate(),
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        otherSearchTextHighlightColor: primaryColor,
        enableTextSelection: true,
        pageLayoutMode: PdfPageLayoutMode.continuous,
        scrollDirection: PdfScrollDirection.vertical,
        canShowPaginationDialog: true,
        canShowScrollStatus: true,

        /// 🔥 Her sayfa değiştiğinde kaydet — Sonra tekrar açınca kaldığın yerden devam eder
        onPageChanged: (PdfPageChangedDetails details) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("last_page_${widget.url}", details.newPageNumber); // Her PDF'e özel kayıt
          print("💾 Son sayfa kaydedildi: ${details.newPageNumber}");
        },

        /// 🔥 Metin seçimi popup
        onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
          if (details.selectedText == null && _overlayEntry != null) {
            _overlayEntry!.remove();
            _overlayEntry = null;
          } else if (details.selectedText != null && _overlayEntry == null) {
            _showContextMenu(context, details);
          }
        },

        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          toast(details.description);
        },
      ),
    );
  }
}

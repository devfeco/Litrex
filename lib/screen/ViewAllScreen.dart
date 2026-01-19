import '../component/ItemWidget.dart';
import '../network/RestApis.dart';
import '../screen/BookDetailScreen.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/colors.dart';

class ViewAllScreen extends StatefulWidget {
  static String tag = '/ViewAllScreen';
  final int? categoryId;
  final bool? isFeatured;
  final bool? isPopular;
  final bool? isSuggested;
  final bool? isLatest;
  final String? title;
  final bool? isCategory;

  ViewAllScreen({this.categoryId, this.title, this.isFeatured = false, this.isLatest = false, this.isCategory = false, this.isPopular = false, this.isSuggested = false});

  @override
  ViewAllScreenState createState() => ViewAllScreenState();
}

class ViewAllScreenState extends State<ViewAllScreen> {
  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isLastPage = false;

  List<Book> mBookList = [];
  List<String> mCategoryId = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      scrollHandler();
    });
    FacebookAudienceNetwork.init(
      testingId: FACEBOOK_KEY,
      iOSAdvertiserTrackingEnabled: true,
    );
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') loadInterstitialAds();
    } else {
      if (mViewAllInterstitialAds == '1') loadInterstitialAds();
    }
  }

  init() async {
    getAPI();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      init();
    }
  }

  @override
  void dispose() {
    if (widget.isCategory == true) {
      if (mCategoryViewAllInterstitialAds == '1') {
        if (mAdShowCategoryListCount < int.parse(adsInterval)) {
          mAdShowCategoryListCount++;
        } else {
          mAdShowCategoryListCount = 0;
          showInterstitialAds();
        }
      }
    } else {
      if (mViewAllInterstitialAds == '1') {
        if (mAdShowBookListCount < int.parse(adsInterval)) {
          mAdShowBookListCount++;
        } else {
          mAdShowBookListCount = 0;
          showInterstitialAds();
        }
      }
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  loadData(List<Book> value) {
    if (!mounted) return;
    setState(() {
      appStore.setLoading(false);
      isLastPage = false;
      if (currentPage == 1) {
        mBookList.clear();
      }
      mBookList.addAll(value);
    });
  }

  catchData() {
    if (!mounted) return;
    isLastPage = true;
    appStore.setLoading(false);
  }

  getAPI() {
    appStore.setLoading(true);
    if (widget.isFeatured == true) {
      return getFilterBooks(isFeature: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isPopular == true) {
      return getFilterBooks(isPopular: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isSuggested == true) {
      List<String>? mIdList = getStringListAsync(chooseTopicList);
      mIdList!.forEach((element) {
        mCategoryId.add(element);
      });
      return getFilterBooks(list: mCategoryId, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else if (widget.isCategory == true) {
      return getFilterBooks(isCategory: true, categoryId: widget.categoryId, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    }
    if (widget.isLatest == true) {
      return getFilterBooks(isLatest: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    } else {
      return getFilterBooks(isFeature: true, page: currentPage).then((value) {
        loadData(value);
      }).catchError((e) {
        catchData();
        toast(e.toString());
      });
    }
  }

  getTitle() {
    if (widget.isFeatured == true) {
      return language.lblFeatured;
    } else if (widget.isPopular == true) {
      return language.lblPopular;
    } else if (widget.isSuggested == true) {
      return widget.title!;
    } else
      return widget.title!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(getTitle(), color: primaryColor, textColor: Colors.white, showBack: true),
        bottomNavigationBar: widget.isCategory == true
            ? mCategoryViewAllBannerAds == '1'
                ? showBannerAds()
                : SizedBox()
            : mViewAllBannerAds == '1'
                ? showBannerAds()
                : SizedBox(),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mBookList.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (_, i) {
                  return ItemWidget(
                    mBookList[i],
                    onTap: () async {
                      BookDetailScreen(data: mBookList[i]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                  );
                },
              ),
            ),
            if (!appStore.isLoading && mBookList.isEmpty) noDataWidget(context).center(),
            mProgress().center().visible(appStore.isLoading),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../component/NoInternetComponent.dart';
import '../component/ItemWidget.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../screen/CategoryScreen.dart';
import '../screen/ViewAllScreen.dart';
import '../utils/Extensions/Colors.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/colors.dart';
import '../component/AuthorComponent.dart';
import '../component/CategoryItemWidget.dart';
import '../component/HomeSliderComponent.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/HorizontalList.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/appWidget.dart';
import '../utils/constant.dart';
import 'AuthorDetailScreen.dart';
import 'AuthorListScreen.dart';
import 'BookDetailScreen.dart';
import 'SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<Category> mCategoryList = [];
  List<Book> mPopularList = [];
  List<Book> mLatestList = [];
  List<Book> mFeaturedList = [];
  List<Book> mSuggestedList = [];
  List<String> mCategoryId = [];
  List<AppSlider> mSliderList = [];
  List<Author> mAuthorList = [];

  int? currentIndex = 0;
  bool? isLoading = true;
  String? mErrorMsg = "";

  PageController? pageController;

  // --- Reklam dəyişənləri ---
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  double _bannerHeight = 0;

  @override
  void initState() {
    super.initState();
    init();
    _loadAdaptiveBanner();
  }

  Future<void> _loadAdaptiveBanner() async {
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) return;

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-2970306107465777/7229016697',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
            _bannerHeight = size.height.toDouble();
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Adaptive Banner failed to load: $err');
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

  init() async {
    List<String>? mIdList = getStringListAsync(chooseTopicList);

    mIdList!.forEach((element) {
      mCategoryId.add(element);
    });

    getFilterBooks(list: mCategoryId).then((res) {
      mSuggestedList = res;
      setState(() {});
    });

    getDashboard().then((res) {
      mSliderList = res.slider!;
      mPopularList = res.popularBook!;
      mLatestList = res.latestBook!;
      mFeaturedList = res.featuredBook!;
      mCategoryList = res.category!;
      mAuthorList = res.author!;
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      isLoading = false;
      mErrorMsg = e.toString();
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeading(String title,
      {int? id,
        bool? isFeatured = false,
        bool? isLatest = false,
        bool? isPopular = false,
        bool? isSuggested = false,
        bool? isCategory = false,
        bool? isCategoryViewAll = false,
        bool? isAuthor = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: boldTextStyle(
                size: 20,
                fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500)
                    .fontFamily)),
        IconButton(
          onPressed: () {
            if (isCategoryViewAll == true) {
              CategoryScreen(isCategory: true).launch(context);
            } else if (isAuthor == true) {
              AuthorListScreen().launch(context);
            } else {
              ViewAllScreen(
                categoryId: id,
                title: title,
                isLatest: isLatest,
                isFeatured: isFeatured,
                isCategory: isCategory,
                isSuggested: isSuggested,
                isPopular: isPopular,
              ).launch(context);
            }
          },
          icon: Icon(Icons.keyboard_arrow_right, color: textSecondaryColor),
        ),
      ],
    ).paddingOnly(left: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 28),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        title: Text(AppName,
            style: boldTextStyle(size: 20, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Ionicons.search_sharp, color: Colors.white),
            onPressed: () {
              SearchScreen().launch(context);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          init();
          setState(() {});
        },
        child: Stack(
          children: [
            // Əsas məzmun
            isLoading == false
                ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider
                  if (mSliderList.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: context.height() * 0.25,
                          width: context.width(),
                          child: PageView.builder(
                            itemCount: mSliderList.length,
                            controller: pageController,
                            itemBuilder: (context, i) {
                              return HomeSliderComponent(mSliderList[i]);
                            },
                            onPageChanged: (int i) {
                              currentIndex = i;
                              setState(() {});
                            },
                          ),
                        ),
                        dotIndicator(mSliderList, currentIndex)
                            .paddingTop(8),
                      ],
                    ),

                  // Latest
                  if (mLatestList.isNotEmpty)
                    Column(
                      children: [
                        mHeading(language.lblLatest, isLatest: true),
                        HorizontalList(
                          itemCount: mLatestList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          itemBuilder: (context1, index) {
                            return ItemWidget(
                              mLatestList[index],
                              isFeatured: true,
                              onTap: () async {
                                BookDetailScreen(data: mLatestList[index])
                                    .launch(context,
                                    pageRouteAnimation:
                                    PageRouteAnimation.Slide);
                              },
                            );
                          },
                        ),
                        16.height,
                      ],
                    ),

                  // Category
                  if (mCategoryList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mHeading(language.lblCategory,
                            isCategory: true, isCategoryViewAll: true),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 12,
                          spacing: 10,
                          children: List.generate(
                            mCategoryList.length > 6
                                ? 6
                                : mCategoryList.length,
                                (index) {
                              return AnimationConfiguration.staggeredGrid(
                                duration: Duration(milliseconds: 750),
                                columnCount: 1,
                                position: index,
                                child: CategoryItemWidget(
                                  mCategoryList[index],
                                  onTap: () {
                                    ViewAllScreen(
                                      title: mCategoryList[index].name,
                                      categoryId:
                                      mCategoryList[index].id.toInt(),
                                      isCategory: true,
                                    ).launch(context);
                                  },
                                ),
                              );
                            },
                          ),
                        ).paddingOnly(left: 14, right: 12, bottom: 16)
                      ],
                    ),

                  // Popular
                  if (mPopularList.isNotEmpty)
                    Column(
                      children: [
                        mHeading(language.lblPopular, isPopular: true),
                        HorizontalList(
                          itemCount: mPopularList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          itemBuilder: (context1, index) {
                            return ItemWidget(
                              mPopularList[index],
                              isFeatured: true,
                              onTap: () async {
                                BookDetailScreen(data: mPopularList[index])
                                    .launch(context,
                                    pageRouteAnimation:
                                    PageRouteAnimation.Slide);
                              },
                            );
                          },
                        ),
                        16.height,
                      ],
                    ),

                  // Featured
                  if (mFeaturedList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mHeading(language.lblFeatured, isFeatured: true),
                        HorizontalList(
                          itemCount: mFeaturedList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          itemBuilder: (context1, index) {
                            return ItemWidget(
                              mFeaturedList[index],
                              isFeatured: true,
                              onTap: () async {
                                BookDetailScreen(data: mFeaturedList[index])
                                    .launch(context,
                                    pageRouteAnimation:
                                    PageRouteAnimation.Slide);
                              },
                            );
                          },
                        ),
                        16.height,
                      ],
                    ),

                  // Suggested
                  if (mSuggestedList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mHeading(language.lblSuggested,
                            isSuggested: true),
                        HorizontalList(
                          itemCount: mSuggestedList.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 0),
                          itemBuilder: (context1, index) {
                            return ItemWidget(
                              mSuggestedList[index],
                              isFeatured: true,
                              onTap: () async {
                                BookDetailScreen(data: mSuggestedList[index])
                                    .launch(context,
                                    pageRouteAnimation:
                                    PageRouteAnimation.Slide);
                              },
                            );
                          },
                        ),
                        16.height,
                      ],
                    ),

                  // Authors
                  if (mAuthorList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mHeading(language.lblAuthors, isAuthor: true),
                        HorizontalList(
                          itemCount: mAuthorList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context1, index) {
                            return AuthorComponent(
                              mAuthorList[index],
                              isSlider: true,
                              onTap: () async {
                                AuthorDetailScreen(mAuthorList[index])
                                    .launch(context,
                                    pageRouteAnimation:
                                    PageRouteAnimation.Slide);
                              },
                            );
                          },
                        ),
                        16.height,
                      ],
                    ),

                  // Banner üçün boşluq
                  SizedBox(height: _isBannerAdLoaded ? _bannerHeight : 0),
                ],
              ),
            )
                : mProgress(),

            // --- Adaptive Banner (sabit alt hissədə) ---
            if (_isBannerAdLoaded && _bannerAd != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),

            // İnternet yoxdur
            wishListStore.isNetworkAvailable
                ? Offstage()
                : NoInternetComponent().center(),

            // Xəta mesajı
            if (mErrorMsg != null && mErrorMsg!.isNotEmpty && isLoading == false)
              Text(mErrorMsg!, style: primaryTextStyle()).center(),
          ],
        ),
      ),
    );
  }
}
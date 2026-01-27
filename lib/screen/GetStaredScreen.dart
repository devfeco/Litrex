import 'package:flutter/material.dart';
import '../screen/ChooseTopicScreen.dart';
import '../screen/auth/LoginScreen.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/constant.dart';
import 'WebViewScreen.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class GetStaredScreen extends StatefulWidget {
  static String tag = '/GetStaredScreen';

  @override
  GetStaredScreenState createState() => GetStaredScreenState();
}

class GetStaredScreenState extends State<GetStaredScreen> {
  List<Widget> pages = [];
  var selectedIndex = 0;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  init() async {
    pages = [
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ic_walk1, height: context.height() * 0.4, fit: BoxFit.contain).paddingAll(24),
            20.height,
            Text(language.lblWalk1, style: boldTextStyle(size: 24)).paddingOnly(top: 16, left: 16),
            Text(language.lblWalk1Desc, textAlign: TextAlign.center, style: secondaryTextStyle(size: 16)).paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ic_walk2, height: context.height() * 0.4, fit: BoxFit.contain).paddingAll(24),
            20.height,
            Text(language.lblWalk2, style: boldTextStyle(size: 24)).paddingOnly(top: 16, left: 16),
            Text(language.lblWalk2Desc, textAlign: TextAlign.center, style: secondaryTextStyle(size: 16)).paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ic_walk3, height: context.height() * 0.4, fit: BoxFit.contain).paddingAll(24),
            20.height,
            Text(language.lblWalk3, style: boldTextStyle(size: 24)).paddingOnly(top: 16, left: 16),
            Text(language.lblWalk3Desc, textAlign: TextAlign.center, style: secondaryTextStyle(size: 16)).paddingOnly(right: 24, left: 16, top: 8)
          ],
        ),
      )
    ];
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    appStore.setNotification(true);
    // Login ekranına git
    LoginScreen().launch(context, isNewTask: true);
  }

  @override
  Widget build(BuildContext context) {
    init();

    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        children: [
          PageView(
              children: pages,
              controller: _pageController,
              onPageChanged: (index) {
                selectedIndex = index;
                setState(() {});
              }),
          AnimatedPositioned(duration: Duration(seconds: 1), bottom: 70, left: 0, right: 0, child: dotIndicator(pages, selectedIndex)),
          Positioned(
              child: AnimatedCrossFade(
                  firstChild: Container(
                    child: Text(language.lblGetStarted, style: boldTextStyle(color: Colors.white)),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: radius(8),
                    ),
                  ).onTap(_onGetStarted),
                  secondChild: SizedBox(),
                  duration: Duration(milliseconds: 300),
                  firstCurve: Curves.easeIn,
                  secondCurve: Curves.easeOut,
                  crossFadeState: selectedIndex == (pages.length - 1) ? CrossFadeState.showFirst : CrossFadeState.showSecond),
              bottom: 20,
              right: 20),
          if (selectedIndex == (pages.length - 1))
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (getStringAsync(PRIVACY_POLICY_PREF).isNotEmpty) {
                    WebViewScreen(title: language.lblPrivacyPolicy, mInitialUrl: getStringAsync(PRIVACY_POLICY_PREF)).launch(context);
                  } else {
                    toast(language.lblUrlEmpty);
                  }
                },
                child: Text(
                  language.lblPrivacyPolicy,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle(size: 11, decoration: TextDecoration.underline),
                ),
              ),
            ),
          Positioned(
              child: AnimatedContainer(duration: Duration(seconds: 1), child: Text(language.lblSkip, style: boldTextStyle(color: primaryColor)), padding: EdgeInsets.fromLTRB(16, 8, 16, 8)).onTap(_onGetStarted),
              right: 8,
              top: context.statusBarHeight + 8)
        ],
      ),
    );
  }
}

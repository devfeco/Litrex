import 'dart:ui';
import '../../screen/ChooseTopicScreen.dart';
import '../utils/Extensions/context_extensions.dart';
import '../main.dart';
import '../screen/GetStaredScreen.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/constant.dart';
import '../utils/images.dart';
import 'package:flutter/material.dart';
import '../utils/Extensions/shared_pref.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import 'DashboardScreen.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await 2.seconds.delay;
    bool seen = (getBoolAsync('isFirstTime'));
    if (seen) {
      if (getStringListAsync(chooseTopicList) != null) {
        DashboardScreen().launch(context, isNewTask: true);
      } else {
        ChooseTopicScreen(isVisibleBack: false).launch(context,isNewTask: true);
      }
    } else {
      await setValue('isFirstTime', true);
      GetStaredScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (getIntAsync(THEME_MODE_INDEX) == appThemeMode.themeModeSystem) {
      log(getIntAsync(THEME_MODE_INDEX));
      appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
    }
    window.onPlatformBrightnessChanged = () async {
      log(getIntAsync(THEME_MODE_INDEX));
      if (getIntAsync(THEME_MODE_INDEX) == appThemeMode.themeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.light);
      }
    };
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(child: Image.asset(ic_logo, fit: BoxFit.fill, color: Colors.white, width: 100, height: 100)),
          16.height,
          Text(AppName, style: boldTextStyle(size: 26, color: Colors.white)),
        ],
      ).center(),
    );
  }
}

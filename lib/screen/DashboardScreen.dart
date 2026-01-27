import '../network/AuthApis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../component/PDFViewerComponent.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../screen/BookmarkScreen.dart';
import '../utils/Extensions/context_extensions.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/colors.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import 'CategoryScreen.dart';
import 'HomeScreen.dart';
import 'auth/ProfileScreen.dart';
import 'WebViewScreen.dart';
import '../main.dart'; // Ensure main is imported for authStore

class DashboardScreen extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final tab = [
    HomeScreen(),
    CategoryScreen(),
    BookmarkScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (isMobile) {
      OneSignal.Notifications.addClickListener((notification) {
        if (notification.notification.launchUrl != null && !notification.notification.launchUrl!.isEmptyOrNull) {
          if (!notification.notification.launchUrl!.contains(".pdf")) {
            WebViewScreen(title: notification.notification.title.validate(),mInitialUrl: notification.notification.launchUrl).launch(context);
          } else {
            PDFViewerComponent(title: notification.notification.title.validate(),url: notification.notification.launchUrl!).launch(context);
          }
        }
      });
    }

    // Kullanıcı giriş yapmışsa profil bilgilerini güncelle (Premium durumu için önemli)
    if (authStore.isLoggedIn) {
      getProfile().then((value) {
        authStore.setUser(value);
      }).catchError((e) {
        print("Profil senkronizasyon hatası: $e");
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mLine() {
    return Container(
      height: 3,
      margin: EdgeInsets.only(top: 6),
      width: 20,
      decoration: boxDecorationWithShadowWidget(boxShape: BoxShape.rectangle, backgroundColor: primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: tab[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: context.scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedLabelStyle: primaryTextStyle(),
        currentIndex: _currentIndex,
        unselectedItemColor: unSelectIconColor,
        selectedItemColor: primaryColor,
        onTap: (index) {
          _currentIndex = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Ionicons.md_book_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.book, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.md_grid_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.md_grid, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.ios_bookmarks_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.bookmarks, size: 22), mLine()]), label: ""),
          BottomNavigationBarItem(icon: Icon(Ionicons.person_outline, size: 20), activeIcon: Column(children: [Icon(Ionicons.person, size: 22), mLine()]), label: ""),
        ],
      ),
    );
  }
}

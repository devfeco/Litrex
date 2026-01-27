import 'package:flutter/cupertino.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../screen/AuthorListScreen.dart';
import '../screen/ChooseTopicScreen.dart';
import '../screen/SelectThemeScreen.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/Extensions/string_extensions.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../component/SettingItemWidget.dart';
import '../main.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/device_extensions.dart';
import '../utils/Extensions/shared_pref.dart';
import 'AboutUsScreen.dart';
import 'LanguageScreen.dart';
import 'WebViewScreen.dart';
import '../network/AuthApis.dart';
import 'auth/LoginScreen.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';
  final Function onTap;

  const SettingScreen({required this.onTap});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    FacebookAudienceNetwork.init(testingId: FACEBOOK_KEY, iOSAdvertiserTrackingEnabled: true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget mLeadingWidget(var icon) {
    return Icon(icon, color: textPrimaryColorGlobal);
  }

  Widget mTailingIcon() {
    return Icon(
      Icons.chevron_right,
      color: textSecondaryColorGlobal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblSetting, color: primaryColor, textColor: Colors.white, showBack: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingItemWidget(
              title: language.lblAuthors,
              trailing: mTailingIcon(),
              subTitle: language.lblAuthorsDes,
              leading: mLeadingWidget(Feather.users),
              onTap: () async {
                AuthorListScreen().launch(context);
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblChooseTopic,
              trailing: mTailingIcon(),
              subTitle: language.lblChooseTopicTitle,
              leading: mLeadingWidget(MaterialCommunityIcons.checkbox_marked_outline),
              onTap: () async {
                ChooseTopicScreen().launch(context);
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblSelectTheme,
              subTitle: language.lblChooseTheme,
              onTap: () async {
                bool res = await SelectThemeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                if (res == true) setState(() {});
                widget.onTap.call();
              },
              trailing: mTailingIcon(),
              leading: mLeadingWidget(MaterialCommunityIcons.theme_light_dark),
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblLanguage,
              subTitle: language.lblLanguageDesc,
              leading: Icon(Ionicons.language_outline),
              trailing: mTailingIcon(),
              onTap: () async {
                bool res = await LanguageScreen().launch(context);
                if (res == true) setState(() {});
              },
            ),
            Divider(height: 0),
            SettingItemWidget(
              title: language.lblPushNotification,
              subTitle: language.lblDisableNotification,
              leading: mLeadingWidget(Ionicons.md_notifications_outline),
              onTap: () async {},
              trailing: Transform.scale(
                scale: 0.8,
                child: CupertinoSwitch(
                  activeColor: primaryColor,
                  value: appStore.isNotificationOn,
                  onChanged: (v) {
                    appStore.setNotification(v);
                    setState(() {});
                  },
                ).withHeight(10),
              ),
            ),
            16.height,
            Divider(thickness: 3).paddingOnly(left: 16, right: 16),
            16.height,
            Row(
              children: [
                Container(color: primaryColor, width: 4, height: 16),
                6.width,
                Text(language.lblOthers, style: boldTextStyle(color: primaryColor, size: 14)),
              ],
            ).paddingOnly(left: 16, right: 16, bottom: 4),
            SettingItemWidget(
              title: language.lblRateUs,
              trailing: mTailingIcon(),
              onTap: () {
                PackageInfo.fromPlatform().then((value) {
                  String package = '';
                  if (isAndroid) package = value.packageName;
                  launch('${storeBaseURL()}$package');
                });
              },
            ),
            SettingItemWidget(
              title: language.lblPrivacyPolicy,
              trailing: mTailingIcon(),
              onTap: () {
                if (getStringAsync(PRIVACY_POLICY_PREF).isNotEmpty)
                  WebViewScreen(title:language.lblPrivacyPolicy,mInitialUrl: getStringAsync(PRIVACY_POLICY_PREF)).launch(context);
                else
                  toast(language.lblUrlEmpty);
              },
            ).visible(!getStringAsync(PRIVACY_POLICY_PREF).isEmptyOrNull),
            SettingItemWidget(
              title: language.lblTermsCondition,
              trailing: mTailingIcon(),
              onTap: () async {
                if (getStringAsync(TERMS_AND_CONDITION_PREF).isNotEmpty)
                  WebViewScreen(title:language.lblTermsCondition ,mInitialUrl: getStringAsync(TERMS_AND_CONDITION_PREF)).launch(context);
                else
                  toast(language.lblUrlEmpty);
              },
            ).visible(!getStringAsync(TERMS_AND_CONDITION_PREF).isEmptyOrNull),
            SettingItemWidget(
              title: language.lblAboutUs,
              trailing: mTailingIcon(),
              onTap: () {
                AboutUsScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
              },
            ),
            
            // Hesap Yönetimi (Sadece giriş yapılmışsa)
            if (authStore.isLoggedIn) ...[
              16.height,
              Divider(thickness: 3).paddingOnly(left: 16, right: 16),
              16.height,
              Row(
                children: [
                  Container(color: Colors.red, width: 4, height: 16),
                  6.width,
                  Text(language.lblDeleteAccount, style: boldTextStyle(color: Colors.red, size: 14)),
                ],
              ).paddingOnly(left: 16, right: 16, bottom: 4),
              SettingItemWidget(
                title: language.lblDeleteAccount,
                subTitle: language.lblDeleteAccountWarning,
                leading: Icon(Ionicons.trash_outline, color: Colors.red),
                titleTextStyle: boldTextStyle(color: Colors.red),
                onTap: () {
                  // ProfileScreen'deki diyalogu buraya da taşıyabiliriz veya oraya yönlendirebiliriz.
                  // Şimdilik doğrudan silme akışını başlatalım (ProfileScreen'deki ile aynı)
                  _showDeleteAccountDialog(context);
                },
              ),
            ],
            16.height,
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: radius(16)),
        title: Text(language.lblDeleteAccount, style: boldTextStyle(size: 18, color: Colors.red)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language.lblDeleteAccountWarning, style: primaryTextStyle(size: 14)),
            16.height,
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: language.lblPassword,
                hintText: language.lblEnterPasswordToConfirm,
                border: OutlineInputBorder(borderRadius: radius(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(language.lblCancel, style: primaryTextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (passwordController.text.isEmpty) {
                toast(language.lblPleaseEnterPassword);
                return;
              }
              
              Navigator.pop(context);
              
              try {
                final response = await deleteAccount(password: passwordController.text);
                
                if (response['success'] == true) {
                   await authStore.logout();
                   toast(language.lblAccountDeleted);
                   LoginScreen().launch(context, isNewTask: true);
                } else {
                  toast(response['message'] ?? language.lblSomethingWentWrong);
                }
              } catch (e) {
                toast(e.toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: radius(10)),
            ),
            child: Text(language.lblDelete, style: boldTextStyle(color: Colors.white, size: 14)),
          ),
        ],
      ),
    );
  }
}

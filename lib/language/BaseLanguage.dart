import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage? of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage);

  String get lblCategory;
  String get lblFavourite;
  String get lblPopular;
  String get lblLatest;
  String get lblFeatured;
  String get lblSuggested;
  String get lblAboutUs;
  String get lblPrivacyPolicy;
  String get lblTermsCondition;
  String get lblNoDataFound;
  String get lblNoInternet;
  String get lblRateUs;
  String get lblDarkMode;
  String get lblSystemDefault;
  String get lblLightMode;
  String get lblPushNotification;
  String get lblSearchBook;
  String get lblSetting;
  String get lblSeeMore;
  String get lblRemoveBookmark;
  String get lblTryAgain;
  String get lblReadBook;
  String get lblSelectTheme;
  String get lblChooseTopic;
  String get lblContinue;
  String get lblChooseTopicMsg;
  String get lblChooseTopicTitle;
  String get lblChooseTopicDesc;
  String get lblCancel;
  String get lblYes;
  String get lblUrlEmpty;
  String get lblChooseTheme;
  String get lblDisableNotification;
  String get lblOthers;
  String get lblBy;
  String get lblAuthors;
  String get lblAuthorsDes;
  String get lblAbout;
  String get lblBooksBy;
  String get lblDescription;
  String get lblRemove;
  String get lblWalk1;
  String get lblWalk1Desc;
  String get lblWalk2;
  String get lblWalk2Desc;
  String get lblWalk3;
  String get lblWalk3Desc;
  String get lblGetStarted;
  String get lblSkip;
  String get lblLanguage;
  String get lblLanguageDesc;

  // YENİ EKLENENLER
  String get lblSearchAuthor;
  String get lblNoAuthorsFound;
}
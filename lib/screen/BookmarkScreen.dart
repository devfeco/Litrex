import '../component/NoInternetComponent.dart';
import '../main.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/Extensions/int_extensions.dart';
import '../utils/appWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../component/BookmarkComponent.dart';
import '../component/DialogComponent.dart';
import '../model/DashboardResponse.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/Constants.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/Extensions/text_styles.dart';
import '../utils/colors.dart';
import 'BookDetailScreen.dart';

class BookmarkScreen extends StatefulWidget {
  static String tag = '/FavouriteScreen';

  @override
  BookmarkScreenState createState() => BookmarkScreenState();
}

class BookmarkScreenState extends State<BookmarkScreen> {
  List<Book>? mList;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    mList = wishListStore.wishList;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: boxDecorationWithRoundedCornersWidget(backgroundColor: primaryColor.withOpacity(0.2), borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), bottomLeft: Radius.circular(defaultRadius))),
      margin: EdgeInsets.only(bottom: 16),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            20.width,
            Icon(Icons.delete, color: Colors.white),
            Text(" " + language.lblRemove, style: primaryTextStyle(size: 18, color: Colors.white), textAlign: TextAlign.right),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.lblFavourite, color: primaryColor, textColor: Colors.white, showBack: false),
      body: Observer(builder: (context) {
        return wishListStore.isNetworkAvailable
            ? wishListStore.wishList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: wishListStore.wishList.length,
                    padding: EdgeInsets.only(left: 12, right: 16, top: 16, bottom: 8),
                    itemBuilder: (_, i) {
                      return Dismissible(
                        key: Key(wishListStore.wishList[i].id.toString()),
                        secondaryBackground: SizedBox(),
                        background: slideLeftBackground(),
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            return showDialogBox(context, language.lblRemoveBookmark, onCancelCall: () {
                              finish(context);
                            }, onCall: () {
                              wishListStore.addToWishList(wishListStore.wishList[i]);
                              finish(context);
                            });
                          } else {
                            return null;
                          }
                        },
                        child: AnimationConfiguration.staggeredGrid(
                          position: i,
                          columnCount: 1,
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            verticalOffset: 20.0,
                            child: FadeInAnimation(
                              child: BookmarkComponent(
                                wishListStore.wishList[i],
                                onTap: () async {
                                  BookDetailScreen(data: wishListStore.wishList[i]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : noDataWidget(context)
            : NoInternetComponent();
      }),
    );
  }
}

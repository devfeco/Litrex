import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../component/ItemWidget.dart';
import '../model/DashboardResponse.dart';
import '../network/RestApis.dart';
import '../utils/Extensions/Widget_extensions.dart';
import '../utils/appWidget.dart';
import '../main.dart';
import '../utils/Extensions/AppTextField.dart';
import '../utils/Extensions/Commons.dart';
import '../utils/Extensions/decorations.dart';
import '../utils/colors.dart';
import '../utils/constant.dart';
import 'BookDetailScreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchCont = TextEditingController();

  ScrollController scrollController = ScrollController();

  int currentPage = 1;
  bool isLastPage = false;
  List<Book> mBookList = [];
  List<Book> mSearchList = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      scrollHandler();
    });
  }

  void init() async {
    getAPI(data: searchCont.text);
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      appStore.setLoading(true);
      init();
    }
  }

  loadData(List<Book> value) {
    if (!mounted) return;
    setState(() {
      appStore.setLoading(false);
      isLastPage = false;
      if (currentPage == 1) {
        mSearchList.clear();
      }
      setState(() {
        mBookList.addAll(value);
        mSearchList = mBookList;
      });
    });
  }

  catchData() {}

  Future getAPI({String? data}) {
    return getFilterBooks(searchText: data, page: currentPage).then((value) {
      appStore.setLoading(false);
      isLastPage = false;
      if (currentPage == 1) {
        mSearchList.clear();
      }
      setState(() {
        mBookList.addAll(value);
        mSearchList = mBookList;
      });
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", color: primaryColor, textColor: Colors.white, showBack: true),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  autoFocus: true,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(context, label: language.lblSearchBook, prefixIcon: Icon(Ionicons.search_outline)),
                  controller: searchCont,
                  onFieldSubmitted: (c) async {
                    appStore.setLoading(true);
                    getAPI(data: searchCont.text);
                  },
                  onChanged: (c) {
                    appStore.setLoading(true);
                    getAPI(data: searchCont.text);
                  },
                ).paddingOnly(left: 16, top: 16, bottom: 0, right: 16),
                if (mSearchList.isNotEmpty)
                  ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: mSearchList.length,
                    padding: EdgeInsets.all(12),
                    itemBuilder: (_, i) {
                      return ItemWidget(
                        mSearchList[i],
                        onTap: () async {
                          BookDetailScreen(data: mSearchList[i]).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      );
                    },
                  ).expand(),
              ],
            ),
            if (mSearchList.isEmpty && !appStore.isLoading) noDataWidget(context).center(),
            if (appStore.isLoading) mProgress().center()
          ],
        );
      }),
      bottomNavigationBar: mSearchBannerAds == '1' ? showBannerAds() : SizedBox(),
    );
  }
}

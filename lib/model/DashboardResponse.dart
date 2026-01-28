class DashboardResponse {
  Appconfiguration? appconfiguration;
  Adsconfiguration? adsconfiguration;
  OnesignalConfiguration? onesignalConfiguration;
  Apiconfiguration? apiconfiguration;
  List<AppSlider>? slider;
  List<Book>? popularBook;
  List<Book>? featuredBook;
  List<Book>? latestBook;
  List<Category>? category;
  List<Author>? author;

  DashboardResponse(
      {this.appconfiguration,
        this.adsconfiguration,
        this.onesignalConfiguration,
        this.apiconfiguration,
        this.slider,
        this.popularBook,
        this.featuredBook,
        this.latestBook,
        this.category,
        this.author});

  DashboardResponse.fromJson(Map<String, dynamic> json) {
    appconfiguration = json['appconfiguration'] != null
        ? new Appconfiguration.fromJson(json['appconfiguration'])
        : null;
    adsconfiguration = json['adsconfiguration'] != null
        ? new Adsconfiguration.fromJson(json['adsconfiguration'])
        : null;
    onesignalConfiguration = json['onesignal_configuration'] != null
        ? new OnesignalConfiguration.fromJson(json['onesignal_configuration'])
        : null;
    apiconfiguration = json['apiconfiguration'] != null
        ? new Apiconfiguration.fromJson(json['apiconfiguration'])
        : null;
    if (json['slider'] != null) {
      slider = <AppSlider>[];
      json['slider'].forEach((v) {
        slider!.add(new AppSlider.fromJson(v));
      });
    }
    if (json['popular_book'] != null) {
      popularBook = <Book>[];
      json['popular_book'].forEach((v) {
        popularBook!.add(new Book.fromJson(v));
      });
    }
    if (json['featured_book'] != null) {
      featuredBook = <Book>[];
      json['featured_book'].forEach((v) {
        featuredBook!.add(new Book.fromJson(v));
      });
    }
    if (json['latest_book'] != null) {
      latestBook = <Book>[];
      json['latest_book'].forEach((v) {
        latestBook!.add(new Book.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['author'] != null) {
      author = <Author>[];
      json['author'].forEach((v) {
        author!.add(new Author.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appconfiguration != null) {
      data['appconfiguration'] = this.appconfiguration!.toJson();
    }
    if (this.adsconfiguration != null) {
      data['adsconfiguration'] = this.adsconfiguration!.toJson();
    }
    if (this.onesignalConfiguration != null) {
      data['onesignal_configuration'] = this.onesignalConfiguration!.toJson();
    }
    if (this.apiconfiguration != null) {
      data['apiconfiguration'] = this.apiconfiguration!.toJson();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    if (this.popularBook != null) {
      data['popular_book'] = this.popularBook!.map((v) => v.toJson()).toList();
    }
    if (this.featuredBook != null) {
      data['featured_book'] =
          this.featuredBook!.map((v) => v.toJson()).toList();
    }
    if (this.latestBook != null) {
      data['latest_book'] = this.latestBook!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.author != null) {
      data['author'] = this.author!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Appconfiguration {
  String? facebook;
  String? instagram;
  String? twitter;
  String? whatsapp;
  String? privacyPolicy;
  String? termsCondition;
  String? contactUs;
  String? aboutUs;
  String? copyright;

  Appconfiguration(
      {this.facebook,
        this.instagram,
        this.twitter,
        this.whatsapp,
        this.privacyPolicy,
        this.termsCondition,
        this.contactUs,
        this.aboutUs,
        this.copyright});

  Appconfiguration.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    whatsapp = json['whatsapp'];
    privacyPolicy = json['privacy_policy'];
    termsCondition = json['terms_condition'];
    contactUs = json['contact_us'];
    aboutUs = json['about_us'];
    copyright = json['copyright'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['whatsapp'] = this.whatsapp;
    data['privacy_policy'] = this.privacyPolicy;
    data['terms_condition'] = this.termsCondition;
    data['contact_us'] = this.contactUs;
    data['about_us'] = this.aboutUs;
    data['copyright'] = this.copyright;
    return data;
  }
}

class Adsconfiguration {
  String? adsType;
  String? admobBannerId;
  String? admobInterstitialId;
  String? admobBannerIdIos;
  String? admobInterstitialIdIos;
  String? admobNativeId;
  String? admobNativeIdIos;
  String? admobAdaptiveBannerId;
  String? admobAdaptiveBannerIdIos;
  
  String? facebookBannerId;
  String? facebookInterstitialId;
  String? facebookBannerIdIos;
  String? facebookInterstitialIdIos;
  String? facebookNativeId;
  String? facebookNativeIdIos;
  
  String? interstitialAdsInterval;
  String? bannerAdBookList;
  String? bannerAdCategoryList;
  String? bannerAdAuthorList;
  String? bannerAdAuthorDetail;
  String? bannerAdBookDetail;
  String? bannerAdBookSearch;
  String? interstitialAdBookList;
  String? interstitialAdCategoryList;
  String? interstitialAdBookDetail;
  String? interstitialAdAuthorList;
  String? interstitialAdAuthorDetail;

  Adsconfiguration(
      {this.adsType,
        this.admobBannerId,
        this.admobInterstitialId,
        this.admobBannerIdIos,
        this.admobInterstitialIdIos,
        this.admobNativeId,
        this.admobNativeIdIos,
        this.admobAdaptiveBannerId,
        this.admobAdaptiveBannerIdIos,
        this.facebookBannerId,
        this.facebookInterstitialId,
        this.facebookBannerIdIos,
        this.facebookInterstitialIdIos,
        this.facebookNativeId,
        this.facebookNativeIdIos,
        this.interstitialAdsInterval,
        this.bannerAdBookList,
        this.bannerAdCategoryList,
        this.bannerAdAuthorList,
        this.bannerAdAuthorDetail,
        this.bannerAdBookDetail,
        this.bannerAdBookSearch,
        this.interstitialAdBookList,
        this.interstitialAdCategoryList,
        this.interstitialAdBookDetail,
        this.interstitialAdAuthorList,
        this.interstitialAdAuthorDetail});

  Adsconfiguration.fromJson(Map<String, dynamic> json) {
    adsType = json['ads_type'];
    admobBannerId = json['admob_banner_id'];
    admobInterstitialId = json['admob_interstitial_id'];
    admobBannerIdIos = json['admob_banner_id_ios'];
    admobInterstitialIdIos = json['admob_interstitial_id_ios'];
    admobNativeId = json['admob_native_id'];
    admobNativeIdIos = json['admob_native_id_ios'];
    admobAdaptiveBannerId = json['admob_adaptive_banner_id'];
    admobAdaptiveBannerIdIos = json['admob_adaptive_banner_id_ios'];
    
    facebookBannerId = json['facebook_banner_id'];
    facebookInterstitialId = json['facebook_interstitial_id'];
    facebookBannerIdIos = json['facebook_banner_id_ios'];
    facebookInterstitialIdIos = json['facebook_interstitial_id_ios'];
    facebookNativeId = json['facebook_native_id'];
    facebookNativeIdIos = json['facebook_native_id_ios'];
    
    interstitialAdsInterval = json['interstitial_ads_interval'];
    bannerAdBookList = json['banner_ad_book_list'];
    bannerAdCategoryList = json['banner_ad_category_list'];
    bannerAdAuthorList = json['banner_ad_author_list'];
    bannerAdAuthorDetail = json['banner_ad_author_detail'];
    bannerAdBookDetail = json['banner_ad_book_detail'];
    bannerAdBookSearch = json['banner_ad_book_search'];
    interstitialAdBookList = json['interstitial_ad_book_list'];
    interstitialAdCategoryList = json['interstitial_ad_category_list'];
    interstitialAdBookDetail = json['interstitial_ad_book_detail'];
    interstitialAdAuthorList = json['interstitial_ad_author_list'];
    interstitialAdAuthorDetail = json['interstitial_ad_author_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ads_type'] = this.adsType;
    data['admob_banner_id'] = this.admobBannerId;
    data['admob_interstitial_id'] = this.admobInterstitialId;
    data['admob_banner_id_ios'] = this.admobBannerIdIos;
    data['admob_interstitial_id_ios'] = this.admobInterstitialIdIos;
    data['admob_native_id'] = this.admobNativeId;
    data['admob_native_id_ios'] = this.admobNativeIdIos;
    data['admob_adaptive_banner_id'] = this.admobAdaptiveBannerId;
    data['admob_adaptive_banner_id_ios'] = this.admobAdaptiveBannerIdIos;
    
    data['facebook_banner_id'] = this.facebookBannerId;
    data['facebook_interstitial_id'] = this.facebookInterstitialId;
    data['facebook_banner_id_ios'] = this.facebookBannerIdIos;
    data['facebook_interstitial_id_ios'] = this.facebookInterstitialIdIos;
    data['facebook_native_id'] = this.facebookNativeId;
    data['facebook_native_id_ios'] = this.facebookNativeIdIos;
    
    data['interstitial_ads_interval'] = this.interstitialAdsInterval;
    data['banner_ad_book_list'] = this.bannerAdBookList;
    data['banner_ad_category_list'] = this.bannerAdCategoryList;
    data['banner_ad_author_list'] = this.bannerAdAuthorList;
    data['banner_ad_author_detail'] = this.bannerAdAuthorDetail;
    data['banner_ad_book_detail'] = this.bannerAdBookDetail;
    data['banner_ad_book_search'] = this.bannerAdBookSearch;
    data['interstitial_ad_book_list'] = this.interstitialAdBookList;
    data['interstitial_ad_category_list'] = this.interstitialAdCategoryList;
    data['interstitial_ad_book_detail'] = this.interstitialAdBookDetail;
    data['interstitial_ad_author_list'] = this.interstitialAdAuthorList;
    data['interstitial_ad_author_detail'] = this.interstitialAdAuthorDetail;
    return data;
  }
}

class OnesignalConfiguration {
  String? appId;
  String? restApiKey;

  OnesignalConfiguration({this.appId, this.restApiKey});

  OnesignalConfiguration.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    restApiKey = json['rest_api_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['rest_api_key'] = this.restApiKey;
    return data;
  }
}

class Apiconfiguration {
  String? limit;
  String? categoryOrder;
  String? categoryOrderby;
  String? bookOrder;
  String? bookOrderby;
  String? authorOrder;
  String? authorOrderby;

  Apiconfiguration(
      {this.limit,
        this.categoryOrder,
        this.categoryOrderby,
        this.bookOrder,
        this.bookOrderby,
        this.authorOrder,
        this.authorOrderby});

  Apiconfiguration.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    categoryOrder = json['category_order'];
    categoryOrderby = json['category_orderby'];
    bookOrder = json['book_order'];
    bookOrderby = json['book_orderby'];
    authorOrder = json['author_order'];
    authorOrderby = json['author_orderby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['category_order'] = this.categoryOrder;
    data['category_orderby'] = this.categoryOrderby;
    data['book_order'] = this.bookOrder;
    data['book_orderby'] = this.bookOrderby;
    data['author_order'] = this.authorOrder;
    data['author_orderby'] = this.authorOrderby;
    return data;
  }
}

class AppSlider {
  String? id;
  String? title;
  String? url;
  String? image;
  String? status;
  String? imageUrl;

  AppSlider(
      {this.id, this.title, this.url, this.image, this.status, this.imageUrl});

  AppSlider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    image = json['image'];
    status = json['status'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['url'] = this.url;
    data['image'] = this.image;
    data['status'] = this.status;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Category {
  String? id;
  String? name;
  String? logo;
  List<Book>? book;

  Category({this.id, this.name, this.logo, this.book});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    if (json['book'] != null) {
      book = <Book>[];
      json['book'].forEach((v) {
        book!.add(new Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    if (this.book != null) {
      data['book'] = this.book!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Author {
  String? id;
  String? name;
  String? description;
  String? designation;
  String? image;
  String? youtubeUrl;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? websiteUrl;
  String? status;
  String? createdAt;
  String? imageUrl;

  Author(
      {this.id,
        this.name,
        this.description,
        this.designation,
        this.image,
        this.youtubeUrl,
        this.facebookUrl,
        this.instagramUrl,
        this.twitterUrl,
        this.websiteUrl,
        this.status,
        this.createdAt,
        this.imageUrl});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    designation = json['designation'];
    image = json['image'];
    youtubeUrl = json['youtube_url'];
    facebookUrl = json['facebook_url'];
    instagramUrl = json['instagram_url'];
    twitterUrl = json['twitter_url'];
    websiteUrl = json['website_url'];
    status = json['status'];
    createdAt = json['created_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['designation'] = this.designation;
    data['image'] = this.image;
    data['youtube_url'] = this.youtubeUrl;
    data['facebook_url'] = this.facebookUrl;
    data['instagram_url'] = this.instagramUrl;
    data['twitter_url'] = this.twitterUrl;
    data['website_url'] = this.websiteUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Book {
  String? id;
  String? name;
  String? categoryId;
  String? authorId;
  String? type;
  String? file;
  String? logo;
  String? description;
  String? url;
  String? isPopular;
  String? isFeatured;
  String? createdAt;
  String? categoryName;
  String? authorName;
  String? authorImage;
  String? isPremium;

  Book(
      {this.id,
        this.name,
        this.categoryId,
        this.authorId,
        this.type,
        this.file,
        this.logo,
        this.description,
        this.url,
        this.isPopular,
        this.isFeatured,
        this.createdAt,
        this.categoryName,
        this.authorName,
        this.authorImage,
        this.isPremium});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    authorId = json['author_id'];
    type = json['type'];
    file = json['file'];
    logo = json['logo'];
    description = json['description'];
    url = json['url'];
    isPopular = json['is_popular'];
    isFeatured = json['is_featured'];
    createdAt = json['created_at'];
    categoryName = json['category_name'];
    authorName = json['author_name'];
    authorImage = json['author_image'];
    isPremium = json['is_premium']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['author_id'] = this.authorId;
    data['type'] = this.type;
    data['file'] = this.file;
    data['logo'] = this.logo;
    data['description'] = this.description;
    data['url'] = this.url;
    data['is_popular'] = this.isPopular;
    data['is_featured'] = this.isFeatured;
    data['created_at'] = this.createdAt;
    data['category_name'] = this.categoryName;
    data['author_name'] = this.authorName;
    data['author_image'] = this.authorImage;
    data['is_premium'] = this.isPremium;
    return data;
  }
}
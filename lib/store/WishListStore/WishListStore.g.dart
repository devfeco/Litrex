// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WishListStore.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WishListStore on _WishListStore, Store {
  final _$wishListAtom = Atom(name: '_WishListStore.wishList');

  @override
  List<Book> get wishList {
    _$wishListAtom.reportRead();
    return super.wishList;
  }

  @override
  set wishList(List<Book> value) {
    _$wishListAtom.reportWrite(value, super.wishList, () {
      super.wishList = value;
    });
  }

  final _$isNetworkAvailableAtom =
      Atom(name: '_WishListStore.isNetworkAvailable');

  @override
  bool get isNetworkAvailable {
    _$isNetworkAvailableAtom.reportRead();
    return super.isNetworkAvailable;
  }

  @override
  set isNetworkAvailable(bool value) {
    _$isNetworkAvailableAtom.reportWrite(value, super.isNetworkAvailable, () {
      super.isNetworkAvailable = value;
    });
  }

  final _$addToWishListAsyncAction =
      AsyncAction('_WishListStore.addToWishList');

  @override
  Future<void> addToWishList(Book data) {
    return _$addToWishListAsyncAction.run(() => super.addToWishList(data));
  }

  final _$storeWishlistDataAsyncAction =
      AsyncAction('_WishListStore.storeWishlistData');

  @override
  Future<void> storeWishlistData() {
    return _$storeWishlistDataAsyncAction.run(() => super.storeWishlistData());
  }

  final _$clearWishlistAsyncAction =
      AsyncAction('_WishListStore.clearWishlist');

  @override
  Future<void> clearWishlist() {
    return _$clearWishlistAsyncAction.run(() => super.clearWishlist());
  }

  final _$_WishListStoreActionController =
      ActionController(name: '_WishListStore');

  @override
  void setConnectionState(ConnectivityResult val) {
    final _$actionInfo = _$_WishListStoreActionController.startAction(
        name: '_WishListStore.setConnectionState');
    try {
      return super.setConnectionState(val);
    } finally {
      _$_WishListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAllWishListItem(List<Book> productList) {
    final _$actionInfo = _$_WishListStoreActionController.startAction(
        name: '_WishListStore.addAllWishListItem');
    try {
      return super.addAllWishListItem(productList);
    } finally {
      _$_WishListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
wishList: ${wishList},
isNetworkAvailable: ${isNetworkAvailable}
    ''';
  }
}

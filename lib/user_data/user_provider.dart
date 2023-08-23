import 'package:flutter/material.dart';

//////////////////////////// 사용자 정보 프로바이더 ////////////////////////////////
class UserItemProvider with ChangeNotifier {

  List<UserItem> userItemsMap = [];

  getItem() {
    return userItemsMap;
  }

  setItem(List<UserItem> userItem) {
    userItemsMap = userItem;
    // notifyListeners();
  }
}



////////////////////////////////////////////////////////////////////////////////
class UserItem {
  int kakaoId = 0;
  String email = '';
  String phoneNumber = '';
  String name = '';
  String dateJoin = '';
  String dateStart = '';
  String dateEnd = '';
  String tier = '';
  String documentId = '';
  String etc = '';

  UserItem({required this.kakaoId, required this.email, required this.phoneNumber, required this.name, required this.dateJoin, required this.dateStart,
    required this.dateEnd, required this.tier, required this.documentId, required this.etc});
}
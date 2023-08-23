import 'package:flutter/material.dart';

//////////////////////////// 사용자 정보 프로바이더 ////////////////////////////////
class RegisteredFriendsItemProvider with ChangeNotifier {

  List<RegisteredFriendsItem> registeredFriendsMap = [];

  getItem() {
    return registeredFriendsMap;
  }

  setItem(List<RegisteredFriendsItem> registeredFriends) {
    registeredFriendsMap = registeredFriends;
    // notifyListeners();
  }
}



////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItem {
  int kakaoId = 0;
  String kakaoUuid = '';
  int managerId = 0;
  String name = '';
  String kakaoNickname = '';
  int talkDown = 0; //0: 설정되지 않음, 1: 반말, 2: 높임말
  List<dynamic> tag = [];
  bool registered = false;
  String managedLastDate = '';
  int managedCount = 0;
  String tier = '';
  String documentId = '';
  String etc = '';

  RegisteredFriendsItem({required this.kakaoId, required this.managerId, required this.name, required this.kakaoNickname,
    required this.talkDown, required this.tag, required this.registered, required this.managedLastDate, required this.managedCount,
    required this.tier, required this.documentId, required this.etc, required this.kakaoUuid});
}
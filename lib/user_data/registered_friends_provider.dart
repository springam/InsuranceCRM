import 'package:flutter/material.dart';

//////////////////////////// 등록 친구 정보 프로바이더 ////////////////////////////////
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

//////////////////////////// 등록 친구 정보 프로바이더 ////////////////////////////////
class SendMessageFriendsItemProvider with ChangeNotifier {

  List<RegisteredFriendsItem> sendMessageFriendsMap = [];

  getItem() {
    return sendMessageFriendsMap;
  }

  addItem(RegisteredFriendsItem sendMessageFriend) {
    sendMessageFriendsMap.add(sendMessageFriend);
    notifyListeners();
  }

  setItem(List<RegisteredFriendsItem> sendMessageFriends) {
    sendMessageFriendsMap = sendMessageFriends;
    notifyListeners();
  }

  removeItem(RegisteredFriendsItem sendMessageFriend) {
    sendMessageFriendsMap.remove(sendMessageFriend);
    notifyListeners();
  }
}


////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItem {
  int kakaoId = 0;
  String kakaoUuid = '';
  int managerId = 0;
  String name = '';
  String kakaoNickname = '';
  int talkDown = 0; //0: 존대, 1: 반말, 2: 설정 되지 않음
  List<dynamic> tag = [];
  bool registered = false;
  String registeredDate = '';
  String managedLastDate = '';
  int managedCount = 0;
  String tier = '';
  String documentId = '';
  String etc = '';

  RegisteredFriendsItem({required this.kakaoId, required this.managerId, required this.name, required this.kakaoNickname,
    required this.talkDown, required this.tag, required this.registered, required this.registeredDate, required this.managedLastDate,
    required this.managedCount, required this.tier, required this.documentId, required this.etc, required this.kakaoUuid});
}
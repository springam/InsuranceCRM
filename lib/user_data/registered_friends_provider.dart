import 'package:flutter/material.dart';

////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItemProvider with ChangeNotifier {

  List<RegisteredFriendsItem> registeredFriendsMap = [];

  getItem() {
    return registeredFriendsMap;
  }

  setItem(List<RegisteredFriendsItem> registeredFriends) {
    registeredFriendsMap = registeredFriends;
    notifyListeners();
  }

  addItems(List<RegisteredFriendsItem> responseFriends) {
    registeredFriendsMap.addAll(responseFriends);
    // notifyListeners();
  }

  removeItem(responseFriend) {
    registeredFriendsMap.remove(responseFriend);
    // notifyListeners();
  }

  initItem() {
    registeredFriendsMap.clear();
    // notifyListeners();
  }

  modifyItem(String name, List<dynamic> selectedHashTag, int talkDown, int index) {
    registeredFriendsMap[index].name = name;
    registeredFriendsMap[index].tag = selectedHashTag;
    registeredFriendsMap[index].talkDown = talkDown;
    notifyListeners();
  }
}

////////////////////////////////////////////////////////////////////////////////
class FriendsItemProvider with ChangeNotifier {

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
class NotSetItemProvider with ChangeNotifier {

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
class SendMessageFriendsItemProvider with ChangeNotifier {

  List<RegisteredFriendsItem> sendMessageFriendsMap = [];

  getItem() {
    return sendMessageFriendsMap;
  }

  addItem(RegisteredFriendsItem sendMessageFriend) {
    if (!sendMessageFriendsMap.contains(sendMessageFriend)) {
      sendMessageFriendsMap.add(sendMessageFriend);
    }
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

  initItem() {
    sendMessageFriendsMap = [];
    notifyListeners();
  }
}

////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItem {
  String managerEmail = '';
  String name = '';
  String kakaoNickname = '';
  int talkDown = 0; //0: 존대, 1: 반말, 2: 설정 되지 않음
  List<dynamic> tag = [];
  int registered = 2; //0: deny register, 1: registered, 2: not set
  String registeredDate = '';
  String managedLastDate = '';
  int managedCount = 0;
  int tier = 0;
  String documentId = '';
  String etc = '';

  RegisteredFriendsItem({required this.managerEmail, required this.name, required this.kakaoNickname, required this.talkDown,
    required this.tag, required this.registered, required this.registeredDate, required this.managedLastDate,
    required this.managedCount, required this.tier, required this.documentId, required this.etc});
}
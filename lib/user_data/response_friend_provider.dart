import 'package:flutter/material.dart';
import 'registered_friends_provider.dart';

//////////////////////////// 등록 친구 정보 프로바이더 ////////////////////////////////
class ResponseFriendsItemProvider with ChangeNotifier {

  List<RegisteredFriendsItem> responseFriendsMap = [];

  getItem() {
    return responseFriendsMap;
  }

  setItem(List<RegisteredFriendsItem> responseFriends) {
    responseFriendsMap = responseFriends;
    notifyListeners();
  }

  // addItem(RegisteredFriendsItem responseFriend) {
  //   responseFriendsMap.add(responseFriend);
  //   notifyListeners();
  // }

  addItems(List<RegisteredFriendsItem> responseFriends) {
    responseFriendsMap.addAll(responseFriends);
    // notifyListeners();
  }

  removeItem(responseFriend) {
    responseFriendsMap.remove(responseFriend);
    notifyListeners();
  }

  initItem() {
    responseFriendsMap.clear();
  }

  modifyName(String name, int index) {
    responseFriendsMap[index].name = name;
  }

  modifyRegistered(int registered, int index) {
    responseFriendsMap[index].registered = registered;
  }

  modifyTag(List<dynamic> tag, int index) {
    responseFriendsMap[index].tag = tag;
  }

  modifyTalkDown(int selected, int index) {
    responseFriendsMap[index].talkDown = selected;
  }
}
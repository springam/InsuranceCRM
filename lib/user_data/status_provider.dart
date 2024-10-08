import 'package:flutter/material.dart';

class CurrentPageProvider with ChangeNotifier {

  int currentMainPage = 0;
  int currentSubPage = 0;
  int selectedThemeIndex = 20;
  int talkDown = 0;
  bool titleIsMessage = true;

  // mainPage
  // 0: 메인
  // 1: 카톡 보내기
  // 2: 고객 관리카드
  // 3: 처음 세팅

  // main 1 subPage
  // 0: select_friends
  // 1: select_message
  // 2: message_preset

  getMainPage() {
    return currentMainPage;
  }

  getSubPage() {
    return currentSubPage;
  }

  getSelectedThemeIndex() {
    return selectedThemeIndex;
  }

  getTalkDown() {
    return talkDown;
  }

  bool getTitleIsMessage() {
    return titleIsMessage;
  }

  setCurrentMainPage(int mainPageIndex) {
    currentMainPage = mainPageIndex;
    notifyListeners();
  }

  setCurrentSubPage(int subPageIndex) {
    currentSubPage = subPageIndex;
    notifyListeners();
  }

  setSelectedThemeIndex(int themeIndex) {
    selectedThemeIndex = themeIndex;
    notifyListeners();
  }

  setTalkDown(int talkDownIndex) {
    talkDown = talkDownIndex;
    notifyListeners();
  }

  setTitleIsMessage(bool messageBool) {
    titleIsMessage = messageBool;
  }

}
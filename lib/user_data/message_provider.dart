import 'package:flutter/material.dart';

class TextMessageProvider with ChangeNotifier { //실제 보내질 메시지 내용

  String textMessage = '';
  String textMessageTalkDown = '';

  getTextMessage() {
    return textMessage;
  }

  getTextMessageTalkDown() {
    return textMessageTalkDown;
  }

  setTextMessage(String message) {
    textMessage = message;
    notifyListeners();
  }

  setTextMessageTalkDown(String message) {
    textMessageTalkDown = message;
    notifyListeners();
  }

}

////////////////////////////////////////////////////////////////////////////////
class MessageItemProvider with ChangeNotifier {

  List<PresetMessageItem> presetMessageItems = [];

  getItem() {
    return presetMessageItems;
  }

  setItem(List<PresetMessageItem> presetMessageItem) {
    presetMessageItems = presetMessageItem;
  }

}

////////////////////////////////////////////////////////////////////////////////
class PresetMessageItem {
  int subjectIndex = 0; //메시지 제목
  String messageBody = '';  //메시지 내용
  String messageBodyTalkDown = '';
  bool customMessage = false; //커스텀 메시지 인지
  String madeBy = ''; //생성자 ID
  String creationDate = ''; //생성일
  String documentId = '';
  int consumedCount = 0;  //사용된 횟수

PresetMessageItem({required this.subjectIndex, required this.messageBody, required this.messageBodyTalkDown, required this.customMessage,
required this.madeBy, required this.creationDate, required this.documentId, required this.consumedCount});
}

//['월초', '생일', '안부', '결혼', '계절', '연휴', '맨 처음', '계약후', '보상후', '내 메시지', '다른사람 메시지']
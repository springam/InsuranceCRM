import 'package:flutter/material.dart';

class ImageCardProvider with ChangeNotifier { //실제 보내질 메시지 내용

  String imagePath = '';
  String imageName = '';

  getImagePath() {
    return imagePath;
  }

  getImageName() {
    return imageName;
  }

  setImagePath(String path, String name) {
    imagePath = path;
    imageName = name;
    notifyListeners();
  }



  // setTextMessageTalkDown(String message) {
  //   textMessageTalkDown = message;
  //   notifyListeners();
  // }

}

////////////////////////////////////////////////////////////////////////////////
class ImageCardItemProvider with ChangeNotifier {

  List<ImageCardItem> imageCardItems = [];

  getItem() {
    return imageCardItems;
  }

  setItem(List<ImageCardItem> imageCardItem) {
    imageCardItems = imageCardItem;
  }

}

////////////////////////////////////////////////////////////////////////////////
class ImageCardItem {
  List<dynamic> subjectIndex = []; //분류
  String imagePath = ''; //경로
  String message = ''; //기본 메시지
  bool customMessage = false; //커스텀 메시지 인지
  String madeBy = ''; //생성자 ID
  String creationDate = ''; //생성일
  String documentId = '';
  int consumedCount = 0;  //사용된 횟수

  ImageCardItem({required this.subjectIndex, required this.imagePath, required this.message, required this.customMessage,
    required this.madeBy, required this.creationDate, required this.documentId, required this.consumedCount});
}

//['월초', '생일', '안부', '결혼', '계절', '연휴', '맨 처음', '계약후', '보상후', '내 메시지', '다른 사람 메시지']
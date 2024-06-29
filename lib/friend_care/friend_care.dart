import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../etc_widget/alert_dialog.dart';
import '../etc_widget/text_message.dart';
import '../send_message/send_message_friends/send_message_friend_list.dart';
import '../send_message/send_message_friends/send_message_friend_tile.dart';
import '../user_data/registered_friends_provider.dart';
import '../user_data/response_friend_provider.dart';
import '../user_data/status_provider.dart';

class FriendCare extends StatefulWidget {
  const FriendCare({super.key});

  @override
  State<FriendCare> createState() => _FriendCareState();
}

class _FriendCareState extends State<FriendCare> {

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  late FriendsItemProvider fIP;
  late RegisteredFriendsItemProvider regIP;
  late ResponseFriendsItemProvider resIP;

  final ScrollController sendMessageFriendController = ScrollController();

  List<RegisteredFriendsItem> careFriends = [];
  int dateDifference = 0;  //0: 1년이상, 1: 6개월~1년, 2: 3개월~6개월, 3: 1개월~3개월
  String dateDiffText = '';
  int selectedPage = 1;  //첫 페이지 = 1

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCareFriends() {

    careFriends = [];

    for (RegisteredFriendsItem friend in fIP.getItem()) {
      int diff = 20;

      if (friend.managedCount != 0) {
        diff = int.parse(
            DateTime.now().difference(
              DateTime.parse(friend.managedLastDate)).inDays.toString()
        );
      }

      if (dateDifference == 0) {
        dateDiffText = '1년이상';
        if (diff >= 12) {
          careFriends.add(friend);
        }
      } else if (dateDifference == 1) {
        dateDiffText = '6개월~1년';
        if (diff >= 6 && diff < 12) {
          careFriends.add(friend);
        }
      } else if (dateDifference == 2) {
        dateDiffText = '3개월~6개월';
        if (diff >= 3 && diff < 6) {
          careFriends.add(friend);
        }
      } else {
        dateDiffText = '1개월~3개월';
        if (diff >= 1 && diff < 3) {
          careFriends.add(friend);
        }
      }

    }
  }

  Widget dateDiffSelect(int index) {

    String diffText ='';

    switch (index) {
      case 0:
        diffText = '1년이상';
        break;
      case 1:
        diffText = '6개월~1년';
        break;
      case 2:
        diffText = '3개월~6개월';
        break;
      case 3:
        diffText = '1개월~3개월';
        break;
    }

    return InkWell(
      child: Container(
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color(0xffd9d9d9),
                width: 1
            ),
            color: (dateDifference == index) ? Colors.blueGrey : Colors.white
        ),
        child: Text(diffText),
      ),
      onTap: () {
        setState(() {
          dateDifference = index;
        });
      },
    );
  }

  Widget tegListCareFriend(List<dynamic> tagList) {

    List<Widget> tagTextList = [];

    if (tagList.isNotEmpty) {
      for (var item in tagList) {
        tagTextList.add(Container(
          margin: const EdgeInsets.only(right: 10),
          child: Text('# $item'),
        ));
      }
    }

    return Row(
      children: tagTextList,
    );
  }

  Widget cardFriendInfo(int lineCount) {

    Color buttonColor = const Color(0xffbcc0c7);
    bool selectedCard = false;
    RegisteredFriendsItem cardFriendItem = careFriends[((selectedPage - 1) * 9) + lineCount];

    if (sIP.getItem().contains(cardFriendItem)) {
      buttonColor = Colors.grey;
      selectedCard = true;
    }

    return Container(
      height: 121,
      alignment: Alignment.centerLeft,
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: Text(cardFriendItem.kakaoNickname),
          ),
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: tegListCareFriend(cardFriendItem.tag),
          ),
          Container(
            height: 30,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: (cardFriendItem.managedCount == 0)
                ? const Text('관리된 기록이 없습니다.')
                : Text(cardFriendItem.managedLastDate),
          ),

          Container(
            margin: const EdgeInsets.only(top: 1),
            child: Material(
              color: const Color(0xffffffff),
              child: InkWell(
                // borderRadius: BorderRadius.circular(10),
                splashColor: const Color(0xffffdf8e),
                hoverColor: Colors.grey,
                child: Ink(
                  height: 30,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: buttonColor,
                  ),
                  child: Center(
                    child: Text('고객 선택', style: buttonTextStyle,),
                  ),
                ),
                onTap: () {
                  if (selectedCard) {
                    sIP.removeItem(cardFriendItem);
                    setState(() {
                      selectedCard = false;
                    });
                  } else {
                    if (!sIP.getItem().contains(cardFriendItem)) {
                      sIP.addItem(cardFriendItem);
                      setState(() {
                        selectedCard = true;
                      });
                    }
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget careFriendList(int lineCount) {
    return Row(
      children: [
        ((((selectedPage - 1) * 9) + (lineCount * 3)) < careFriends.length - 1) ? Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            child: cardFriendInfo(lineCount * 3),
          ),
        ) : const Expanded(flex: 1, child: SizedBox()),

        (((selectedPage - 1) * 9) + (lineCount * 3) + 1 < careFriends.length - 1) ? Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
            child: cardFriendInfo((lineCount * 3) + 1),
          ),
        ) : const Expanded(flex: 1, child: SizedBox()),

        (((selectedPage - 1) * 9) + (lineCount * 3) + 2 < careFriends.length - 1) ? Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: cardFriendInfo((lineCount * 3) + 2),
          ),
        ) : const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }

  Widget indexBar(int index) {

    List<Widget> indexWidget = [];

    int firstIndex = 2;
    int lastIndex = 6;
    int fullCount = careFriends.length;
    bool moreIndex = false;

    firstIndex = ((((selectedPage - 2) ~/ 5) * 5) + 2);

    if (fullCount > (firstIndex + 4) * 9) {
      lastIndex = firstIndex + 5;
      moreIndex = true;
    } else {
      lastIndex = (fullCount ~/ 9);
    }

    int itemCount  = (lastIndex - firstIndex) + 3;

    for (int i = 0; i < itemCount; i++) {

      String countIndex = '처음';
      int selectedIndex = 1;  //0이면 마지막, 00이면 more

      if (i == 0) {
        countIndex = '처음';
        selectedIndex = 1;
      } else if (i == itemCount -2 && moreIndex) {
        countIndex = '...';
        selectedIndex = (firstIndex + (i - 1));
      } else if (i == itemCount - 1) {
        countIndex = '마지막';
        selectedIndex = (fullCount ~/ 9) + 1;
      } else {
        countIndex = (firstIndex + (i - 1)).toString();
        selectedIndex = (firstIndex + (i - 1));
      }

      indexWidget.add(
          InkWell(
            child: Container(
              height: 30,
              width: 60,
              alignment: Alignment.center,
              child: Text(countIndex),  //selectedPage == countIndex ? bold
            ),
            onTap: () {
              setState(() {
                selectedPage = selectedIndex;
              });
            },
          )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indexWidget,
    );
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    fIP = Provider.of<FriendsItemProvider>(context, listen: true);
    regIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);
    resIP = Provider.of<ResponseFriendsItemProvider>(context, listen: true);

    Color sendButtonColor = const Color(0xffbcc0c7);

    setCareFriends();

    if (sIP.getItem().length == 0) {
      sendButtonColor = const Color(0xfff0f0f0);
    }

    return Container(
      // height: MediaQuery.of(context).size.height * 1.3,
      margin: const EdgeInsets.only(top: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 14,
            child: Container(
              margin: const EdgeInsets.only(left: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextMessageNormal("고객관리", 22.0),
                    ],
                  ),

                  const SizedBox(height: 17),

                  SizedBox(
                    width: 400,
                    child: Row(
                      children: [
                        dateDiffSelect(0),
                        dateDiffSelect(1),
                        dateDiffSelect(2),
                        dateDiffSelect(3)
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  TextMessageNormal("$dateDiffText 연락을 안 한 고객 리스트", 18.0),

                  const SizedBox(height: 13),

                  (((selectedPage - 1) * 9) < careFriends.length) ? careFriendList(0) : const SizedBox(),

                  ((((selectedPage - 1) * 9) + 3) < careFriends.length) ? careFriendList(1) : const SizedBox(),

                  ((((selectedPage - 1) * 9) + 6) < careFriends.length) ? careFriendList(2) : const SizedBox(),

                  (careFriends.length < 10) ? const SizedBox() : indexBar(selectedPage),

                  (careFriends.isEmpty) ? Container(
                    height: 120,
                    alignment: Alignment.center,
                    color: const Color(0xffbcc0c7),
                    child: Text('$dateDiffText 연락을 안 한 고객은 없습니다.'),
                  ) : const SizedBox(),

                  (careFriends.isEmpty) ? const SizedBox() : Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Material(
                      color: const Color(0xffffffff),
                      child: InkWell(
                        // borderRadius: BorderRadius.circular(10),
                        splashColor: const Color(0xffffdf8e),
                        hoverColor: Colors.grey,
                        child: Ink(
                          height: 30,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: sendButtonColor,
                          ),
                          child: Center(
                            child: Text('카톡 보내기', style: buttonTextStyle,),
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          const Expanded(
            flex: 1,
            child: SizedBox(width: 38),
          ),

          const Expanded(
            flex: 5,
            child: SendMessageFriendList(),
          ),

        ],
      ),
    );
  }
}

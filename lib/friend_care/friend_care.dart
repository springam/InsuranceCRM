import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../etc_widget/text_message.dart';
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

  List<RegisteredFriendsItem> careFriends = [];
  int dateDifference = 0;  //0: 1년이상, 1: 6개월~1년, 2: 3개월~6개월, 3: 1개월~3개월
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
      if (friend.managedCount != 0) {
        int diff = int.parse(
            DateTime.now().difference(
                DateTime.parse(friend.managedLastDate)).inDays.toString()
        );
        if (dateDifference == 0) {
          if (diff >= 12) {
            careFriends.add(friend);
          }
        } else if (dateDifference == 1) {
          if (diff >= 6 && diff < 12) {
            careFriends.add(friend);
          }
        } else if (dateDifference == 2) {
          if (diff >= 3 && diff < 6) {
            careFriends.add(friend);
          }
        } else {
          if (diff >= 1 && diff < 3) {
            careFriends.add(friend);
          }
        }
      } else {  //테스트용으로 count == 0 인 친구를 모두 담음
        careFriends.add(friend);
      }

    }
  }

  Widget cardFriendInfo(int lineCount) {

    return Container(
      height: 121,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Text(careFriends[((selectedPage - 1) * 9) + lineCount].kakaoNickname),
          ),
          SizedBox(
            height: 30,
            child: Text(careFriends[((selectedPage - 1) * 9) + lineCount].tag.toString()),
          ),
          SizedBox(
            height: 30,
            child: Text(careFriends[((selectedPage - 1) * 9) + lineCount].managedLastDate),
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
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xffbcc0c7),
                  ),
                  child: Center(
                    child: Text('고객 선택', style: buttonTextStyle,),
                  ),
                ),
                onTap: () {},
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
        (((selectedPage - 1) * 9) < careFriends.length) ? Expanded(
          flex: 1,
          child: cardFriendInfo(lineCount * 3),
        ) : const Expanded(flex: 1, child: SizedBox()),

        (((selectedPage - 1) * 9) + 1 < careFriends.length) ? Expanded(
          flex: 1,
          child: cardFriendInfo((lineCount * 3) + 1),
        ) : const Expanded(flex: 1, child: SizedBox()),

        (((selectedPage - 1) * 9) + 1 < careFriends.length) ? Expanded(
          flex: 1,
          child: cardFriendInfo((lineCount * 3) + 2),
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
      lastIndex = (fullCount ~/ 9) + 3;
    }

    // if (fullCount > 54) {
    //
    //   firstIndex = ((((selectedPage - 2) ~/ 5) * 5) + 2);
    //
    //   if (fullCount > (firstIndex + 3) * 9) {
    //     lastIndex = firstIndex + 5;
    //     moreIndex = true;
    //   } else {
    //     lastIndex = fullCount ~/ 9;
    //   }
    //
    // } else {
    //   if (selectedPage > 6) {  //마지막 앞 버튼 누를실 다음에 보여질 index의 범위를 아래처럼 설정해야함.
    //     firstIndex = (((selectedPage - 2) ~/ 5) * 5) + 2;
    //     lastIndex = (((selectedPage - 2) ~/ 5) * 5) + 6;
    //   } else {
    //     if (fullCount > 45) {
    //       firstIndex = 2;
    //       lastIndex = 6;
    //     } else if (fullCount < 10) {
    //       firstIndex = 0;
    //       lastIndex = 0;
    //     } else {
    //       firstIndex = 2;
    //       lastIndex = ((fullCount - 1) ~/ 9) + 1;
    //     }
    //   }
    // }

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
        selectedIndex = 0;
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

    setCareFriends();

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
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xffd9d9d9),
                                width: 1
                            )
                          ),
                          child: const Text('1년이상'),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffd9d9d9),
                                  width: 1
                              )
                          ),
                          child: const Text('6개월~1년'),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffd9d9d9),
                                  width: 1
                              )
                          ),
                          child: const Text('3개월~6개월'),
                        ),
                        Container(
                          width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xffd9d9d9),
                                  width: 1
                              )
                          ),
                          child: const Text('1개월~3개월'),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  const TextMessageNormal("1년 이상 연락을 안 한 고객 리스트", 18.0),

                  const SizedBox(height: 13),

                  (((selectedPage - 1) * 9) < careFriends.length) ? careFriendList(0) : const SizedBox(),

                  ((((selectedPage - 1) * 9) + 3) < careFriends.length) ? careFriendList(1) : const SizedBox(),

                  ((((selectedPage - 1) * 9) + 6) < careFriends.length) ? careFriendList(2) : const SizedBox(),

                  (careFriends.length < 10) ? const SizedBox() : indexBar(selectedPage)
                ],
              ),
            ),
          ),

          const Expanded(
            flex: 1,
            child: SizedBox(width: 38),
          ),

          Expanded(
            flex: 5,
            child: Container(
              height: 700,
            ),
          ),

        ],
      ),
    );
  }
}

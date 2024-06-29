

import 'package:flutter/material.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/send_message_friend_tile.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/alert_dialog.dart';
import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';

class SendMessageFriendList extends StatefulWidget {
  const SendMessageFriendList({super.key});

  @override
  State<SendMessageFriendList> createState() => _SendMessageFriendListState();
}

class _SendMessageFriendListState extends State<SendMessageFriendList> {

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  final ScrollController sendMessageFriendController = ScrollController();

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    return Container(
      // width: 256,
      margin: const EdgeInsets.only(top: 45, right: 36),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const TextMessageNormal('2. 카톡 보낼 사람을 확인하세요.', 16.0),
          ),

          Container(  //명단 리셋 버튼
            margin: const EdgeInsets.only(top: 10, bottom: 7),
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                splashColor: const Color(0xffffdf8e),
                hoverColor: Colors.grey,
                child: Ink(
                  width: 87,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: const Color(0xff525151), width: 1)
                  ),
                  child: Center(
                    child: Text(
                      '명단 리셋',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
                onTap: () {
                  sIP.setItem([]);
                },
              ),
            ),
          ),

          Container(
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xff000000),
                    width: 1
                ),
                color: const Color(0xfff0f0f0)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 45),
                  child: const TextMessageNormal('카톡대화명', 12.0),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 54),
                  child: const TextMessageNormal('호칭', 12.0),
                ),
              ],
            ),
          ),

          Container(  //메시지 보낼 친구 리스트
            height: 388,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xff000000), width: 1.0),
                right: BorderSide(color: Color(0xff000000), width: 1.0),
              ),
            ),
            child: ListView.builder(
                itemCount: sIP.getItem().length,
                controller: sendMessageFriendController,
                itemBuilder: (BuildContext context, int index) {
                  if (sIP.getItem().length == 0) {
                    return const Text('select friend');
                  } else {
                    return SendMessageFriendTile(registeredFriend: sIP.getItem()[index]);
                  }
                }
            ),
          ),

          Container(
            height: 34,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: Color(0xfff0f0f0),
              border: Border(
                left: BorderSide(color: Color(0xff000000), width: 1.0),
                right: BorderSide(color: Color(0xff000000), width: 1.0),
                bottom: BorderSide(color: Color(0xff000000), width: 1.0),
              ),
            ),
            child: TextMessageNormal('카톡 보내는 사람: ${sIP.getItem().length.toString()}명', 12.0),
          ),

          const SizedBox(height: 13),

          Material(
            color: const Color(0xffffffff),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: const Color(0xffffdf8e),
              hoverColor: Colors.grey,
              child: Ink(
                height: 38,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xfff0f0f0),
                ),
                child: Center(
                  child: Text('메시지 작성', style: buttonTextStyle,),
                ),
              ),
              onTap: () {
                if (sIP.getItem().isEmpty) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertMessage(
                          title: '선택된 친구가 없습니다',
                          message: '왼쪽 친구목록에서 메시지 보낼 친구를 선택해 주세요.',
                        );
                      }
                  );
                } else {
                  cIP.setCurrentSubPage(1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

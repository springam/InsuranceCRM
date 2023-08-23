import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';

import '../../user_data/registered_friends_provider.dart';

class RegisteredFriendTile extends StatefulWidget {
  const RegisteredFriendTile(this.registeredFriend, {super.key});

  final RegisteredFriendsItem registeredFriend;

  @override
  State<RegisteredFriendTile> createState() => _RegisteredFriendTileState();
}

class _RegisteredFriendTileState extends State<RegisteredFriendTile> {

  TextStyle buttonTextStyle = const TextStyle(
      color:  Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "NotoSansCJKKR",
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );

  List<Widget> tagItem() {
    return List<Widget>.generate(widget.registeredFriend.tag.length, (index) =>
        TextMessageNormal('#${widget.registeredFriend.tag[index]}', 12.0)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              // width: 146,
              // height: 26,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 7),
              padding: const EdgeInsets.only(left: 13, top: 3, right: 13, bottom: 3),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(15)
                  ),
                  border: Border.all(width: 1, color: const Color(0xff000000)),
                  color: const Color(0xffffffff)
              ),
              child: Text(
                widget.registeredFriend.kakaoNickname,
                style: const TextStyle(
                    color:  Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                widget.registeredFriend.name,
                style: const TextStyle(
                    color:  Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                (widget.registeredFriend.talkDown == 1) ? '반말' : '존대',
                style: const TextStyle(
                    color:  Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Inter",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 20,
                children: tagItem(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';

class SendMessageFriendTile extends StatefulWidget {
  const SendMessageFriendTile({required this.registeredFriend, super.key});

  final RegisteredFriendsItem registeredFriend;

  @override
  State<SendMessageFriendTile> createState() => _SendMessageFriendTileState();
}

class _SendMessageFriendTileState extends State<SendMessageFriendTile> {

  late SendMessageFriendsItemProvider sIP;

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 30,
              alignment: Alignment.centerLeft,
              // margin: const EdgeInsets.only(left: 7),
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              color: const Color(0xffffffff),
              child: Material(
                color: const Color(0xffffffff),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xffffdf8e),
                  hoverColor: const Color(0xffbcc0c7),
                  child: Ink(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffbcc0c7), width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: const Color(0xffbcc0c7),
                    ),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(
                        widget.registeredFriend.kakaoNickname,
                        style: buttonTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onTap: () {
                    sIP.removeItem(widget.registeredFriend);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 15, right: 15),
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
        ],
      ),
    );
  }
}

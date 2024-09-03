import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';

class SendMessageFriendTempTile extends StatefulWidget {
  const SendMessageFriendTempTile({required this.registeredFriend, super.key});

  final RegisteredFriendsItem registeredFriend;

  @override
  State<SendMessageFriendTempTile> createState() => _SendMessageFriendTempTileState();
}

class _SendMessageFriendTempTileState extends State<SendMessageFriendTempTile> {

  late SendMessageFriendsItemProvider sIP;

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    final TextEditingController middleNickController = TextEditingController();

    middleNickController.text = widget.registeredFriend.name;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: TextMessageNormal(widget.registeredFriend.kakaoNickname, 12.0),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 23,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(bottom: 5, left: 5),
                margin: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffd9d9d9))),
                child: Form(
                  child: TextFormField(
                    controller: middleNickController,
                    style: buttonTextStyle,
                    decoration: const InputDecoration(
                      // hintText: '10자 이내로 입력해 주세요.',
                      // enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                      // ),
                        isDense: true,
                        border: InputBorder.none
                    ),
                    onChanged: (value) {
                      if (value.length < 11) {
                        // resIP.modifyName(value, index);
                      } else {
                        // middleNickController.text = resIP.getItem()[widget.index].name;
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: TextMessageNormal((widget.registeredFriend.talkDown == 0) ? '존대' : '반말', 12.0),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10)
      ],
    );
  }
}

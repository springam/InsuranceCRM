import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/registered_friends_provider.dart';

class MessageView extends StatefulWidget {
  const MessageView({required this.talkDown, super.key});

  final bool talkDown;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {

  late SendMessageFriendsItemProvider sIP;
  late TextMessageProvider tIP;

  final TextEditingController messagePresetController = TextEditingController();

  int talkDownCount = 0;
  String talkDown = '존대';
  String talkDownName = '';

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    tIP = Provider.of<TextMessageProvider>(context, listen: true);

    if (widget.talkDown) {
      messagePresetController.text = tIP.getTextMessageTalkDown();
    } else {
      messagePresetController.text = tIP.getTextMessage();
    }

    for (RegisteredFriendsItem sendMessageFriend in sIP.getItem()) {
      if (widget.talkDown) {
        talkDown = '반말';
        if (sendMessageFriend.talkDown == 0) {
          talkDownCount++;
          talkDownName = '${sendMessageFriend.name}외';
        }
      } else {
        talkDown = '존대';
        if (sendMessageFriend.talkDown == 1) {
          talkDownCount++;
          talkDownName = '${sendMessageFriend.name}외';
        }
      }

    }

    return SizedBox(
      width: double.infinity,
      // margin: const EdgeInsets.only(left: 5, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleNormal('$talkDown 스타일 [$talkDownName $talkDownCount명]', 12),
          const SizedBox(height: 15),
          Container(
            height: 310,
            width: double.infinity,
            color: const Color(0xffffffff),
            padding: const EdgeInsets.all(5),
            child: TextField(
              controller: messagePresetController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: buttonTextStyle,
              decoration: const InputDecoration(
                // hintText: '10자 이내로 입력해 주세요.',
                // enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                // ),
                  border: InputBorder.none
              ),
              onChanged: (value) {
                tIP.setTextMessage(messagePresetController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';

class MessageView extends StatefulWidget {
  const MessageView({required this.talkDown, required this.reset, super.key});

  final bool talkDown;
  final bool reset;

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {

  late SendMessageFriendsItemProvider sIP;
  late TextMessageProvider tIP;
  late CurrentPageProvider cIP;

  final TextEditingController messagePresetController = TextEditingController();

  int talkDownCount = 0;
  String talkDown = '존대';
  String talkDownName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    talkDownCount = 0;

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
                  border: InputBorder.none
              ),
              onChanged: (value) {
                if (widget.talkDown) {
                  tIP.setTextMessageTalkDown(messagePresetController.text);
                  if (cIP.getTalkDown() == 0) {
                    cIP.setTalkDown(1);
                  }
                } else {
                  tIP.setTextMessage(messagePresetController.text);
                  if (cIP.getTalkDown() == 1) {
                    cIP.setTalkDown(0);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

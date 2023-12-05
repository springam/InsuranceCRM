import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../user_data/image_provider.dart';
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
  late ImageCardProvider icIP;

  final TextEditingController messageController = TextEditingController();

  final leftFormKey = GlobalKey<FormState>();
  final rightFormKey = GlobalKey<FormState>();

  int talkDownCount = 0;
  String talkDown = '존대';
  String talkDownName = '';

  @override
  void initState() {
    super.initState();
    SendMessageFriendsItemProvider().addListener(() { });
    TextMessageProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
    ImageCardProvider().addListener(() { });
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    TextMessageProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    ImageCardProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    icIP = Provider.of<ImageCardProvider>(context, listen: true); //현재 보여질 이미지 프로바이더

    talkDownCount = 0;

    if (widget.talkDown) {
      messageController.text = tIP.getTextMessageTalkDown();
    } else {
      messageController.text = tIP.getTextMessage();
    }

    for (RegisteredFriendsItem sendMessageFriend in sIP.getItem()) {
      if (widget.talkDown) {
        talkDown = '반말';
        if (sendMessageFriend.talkDown == 0) {
          talkDownCount++;
          talkDownName = '${sendMessageFriend.name}포함';
        }
      } else {
        talkDown = '존대';
        if (sendMessageFriend.talkDown == 1) {
          talkDownCount++;
          talkDownName = '${sendMessageFriend.name}포함';
        }
      }
    }

    return SizedBox(
      width: double.infinity,
      // margin: const EdgeInsets.only(left: 5, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TitleNormal('$talkDown 스타일 [$talkDownName $talkDownCount명]', 12),
          const SizedBox(height: 15),
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color(0xffffffff)
            ),
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: buttonTextStyle,
              decoration: const InputDecoration(
                border: InputBorder.none
              ),
              onChanged: (value) {
                if (widget.talkDown) {
                  tIP.setTextMessageTalkDown(messageController.text);
                  if (cIP.getTalkDown() == 0) {
                    cIP.setTalkDown(1);
                  }
                } else {
                  tIP.setTextMessage(messageController.text);
                  if (cIP.getTalkDown() == 1) {
                    cIP.setTalkDown(0);
                  }
                }
              },
            ),
            // child: Form(
            //   key: leftFormKey,
            //   child: TextFormField(
            //     controller: messageController,
            //     keyboardType: TextInputType.multiline,
            //     maxLines: null,
            //     style: buttonTextStyle,
            //     decoration: const InputDecoration(
            //         border: InputBorder.none
            //     ),
            //     validator: (value) {},
            //     onSaved: (value) {},
            //     onChanged: (value) {
            //       if (widget.talkDown) {
            //         tIP.setTextMessageTalkDown(messageController.text);
            //         if (cIP.getTalkDown() == 0) {
            //           cIP.setTalkDown(1);
            //         }
            //       } else {
            //         tIP.setTextMessage(messageController.text);
            //         if (cIP.getTalkDown() == 1) {
            //           cIP.setTalkDown(0);
            //         }
            //       }
            //     },
            //   ),
            // )
          ),
        ],
      ),
    );
  }
}

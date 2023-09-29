import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/status_provider.dart';

class GridViewBox extends StatefulWidget {
  const GridViewBox({required this.presetMessage,  super.key});

  final PresetMessageItem presetMessage;
  //['월초', '생일', '안부', '결혼', '계절', '연휴', '맨 처음', '계약후', '보상후', '내 메시지', '다른사람 메시지']

  @override
  State<GridViewBox> createState() => _GridViewBoxState();
}

class _GridViewBoxState extends State<GridViewBox> {

  late TextMessageProvider tIP;
  late CurrentPageProvider cIP;

  @override
  Widget build(BuildContext context) {

    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color(0xffffffff),
        child: Text(
            widget.presetMessage.messageBody,
            style: const TextStyle(fontSize: 12.0),
        ),

      ),
      onTap: () {
        tIP.setTextMessage(widget.presetMessage.messageBody);
        tIP.setTextMessageTalkDown(widget.presetMessage.messageBodyTalkDown);
        cIP.setCurrentSubPage(1);
      },
    );
  }
}

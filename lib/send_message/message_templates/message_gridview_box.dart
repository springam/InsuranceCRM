import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/status_provider.dart';

class GridViewBox extends StatefulWidget {
  const GridViewBox({required this.presetMessage,  super.key});

  final PresetMessageItem presetMessage;

  @override
  State<GridViewBox> createState() => _GridViewBoxState();
}

class _GridViewBoxState extends State<GridViewBox> {

  late TextMessageProvider tIP;
  late CurrentPageProvider cIP;

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    TextMessageProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
  }

  @override
  void dispose() {
    TextMessageProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xffffffff)
        ),
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 5.0,
          child: SingleChildScrollView(
            controller: controller,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent
              ),
              child: Text(
                widget.presetMessage.messageBody,
                style: const TextStyle(fontSize: 12.0),
              ),

            ),
          ),
        ),
      ),
      onTap: () {
        tIP.setTextMessage(widget.presetMessage.messageBody);
        tIP.setTextMessageTalkDown(widget.presetMessage.messageBodyTalkDown);
        cIP.setCurrentSubPage(1);
      },
    );

    // return InkWell(
    //   child: Container(
    //     padding: const EdgeInsets.all(10),
    //     color: const Color(0xffffffff),
    //     child: Text(
    //         widget.presetMessage.messageBody,
    //         style: const TextStyle(fontSize: 12.0),
    //     ),
    //
    //   ),
    //   onTap: () {
    //     tIP.setTextMessage(widget.presetMessage.messageBody);
    //     tIP.setTextMessageTalkDown(widget.presetMessage.messageBodyTalkDown);
    //     cIP.setCurrentSubPage(1);
    //   },
    // );
  }
}

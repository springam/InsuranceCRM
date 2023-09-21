import 'package:flutter/material.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';


class AlertMessage extends StatefulWidget {
  const AlertMessage({required this.title, required this.alertMessage, super.key});

  final String title;
  final String alertMessage;

  @override
  State<AlertMessage> createState() => AlertMessageState();
}

class AlertMessageState extends State<AlertMessage> {

  final TextEditingController newTagController = TextEditingController();

  TextStyle buttonTextStyle = const TextStyle(
      color:  Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "NotoSansCJKKR",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextMessageNormal(widget.title, 16.0),
      content: TextMessageNormal(widget.alertMessage, 14.0),
      actions: [
        ElevatedButton(
          child: const Text('확인'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

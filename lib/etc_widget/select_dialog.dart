import 'package:flutter/material.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';


class SelectMessage extends StatefulWidget {
  const SelectMessage({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  State<SelectMessage> createState() => SelectMessageState();
}

class SelectMessageState extends State<SelectMessage> {

  final TextEditingController newTagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 484,
        height: 295,
        decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            const SizedBox(height: 45),
            TextMessage(
                widget.title,
                const Color(0xff000000),
                FontWeight.w700,
                20.0
            ),
            const SizedBox(height: 26),
            TextMessageNormal(widget.message, 14.0),
            const SizedBox(height: 48),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xfff0f0f0),
                      foregroundColor: const Color(0xff000000), //버튼 글씨 색
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0
                      ),
                      padding: const EdgeInsets.only(left: 90, top: 13, right: 90, bottom: 13)
                  ),
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff218ff4),
                      foregroundColor: const Color(0xffffffff), //버튼 글씨 색
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0
                      ),
                      padding: const EdgeInsets.only(left: 90, top: 13, right: 90, bottom: 13)
                  ),
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

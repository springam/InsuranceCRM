import 'package:flutter/material.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';

import '../user_data/user_data.dart';

class TagPopupDialog extends StatefulWidget {
  const TagPopupDialog({super.key});

  @override
  State<TagPopupDialog> createState() => _TagPopupDialogState();
}

class _TagPopupDialogState extends State<TagPopupDialog> {

  final TextEditingController newTagController = TextEditingController();
  String tagErrorMessage = '';
  String newTag = '';

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
      title: const TextMessageNormal('새로운 태그를 추가하세요.', 16.0),
      content: SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextMessageNormal(tagErrorMessage, 14.0),
            const SizedBox(height: 20),
            Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: newTagController,
                style: buttonTextStyle,
                decoration: const InputDecoration(
                    // enabledBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                    // ),
                    // border: InputBorder.none
                ),
                onChanged: (value) {
                  if (value.length > 7) {
                    newTagController.text = newTag;
                  } else {
                    tagErrorMessage = '7자 이내로 입력해 주세요.';
                  }
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text('추가'),
          onPressed: () {
            if (TagList.tagList.contains(newTagController.text)) {
              setState(() {
                tagErrorMessage = '같은 태크가 존재합니다.';
              });
            } else {
              setState(() {
                TagList.tagList.add(newTagController.text);
              });
              Navigator.pop(context, true);
            }
          },
        ),
        ElevatedButton(
          child: const Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

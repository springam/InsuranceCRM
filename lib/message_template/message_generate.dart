import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/message_template/theme_list.dart';

import '../etc_widget/tag_dialog_message.dart';
import '../etc_widget/text_message.dart';
import '../user_data/user_data.dart';
import '../send_message/send_message_friends/tag_list.dart';


class MessageGenerate extends StatefulWidget {
  const MessageGenerate({super.key});

  @override
  State<MessageGenerate> createState() => _MessageGenerateState();
}

class _MessageGenerateState extends State<MessageGenerate> {

  final TextEditingController messageController = TextEditingController();
  final TextEditingController messageTalkDownController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SelectedTheme.selectedTheme = [];
  }

  List<Widget> themeList() {
    return List<Widget>.generate(
        ThemeList.themeList.length, (themeIndex) => ThemeListChip(themeIndex: themeIndex,)).toList();
  }

  Future<void> saveData() async{
    final docRef = FirebaseFirestore.instance.collection('message').doc();
    await docRef.set({
      'document_id': docRef.id,
      'creation_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(DateTime.now()),
      'consumed_count': 0,
      'custom_message': false,
      'made_by': UserData.userDocumentId,
      'message_body': messageController.text,
      'message_body_talk_down': messageTalkDownController.text,
      'subject_index': SelectedTheme.selectedTheme,
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text('입력자: ${UserData.userNickname}'),
        const Text('커스텀 메시지: false'),
        const Text ('사용된 횟수: 0'),
        Container(
          height: 58,
          decoration: const BoxDecoration(
              color: Color(0xfff0f0f0)
          ),
          child: Row(
            children: [
              Wrap(
                spacing: 3,
                children: themeList(),
              ),

              Container(
                width: 33,
                height: 33,
                margin: const EdgeInsets.only(left: 7),
                alignment: Alignment.center,
                child: Material(
                  color: const Color(0xfff0f0f0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(33),
                    splashColor: const Color(0xffffdf8e),
                    hoverColor: Colors.grey,
                    child: Ink(
                      width: 33,
                      height: 33,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(33)),
                        color: Color(0xffffffff),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Text('+', style: TextStyle(color: Colors.black, fontSize: 14.0)),
                      ),
                    ),
                    onTap: () {
                      if (TagList.tagList.length < 20) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const TagPopupDialog();
                            }
                        ).then((value) {
                          setState(() {});
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('더이상 태그를 추가할 수 없습니다.'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('확인')
                                  )
                                ],
                              );
                            }
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 310,
          width: double.infinity,
          color: const Color(0xffffffff),
          padding: const EdgeInsets.all(5),
          child: TextField(
            controller: messageController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: buttonTextStyle,
            decoration: const InputDecoration(
                hintText: '내용을 입력해 주세요',
                labelText: '존대 메시지',
                // enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                // ),
                border: InputBorder.none
            ),
            onChanged: (value) {

            },
          ),
        ),
        Container(
          height: 310,
          width: double.infinity,
          color: const Color(0xffffffff),
          padding: const EdgeInsets.all(5),
          child: TextField(
            controller: messageTalkDownController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: buttonTextStyle,
            decoration: const InputDecoration(
                hintText: '내용을 입력해 주세요',
                labelText: '반말 메시지',
                // enabledBorder: OutlineInputBorder(
                //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                // ),
                border: InputBorder.none
            ),
            onChanged: (value) {

            },
          ),
        ),

        ElevatedButton(
            onPressed: () {
              saveData();
            },
            child: const Text('확인 작업 없습니다. 한 번 더 보고 저장해 주세요.')
        )
      ],
    );
  }
}

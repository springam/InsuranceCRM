import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/message_template/theme_list.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/image_provider.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/user_provider.dart';
import '../etc_widget/text_message.dart';
import '../send_message/message_templates/message_theme_subject.dart';

class MessageModify extends StatefulWidget {
  const MessageModify({super.key});

  @override
  State<MessageModify> createState() => _MessageModifyState();
}

class _MessageModifyState extends State<MessageModify> {

  late TextMessageProvider tIP;
  late SendMessageFriendsItemProvider sIP;
  late MessageItemProvider mIP;
  late CurrentPageProvider cIP;
  late ImageCardItemProvider iIP;
  late UserItemProvider uIP;

  final ScrollController mainController = ScrollController();
  final ScrollController imageController = ScrollController();

  final TextEditingController messageController = TextEditingController();
  final TextEditingController messageTalkDownController = TextEditingController();

  final leftFormKey = GlobalKey<FormState>();
  final rightFormKey = GlobalKey<FormState>();

  List<PresetMessageItem> messageList = [];
  List<ImageCardItem> imageList = [];
  int gridCount = 0;
  int crossCountGrid = 5;

  Color selectedColor = const Color(0xffc9ced9);
  Color normalColor = const Color(0xfff0f0f0);
  Color messageColor = const Color(0xffc9ced9);
  Color imageColor = const Color(0xfff0f0f0);
  bool titleIsMessage = true;
  bool modifyMessage = false;

  @override
  void initState() {
    super.initState();
    SendMessageFriendsItemProvider().addListener(() { });
    MessageItemProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
    ImageCardItemProvider().addListener(() { });
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    MessageItemProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    ImageCardItemProvider().removeListener(() { });
    super.dispose();
  }

  Future<void> deleteImageCard(ImageCardItem imageCard) async {
    Reference ref = FirebaseStorage.instance.ref().child('card');
    await ref.child('/${imageCard.fileName}.png').delete();

    final docRef = FirebaseFirestore.instance.collection('image');
    await docRef.doc(imageCard.documentId).delete();
  }

  Future<void> saveData(PresetMessageItem presetMessage) async {
    final docRef = FirebaseFirestore.instance.collection('message').doc(presetMessage.documentId);
    await docRef.update({
      'creation_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(DateTime.now()),
      'made_by': UserData.userDocumentId,
      'message_body': messageController.text,
      'message_body_talk_down': messageTalkDownController.text,
      'subject_index': SelectedTheme.selectedTheme,
    });
  }

  Future<void> deleteData(PresetMessageItem presetMessage) async {
    final docRef = FirebaseFirestore.instance.collection('message').doc(presetMessage.documentId);
    await docRef.delete();
  }

  Widget messageGridViewBoxM(PresetMessageItem presetMessage) {

    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xffffffff)
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent
              ),
              child: Text(
                presetMessage.messageBody,
                style: const TextStyle(fontSize: 12.0),
              ),

            ),
          ],
        )
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {

              SelectedTheme.selectedTheme = [];

              for (var value in presetMessage.subjectIndex) {
                SelectedTheme.selectedTheme.add(value);
              }

              messageController.text = presetMessage.messageBody;
              messageTalkDownController.text = presetMessage.messageBodyTalkDown;

              return AlertDialog(
                title: const Text('Preset Message'),
                content: SizedBox(
                  width: 1150,
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 1,
                        children: themeList(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: 280,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                ),
                                child: Form(
                                  key: leftFormKey,
                                  child: TextFormField(
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
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return '내용을 입력해 주세요.';
                                    //   }
                                    // },
                                    onSaved: (value) {},
                                    onChanged: (value) {},
                                  ),
                                )
                            ),
                          ),

                          Expanded(
                            child: Container(
                              height: 280,
                              width: double.infinity,
                              // color: const Color(0xffffffff),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0),
                              ),
                              child: Form(
                                key: rightFormKey,
                                child: TextFormField(
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
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return '내용을 입력해 주세요.';
                                  //   }
                                  // },
                                ),
                              ),

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        deleteData(presetMessage);
                        Navigator.of(context).pop();
                      },
                      child: const Text('삭제')
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                      onPressed: () {
                        saveData(presetMessage);
                        Navigator.of(context).pop();
                      },
                      child: const Text('저장')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('취소')
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Widget imageGridViewBoxM(ImageCardItem imageCard, bool modifyMessage) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xffffffff)
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ImageNetwork(
                    image: imageCard.imagePath,
                    height: 250,
                    width: constraints.maxWidth,
                    fitWeb: BoxFitWeb.fill,
                    borderRadius: BorderRadius.circular(10),
                    // onLoading: const CircularProgressIndicator(
                    //   color: Colors.indigoAccent,
                    // ),
                    duration: 100,
                    onPointer: true,
                    onLoading: const SizedBox(),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Image'),
                              content: const Text('Are you sure?'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      await deleteImageCard(imageCard).then((value) => Navigator.of(context).pop());
                                    },
                                    child: const Text('ok')
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('cancel')
                                ),
                              ],
                            );
                          }
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
    );
  }

  List<Widget> themeListTitle(int sectionIndex) {

    int listCount = 0;
    int additionCount = 0;

    switch (sectionIndex) {
      case 0:
        listCount = 6;
        additionCount = 0;
        break;
      case 1:
        listCount = 3;
        additionCount = 6;
      case 2:
        listCount = 2;
        additionCount = 9;
        break;
    }

    return List<Widget>.generate(
        listCount, (themeIndex) => MessageThemeSubject(themeIndex: themeIndex + additionCount,)).toList();
  }

  List<Widget> themeList() {
    return List<Widget>.generate(
        ThemeList.themeList.length, (themeIndex) => ThemeListChip(themeIndex: themeIndex,)).toList();
  }

  @override
  Widget build(BuildContext context) {

    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    mIP = Provider.of<MessageItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    iIP = Provider.of<ImageCardItemProvider>(context, listen: true);
    uIP = Provider.of<UserItemProvider>(context);

    messageList = [];
    imageList = [];

    for (var message in mIP.getItem()) {
      if (message.subjectIndex.contains(cIP.getSelectedThemeIndex())) {
        messageList.add(message);
      }
    }

    for (var image in iIP.getItem()) {
      if (image.subjectIndex.contains(cIP.getSelectedThemeIndex())) {
        imageList.add(image);
      }
    }

    if (MediaQuery.of(context).size.width < 1500 || MediaQuery.of(context).size.height < 720) {
      crossCountGrid = 4;
    }

    (titleIsMessage) ? gridCount = messageList.length : gridCount = imageList.length;

    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color.fromRGBO(0, 0, 0, 0.5),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 36),
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                InkWell(
                  child: Container(
                    width: 130,
                    height: 40,
                    alignment: Alignment.center,
                    color: messageColor,
                    child: const TextMessage400('메시지', 14.0),
                  ),
                  onTap: () {
                    if (!titleIsMessage) {
                      setState(() {
                        titleIsMessage = true;
                        messageColor = selectedColor;
                        imageColor = normalColor;
                      });
                    }
                  },
                ),

                const SizedBox(width: 5),

                InkWell(
                  child: Container(
                    width: 130,
                    height: 40,
                    alignment: Alignment.center,
                    color: imageColor,
                    child: const TextMessage400('이미지', 14.0),
                  ),
                  onTap: () {
                    if (titleIsMessage) {
                      setState(() {
                        titleIsMessage = false;
                        messageColor = normalColor;
                        imageColor = selectedColor;
                      });
                    }
                  },
                ),

              ],
            ),
          ),

          Container(
            height: 40,
            color: selectedColor,
            margin: const EdgeInsets.only(right: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 80),

                Wrap(spacing: 20, children: themeListTitle(0)),

                Container(
                  margin: const EdgeInsets.only(left: 25, top:10, right: 25, bottom: 10),
                  child: const VerticalDivider(width: 1, thickness: 1, color: Colors.white),
                ),

                Wrap(spacing: 20, children: themeListTitle(1)),

                Container(
                  margin: const EdgeInsets.only(left: 25, top: 5, right: 25, bottom: 5),
                  child: const VerticalDivider(width: 1, thickness: 1, color: Colors.white),
                ),

                Wrap(spacing: 20, children: themeListTitle(2)),
              ],
            ),
          ),

          Container(
              height: MediaQuery.of(context).size.height * 0.7,
              color: normalColor,
              margin: const EdgeInsets.only(right: 36),
              padding: const EdgeInsets.only(left: 40, top: 30, right: 40, bottom: 30),
              child: Scrollbar(
                controller: mainController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 12.0,
                child: GridView.builder(
                    controller: mainController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                        crossAxisCount: crossCountGrid,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.0
                    ),
                    itemCount: gridCount,
                    itemBuilder: (BuildContext context, int index) {
                      return (titleIsMessage) ? messageGridViewBoxM(messageList[index]) :
                      imageGridViewBoxM(imageList[index], modifyMessage);
                    }
                ),
              )
          ),

        ],
      ),
    );
  }
}

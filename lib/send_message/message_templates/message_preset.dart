import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';
import '../../user_data/message_provider.dart';
import 'message_preset_gridview_box.dart';
import 'message_theme_subject.dart';

class MessagePreset extends StatefulWidget {
  const MessagePreset({super.key});

  @override
  State<MessagePreset> createState() => _MessagePresetState();
}

class _MessagePresetState extends State<MessagePreset> {

  late SendMessageFriendsItemProvider sIP;
  late MessageItemProvider mIP;
  late CurrentPageProvider cIP;

  final ScrollController controller = ScrollController();

  List<PresetMessageItem> messageList = [];

  Color selectedColor = const Color(0xffc9ced9);
  Color normalColor = const Color(0xfff0f0f0);
  Color messageColor = const Color(0xffc9ced9);
  Color imageColor = const Color(0xfff0f0f0);
  bool titleIsMessage = true;

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

  @override
  Widget build(BuildContext context) {

      sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
      mIP = Provider.of<MessageItemProvider>(context, listen: true);
      cIP = Provider.of<CurrentPageProvider>(context, listen: true);

      messageList = [];

      for (var message in mIP.getItem()) {
        if (message.subjectIndex.contains(cIP.getSelectedThemeIndex())) {
          messageList.add(message);
        }
      }

      return Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(107, 107, 107, 0.5),
        padding: const EdgeInsets.only(left: 140, top: 70, right: 140, bottom: 70),
        child: Container(
          // margin: const EdgeInsets.only(left: 36),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, right: 36),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [

                            InkWell(
                              child: Container(
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                color: messageColor,
                                child: const Text(
                                  '메시지',
                                  style: TextStyle(
                                      color:  Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      // fontFamily: "NotoSansCJKKR",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 14
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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
                                width: 100,
                                height: 40,
                                alignment: Alignment.center,
                                color: imageColor,
                                child: const Text(
                                  '이미지',
                                  style: TextStyle(
                                      color:  Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      // fontFamily: "NotoSansCJKKR",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 14
                                  ),
                                  textAlign: TextAlign.center,
                                ),
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

                        IconButton(
                          icon: const Icon(Icons.cancel_rounded),
                          color: Colors.grey,
                          iconSize: 20,
                          onPressed: () {
                            cIP.setCurrentSubPage(1);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),

              Container(
                height: 40,
                color: selectedColor,
                margin: const EdgeInsets.only(right: 36),
                child: Row(
                  children: [
                    const SizedBox(width: 25),

                    Wrap(spacing: 10, children: themeListTitle(0)),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top:10, right: 25, bottom: 10),
                      child: const VerticalDivider(width: 1, thickness: 1, color: Colors.white),
                    ),

                    Wrap(spacing: 10, children: themeListTitle(1)),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 5, right: 25, bottom: 5),
                      child: const VerticalDivider(width: 1, thickness: 1, color: Colors.white),
                    ),

                    Wrap(spacing: 10, children: themeListTitle(2)),
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                  color: normalColor,
                  margin: const EdgeInsets.only(right: 36),
                  padding: const EdgeInsets.only(left: 40, top: 30, right: 40, bottom: 30),
                  child: Scrollbar(
                    controller: controller,
                    thumbVisibility: true,
                    trackVisibility: true,
                    thickness: 12.0,
                    child: GridView.builder(
                        controller: controller,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount (
                            crossAxisCount: 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 20,
                            childAspectRatio: 1.5
                        ),
                        itemCount: messageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GridViewBox(presetMessage: messageList[index]);
                        }
                    ),
                  )
              ),

            ],
          ),
        ),
      );
    }
}

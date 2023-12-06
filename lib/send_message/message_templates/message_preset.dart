import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/image_provider.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/user_provider.dart';
import 'image_gridview_box.dart';
import 'message_gridview_box.dart';
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
  late ImageCardItemProvider iIP;
  late UserItemProvider uIP;

  final ScrollController controller = ScrollController();

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

      if (MediaQuery.of(context).size.width < 1500) {
        crossCountGrid = 4;
      }

      (titleIsMessage) ? gridCount = messageList.length : gridCount = imageList.length;

      return Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(0, 0, 0, 0.5),
        padding: const EdgeInsets.only(left: 140, top: 70, right: 140, bottom: 70),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, right: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        child: Container(
                          width: 130,
                          height: 40,
                          alignment: Alignment.center,
                          color: messageColor,
                          child: const Text(
                            '메시지',
                            style: TextStyle(
                                color:  Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansCJKkr-Regular",
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
                          width: 130,
                          height: 40,
                          alignment: Alignment.center,
                          color: imageColor,
                          child: const Text(
                            '이미지',
                            style: TextStyle(
                                color:  Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansCJKkr-Regular",
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

                  // (UserData.userTier == 'master' && cIP.getMainPage() == 5) ? IconButton(
                  //   icon: (UserData.userTier == 'master') ? const Icon(Icons.settings) : const Icon(Icons.stop),
                  //   color: Colors.white,
                  //   iconSize: 20,
                  //   onPressed: () {
                  //     setState(() {
                  //       if (modifyMessage) {
                  //         modifyMessage = false;
                  //       } else {
                  //         modifyMessage = true;
                  //       }
                  //     });
                  //   },
                  // ) : const SizedBox(),

                  IconButton(
                    icon: const Icon(Icons.cancel_rounded),
                    color: Colors.white,
                    iconSize: 20,
                    onPressed: () {
                      cIP.setCurrentSubPage(1);
                    },
                  )
                ],
              )
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
                  controller: controller,
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 12.0,
                  child: GridView.builder(
                      controller: controller,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (
                          crossAxisCount: crossCountGrid,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.0
                      ),
                      itemCount: gridCount,
                      itemBuilder: (BuildContext context, int index) {
                        return (titleIsMessage) ? GridViewBox(presetMessage: messageList[index]) :
                        ImageGridViewBox(imageCard: imageList[index], modifyMessage: modifyMessage,);
                      }
                  ),
                )
            ),

          ],
        ),
      );
    }
}

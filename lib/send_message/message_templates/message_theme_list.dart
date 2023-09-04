import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';

import '../../user_data/registered_friends_provider.dart';
import '../../user_data/status_provider.dart';

class MessageThemeListChip extends StatefulWidget {
  const MessageThemeListChip({required this.themeIndex, super.key});

  final int themeIndex;

  @override
  State<MessageThemeListChip> createState() => _MessageThemeListChipState();
}

class _MessageThemeListChipState extends State<MessageThemeListChip> {

  late RegisteredFriendsItemProvider fIP;
  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;

  Color selectedColor = const Color(0xffffffff);
  bool selectedTile = false;
  // String selectedTag = '';
  // List<RegisteredFriendsItem> selectedMessageFriends = [];

  @override
  void initState() {
    super.initState();
    // selectedTag = TagList.tagList[widget.tagIndex];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context);

    return Container(
      width: 105,
      height: 33,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Material(
        color: const Color(0xfff0f0f0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xffffdf8e),
          hoverColor: const Color(0xffbcc0c7),
          child: Ink(
            // width: 88,
            // height: 21,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: selectedColor
            ),
            child: Center(
              child: Text(
                  (widget.themeIndex < ThemeList.themeList.length) ?
                  '#${ThemeList.themeList[widget.themeIndex]}' : '더보기',
                  style: const TextStyle(
                      color:  Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              ),
            ),
          ),
          onTap: () {
            cIP.setCurrentSubPage(2);
            cIP.setSelectedThemeIndex(widget.themeIndex);
          },
        ),
      ),
    );

  }
}

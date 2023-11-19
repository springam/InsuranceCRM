import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/status_provider.dart';

class MessageThemeListChip extends StatefulWidget {
  const MessageThemeListChip({required this.themeIndex, super.key});

  final int themeIndex;

  @override
  State<MessageThemeListChip> createState() => _MessageThemeListChipState();
}

class _MessageThemeListChipState extends State<MessageThemeListChip> {

  late CurrentPageProvider cIP;

  Color selectedColor = const Color(0xffffffff);
  bool selectedTile = false;
  // String selectedTag = '';
  // List<RegisteredFriendsItem> selectedMessageFriends = [];

  @override
  void initState() {
    super.initState();
    CurrentPageProvider().addListener(() { });
  }

  @override
  void dispose() {
    CurrentPageProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    cIP = Provider.of<CurrentPageProvider>(context);

    if (cIP.selectedThemeIndex == widget.themeIndex) {
      selectedColor = const Color(0xffd7e3f7);
    } else {
      selectedColor = const Color(0xffffffff);
    }

    return Container(
      width: 90,
      height: 25,
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
                  ThemeList.themeList[widget.themeIndex],
                  style: const TextStyle(
                      color:  Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 12.0
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

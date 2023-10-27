import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';

import '../../user_data/registered_friends_provider.dart';

class ThemeListChip extends StatefulWidget {
  const ThemeListChip({required this.themeIndex, super.key});

  final int themeIndex;

  @override
  State<ThemeListChip> createState() => _ThemeListChipState();
}

class _ThemeListChipState extends State<ThemeListChip> {

  late RegisteredFriendsItemProvider fIP;
  late SendMessageFriendsItemProvider sIP;

  Color chipColor = const Color(0xffffffff);
  Color selectedColor = const Color(0xffbcc0c7);
  Color unSelectedColor = const Color(0xffffffff);
  bool selectedTile = false;
  List<RegisteredFriendsItem> selectedMessageFriends = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    if (SelectedTheme.selectedTheme.contains(widget.themeIndex)) {
      chipColor = selectedColor;
    } else {
      chipColor = unSelectedColor;
    }

    return Container(
      width: 105,
      height: 33,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 7),
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
                color: chipColor
            ),
            child: Center(
              child: Text(
                  '#${ThemeList.themeList[widget.themeIndex]}',
                  style: const TextStyle(
                      color:  Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      // fontFamily: "NotoSansCJKKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              ),
            ),
          ),
          onTap: () {
            if (SelectedTheme.selectedTheme.contains(widget.themeIndex)) {
              setState(() {
                SelectedTheme.selectedTheme.remove(widget.themeIndex);
              });
            } else {
              setState(() {
                SelectedTheme.selectedTheme.add(widget.themeIndex);
              });
            }
          },
        ),
      ),
    );
  }
}



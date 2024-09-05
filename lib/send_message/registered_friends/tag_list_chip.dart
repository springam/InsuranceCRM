import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/theme_set.dart';
import '../../user_data/registered_friends_provider.dart';

class TagListChip extends StatefulWidget {
  const TagListChip({required this.tagIndex, super.key});

  final int tagIndex;

  @override
  State<TagListChip> createState() => _TagListChipState();
}

class _TagListChipState extends State<TagListChip> {

  late RegisteredFriendsItemProvider fIP;
  late SendMessageFriendsItemProvider sIP;

  Color selectedColor = const Color(0xffffffff);
  bool selectedTile = false;
  String selectedTag = '';
  List<RegisteredFriendsItem> selectedMessageFriends = [];

  @override
  void initState() {
    super.initState();
    RegisteredFriendsItemProvider().addListener(() { });
    SendMessageFriendsItemProvider().addListener(() { });
    selectedTag = TagList.tagList[widget.tagIndex];
  }

  @override
  void dispose() {
    RegisteredFriendsItemProvider().removeListener(() { });
    SendMessageFriendsItemProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    if (sIP.getItem().length == 0) {
      selectedColor = const Color(0xffffffff);
      selectedTile = false;
    }

    return Container(
      width: 105,
      height: 28,
      alignment: Alignment.center,
      color: const Color(0xffe5e8ec),
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: Material(
        color: const Color(0xffe5e8ec),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xffffdf8e),
          hoverColor: ThemeSet.hoverColor,
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: selectedColor
            ),
            child: Center(
              child: Text(
                  '#${TagList.tagList[widget.tagIndex]}',
                  style: TextStyle(
                      color:  ThemeSet.blackColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  )
              ),
            ),
          ),
          onTap: () {
            if (selectedTile) {
              selectedMessageFriends = [];
              for (int i = 0; i < sIP.getItem().length + 1; i++) {
                if (i == sIP.getItem().length) {
                  sIP.setItem(selectedMessageFriends);
                  setState(() {
                    selectedColor = const Color(0xffffffff);
                    selectedTile = false;
                  });
                } else {
                  if (!sIP.getItem()[i].tag.contains(selectedTag)) {
                    selectedMessageFriends.add(sIP.getItem()[i]);
                  }
                }
              }
            } else {
              for (RegisteredFriendsItem registeredFriend in fIP.getItem()) {
                if (registeredFriend.tag.contains(selectedTag)) {
                  if (!sIP.getItem().contains(registeredFriend)) {
                    sIP.addItem(registeredFriend);
                  }
                }
              }
              setState(() {
                selectedColor = const Color(0xffd7e3f7);
                selectedTile = true;
              });
            }
          },
        ),
      ),
    );
  }
}



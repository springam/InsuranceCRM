import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';

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
    selectedTag = TagList.tagList[widget.tagIndex];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

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
                color: selectedColor
            ),
            child: Center(
              child: Text(
                '#${TagList.tagList[widget.tagIndex]}',
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



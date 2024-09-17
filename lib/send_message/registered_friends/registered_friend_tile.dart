import 'package:flutter/material.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:provider/provider.dart';
import '../../etc_widget/theme_set.dart';
import '../../user_data/registered_friends_provider.dart';

class RegisteredFriendTile extends StatefulWidget {
  const RegisteredFriendTile(this.registeredFriend, {super.key});

  final RegisteredFriendsItem registeredFriend;

  @override
  State<RegisteredFriendTile> createState() => _RegisteredFriendTileState();
}

class _RegisteredFriendTileState extends State<RegisteredFriendTile> {

  late SendMessageFriendsItemProvider sIP;

  Color selectedColor = const Color(0xffffffff);
  Color selectedBorderColor = const Color(0xff000000);
  bool selectedTile = false;

  @override
  void initState() {
    super.initState();
    SendMessageFriendsItemProvider().addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    super.dispose();
  }

  List<Widget> tagItem() {
    return List<Widget>.generate(widget.registeredFriend.tag.length, (index) =>
        TextMessageNormal('#${widget.registeredFriend.tag[index]}', 12.0)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    if (sIP.getItem().length != 0 && sIP.getItem().contains(widget.registeredFriend)) {
      selectedColor = const Color(0xffd7e3f7);
      selectedBorderColor = const Color(0xffbcc0c7);
      selectedTile = true;
    } else if (sIP.getItem().length == 0 || !sIP.getItem().contains(widget.registeredFriend)) {
      selectedColor = const Color(0xffffffff);
      selectedBorderColor = const Color(0xff000000);
      selectedTile = false;
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 30,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 7),
              padding: const EdgeInsets.only(left: 13, top: 3, right: 13, bottom: 3),
              // color: const Color(0xffffffff),
              child: Material(
                // color: const Color(0xffffffff),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  splashColor: const Color(0xffffdf8e),
                  hoverColor: ThemeSet.hoverColor,
                  child: Ink(
                    width: double.infinity,
                    height: 34,
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedBorderColor, width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: selectedColor,
                    ),
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(
                        widget.registeredFriend.kakaoNickname,
                        style: buttonTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  onTap: () {
                    if (selectedTile) {
                      sIP.removeItem(widget.registeredFriend);
                      selectedColor = const Color(0xffffffff);
                      selectedBorderColor = const Color(0xff000000);
                      selectedTile = false;
                      // setState(() {
                      //   selectedColor = const Color(0xffffffff);
                      //   selectedBorderColor = const Color(0xff000000);
                      //   selectedTile = false;
                      // });
                    } else {
                      if (!sIP.getItem().contains(widget.registeredFriend)) {
                        sIP.addItem(widget.registeredFriend);
                        selectedColor = const Color(0xffd7e3f7);
                        selectedBorderColor = const Color(0xff000000); //변화 안 줄거면 지워
                        selectedTile = true;
                        // setState(() {
                        //   selectedColor = const Color(0xffd7e3f7);
                        //   selectedBorderColor = const Color(0xff000000); //변화 안 줄거면 지워
                        //   selectedTile = true;
                        // });
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.registeredFriend.name,
                style: const TextStyle(
                    color:  Color(0xff000000),
                    fontWeight: FontWeight.w100,
                    fontFamily: "NotoSansCJKkr-Regular",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                (widget.registeredFriend.talkDown == 0) ? '존대' : '반말',
                style: const TextStyle(
                    color:  Color(0xff000000),
                    fontWeight: FontWeight.w100,
                    // fontFamily: "Inter",
                    fontFamily: "NotoSansCJKkr-Regular",
                    fontStyle:  FontStyle.normal,
                    fontSize: 12.0
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 20,
                children: tagItem(),
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

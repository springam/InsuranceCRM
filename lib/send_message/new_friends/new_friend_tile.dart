import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';

import '../registered_friends/registered_friends.dart';
import '../select_friends.dart';

class NewFriendTile extends StatefulWidget {
  const NewFriendTile(this.index, this.friends, {super.key});

  final int index;
  final Friends friends;

  @override
  State<NewFriendTile> createState() => _NewFriendTileState();
}

class _NewFriendTileState extends State<NewFriendTile> {

  late Friends friends = widget.friends;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  int selectedIndex = 2;
  int selectedFilterIndex = 10;
  List<String> options = ['존대', '반말'];

  double xMousePosition = 0.0;
  double yMousePosition = 0.0;
  bool enterBox = false;

  String testMsg = 'none';
  int selectedOption = 5;
  List<String> sharpTag =  TagList.tagList;
  List<String> selectedSharpTag = [];

  TextStyle buttonTextStyle = const TextStyle(
      color:  Color(0xff000000),
      fontWeight: FontWeight.w400,
      fontFamily: "NotoSansCJKKR",
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );

  List<Widget> selectChip() {
    return List<Widget>.generate(2, (optionIndex) => SizedBox(
      height: 26,
      child: FilterChip(
        // padding: const EdgeInsets.all(5),
        selectedColor: const Color(0xffd9d9d9),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        selected: selectedIndex == optionIndex,
        showCheckmark: false,
        label: Text(options[optionIndex]),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        labelStyle: buttonTextStyle,
        avatar: null,
        onSelected: (selected) {
          setState(() {
            selectedIndex = (selected) ? optionIndex : 2;
            selectedOption = optionIndex;
            testMsg = optionIndex.toString();
          });
        },
      ),
    )).toList();
  }

  List<Widget> filterChip() {
    return List<Widget>.generate(sharpTag.length, (optionIndex) => SizedBox(
      height: 26,
      child: FilterChip(
        label: Text('#${sharpTag[optionIndex]}', style: const TextStyle(fontSize: 12.0)),
        padding: const EdgeInsets.symmetric(vertical: -3, horizontal: -3),
        shape: const StadiumBorder(
          side: BorderSide(color: Color(0xff000000), width: 1.0)
        ),
        selected: selectedSharpTag.contains(sharpTag[optionIndex]),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        showCheckmark: false,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              selectedSharpTag.add(sharpTag[optionIndex]);
              testMsg = 'add $optionIndex';
            } else {
              selectedSharpTag.remove(sharpTag[optionIndex]);
              testMsg = 'remove $optionIndex';
            }
            debugPrint(selectedSharpTag.toString());
          });
        },
      ),
    )).toList();
  }

  void enterBoxArea(PointerEvent details) {
    setState(() {
      enterBox = true;
    });
  }

  void exitBoxArea(PointerEvent details) {
    setState(() {
      enterBox = false;
    });
  }

  // void updateLocation(PointerEvent details) {
  //   setState(() {
  //     xMousePosition = details.position.dx;
  //     yMousePosition = details.position.dy;
  //   });
  // }

  Future<void> notRegisterFriends() async{
    final docRef = FirebaseFirestore.instance.collection('friends').doc();
    await docRef.set({
      'document_id': docRef.id,
      'etc': '',
      'kakao_id': friends.elements?[widget.index].id,
      'kakao_nickname': friends.elements?[widget.index].profileNickname,
      'kakao_uuid': friends.elements?[widget.index].uuid,
      'managed_count': 0,
      'managed_last_date': '',
      'manager_id': UserData.userId,
      'name': '',
      'registered': false,
      'tag': '',
      'talk_down': '',
      'tier': 'normal'
    });
    setState(() {
      debugPrint('refuse to register');
    });
  }

  Future<void> registerFriends() async{
    final docRef = FirebaseFirestore.instance.collection('friends').doc();
    await docRef.set({
      'document_id': docRef.id,
      'etc': '',
      'kakao_id': friends.elements?[widget.index].id,
      'kakao_nickname': friends.elements?[widget.index].profileNickname,
      'kakao_uuid': friends.elements?[widget.index].uuid,
      'managed_count': 0,
      'managed_last_date': '',
      'manager_id': UserData.userId,
      'name': middleNickController.text,
      'registered': true,
      'tag': selectedSharpTag,
      'talk_down': selectedIndex,
      'tier': 'normal'
    });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: MouseRegion(
                  onEnter: enterBoxArea,
                  // onHover: updateLocation,
                  onExit: exitBoxArea,
                  child: Container(
                    height: 33,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 7),
                    // padding: const EdgeInsets.only(left: 13, top: 3, right: 13, bottom: 3),
                    color: const Color(0xffffffff),
                    child: Material(
                      color: const Color(0xffffffff),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        splashColor: const Color(0xffffffff),
                        hoverColor: const Color(0xffffffff),
                        child: Ink(
                          // width: 88,
                          // height: 21,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Color(0xffffffff),
                          ),
                          child: Text(
                            '${friends.elements?[widget.index].profileNickname}',
                            style: buttonTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                  flex: 1,
                  child: Container(
                    height: 23,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 5, left: 5),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(border: Border.all(width: 1, color: const Color(0xffd9d9d9))),
                    child: TextField(
                      controller: middleNickController,
                      style: buttonTextStyle,
                      decoration: const InputDecoration(
                        // hintText: '10자 이내로 입력해 주세요.',
                        // enabledBorder: OutlineInputBorder(
                        //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                        // ),
                          border: InputBorder.none
                      ),
                      onChanged: (value) {
                        if (value.length < 11) {
                          setState(() {
                            testMsg = value;
                          });
                        } else {
                          middleNickController.text = testMsg;
                        }
                      },
                    ),
                  )
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 3,
                    children: selectChip(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 3,
                    children: filterChip(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Text(
                      testMsg,
                      style: const TextStyle(
                          color:  Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontFamily: "NotoSansCJKKR",
                          fontStyle:  FontStyle.normal,
                          fontSize: 12.0
                      ),
                      textAlign: TextAlign.center
                  ),
                  onTap: () {
                    debugPrint('tapped');
                    registerFriends();
                  },
                ),
              )
            ],
          ),
        ),

        (enterBox) ? Positioned(
          left: 7,
          child: TextMessageNormal('${friends.elements?[widget.index].profileNickname}', 12.0),
        ) : const SizedBox()
      ],
    );
  }
}

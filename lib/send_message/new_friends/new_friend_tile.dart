import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/registered_friends_provider.dart';

class NewFriendTile extends StatefulWidget {
  const NewFriendTile({required this.friends, required this.index, required this.registering, required this.updateStateNewFriend, super.key});

  final List<String> friends;
  final int index;
  final bool registering;
  final Function() updateStateNewFriend;

  @override
  State<NewFriendTile> createState() => NewFriendTileState();
}

class NewFriendTileState extends State<NewFriendTile> {

  late List<String> friends = widget.friends;

  late RegisteredFriendsItemProvider fIP;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  DateTime now = DateTime.now();

  int selectedIndex = 2;
  int selectedFilterIndex = 10;
  List<String> options = ['반말', '존말'];

  double xMousePosition = 0.0;
  double yMousePosition = 0.0;
  bool enterBox = false;

  bool warnNick = false;
  bool warnSelectChip = false;
  bool warnTag = false;
  bool registered = false;

  Color warnColor = Colors.transparent;

  String testMsg = 'none';
  int selectedOption = 5;
  List<String> hashTag =  TagList.tagList;
  List<String> selectedHashTag = [];

  List<Widget> selectChip() {
    return List<Widget>.generate(2, (optionIndex) => SizedBox(
      height: 28,
      child: FilterChip(
        // padding: const EdgeInsets.all(5),
        selectedColor: const Color(0xffd9d9d9),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        selected: selectedIndex == optionIndex,
        showCheckmark: false,
        label: Text(options[optionIndex], textAlign: TextAlign.center,),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        labelStyle: buttonTextStyle,
        avatar: null,
        onSelected: (selected) {
          setState(() {
            selectedIndex = (selected) ? optionIndex : 2;
            selectedOption = optionIndex;
            testMsg = selectedIndex.toString();
          });
        },
      ),
    )).toList();
  }

  List<Widget> filterChip() {
    return List<Widget>.generate(hashTag.length, (optionIndex) => SizedBox(
      height: 26,
      child: FilterChip(
        label: Text('#${hashTag[optionIndex]}', style: const TextStyle(fontSize: 12.0)),
        padding: const EdgeInsets.symmetric(vertical: -3, horizontal: -3),
        shape: const StadiumBorder(
          side: BorderSide(color: Color(0xff000000), width: 1.0)
        ),
        selected: selectedHashTag.contains(hashTag[optionIndex]),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        showCheckmark: false,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              selectedHashTag.add(hashTag[optionIndex]);
              testMsg = 'add $optionIndex';
            } else {
              selectedHashTag.remove(hashTag[optionIndex]);
              testMsg = 'remove $optionIndex';
            }
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

  Future<void> notRegisterFriends(int index) async{
    final docRef = FirebaseFirestore.instance.collection('friends').doc();
    await docRef.set({
      'document_id': docRef.id,
      'etc': '',
      'kakao_id': 0,
      'kakao_nickname': friends[index],
      'kakao_uuid': 'mosaic',
      'managed_count': 0,
      'managed_last_date': '',
      'manager_id': UserData.userId,
      'name': '',
      'registered': false,
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
      'tag': [],
      'talk_down': 2,
      'tier': 'normal'
    });
  }

  Future<void> registerFriends(int index) async{

    final docRef = FirebaseFirestore.instance.collection('friends').doc();
    await docRef.set({
      'document_id': docRef.id,
      'etc': '',
      'kakao_id': 0,
      'kakao_nickname': friends[index],
      'kakao_uuid': 'mosaic',
      'managed_count': 0,
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
      'managed_last_date': '',
      'manager_id': UserData.userId,
      'name': middleNickController.text,
      'registered': true,
      'tag': selectedHashTag,
      'talk_down': selectedIndex,
      'tier': 'normal'
    });
    widget.updateStateNewFriend();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);

    if (!widget.registering) {
      if (!registered) {
        warnColor = Colors.transparent;
      } else {
        if (middleNickController.text.isNotEmpty && selectedIndex != 2 && selectedHashTag.isNotEmpty) {
          warnColor = Colors.transparent;
        } else {
          warnColor = Colors.red;
        }
      }
    }

    if (widget.registering) {
      if (middleNickController.text.isEmpty || selectedIndex == 2 || selectedHashTag.isEmpty) {
        setState(() {
          warnColor = Colors.red;
          registered = true;
        });
      } else {
        registerFriends(widget.index);
      }
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: warnColor,
              width: 1
            )
          ),
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
                            friends[widget.index],
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
                  onTap: () async{
                    await notRegisterFriends(widget.index);
                    widget.updateStateNewFriend();
                  },
                ),
              )
            ],
          ),
        ),

        (enterBox) ? Positioned(
          left: 7,
          child: TextMessageNormal(friends[widget.index], 12.0),
        ) : const SizedBox()
      ],
    );

  }
}

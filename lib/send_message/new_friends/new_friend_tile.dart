import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/response_friend_provider.dart';

class NewFriendTile extends StatefulWidget {
  const NewFriendTile({required this.index, required this.registering, super.key});

  final int index;
  final bool registering;

  @override
  State<NewFriendTile> createState() => NewFriendTileState();
}

class NewFriendTileState extends State<NewFriendTile> {

  late ResponseFriendsItemProvider resIP;
  late SendMessageFriendsItemProvider sIP;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  DateTime now = DateTime.now();

  Color selectedColor = const Color(0xffffffff);
  Color selectedBorderColor = const Color(0xff000000);
  bool selectedTile = false;

  int selectedIndex = 2;
  int selectedFilterIndex = 10;
  String nickname = '';
  List<String> options = ['존대', '반말'];

  double xMousePosition = 0.0;
  double yMousePosition = 0.0;
  bool enterBox = false;

  bool warnNick = false;
  bool warnSelectChip = false;
  bool warnTag = false;

  bool selectedItem = false;
  Color selectedItemColor = const Color(0xffffffff);

  Color warnColor = Colors.transparent;

  String testMsg = '등록안함';
  // int selectedOption = 5;
  List<String> hashTag =  TagList.tagList;
  List<dynamic> selectedHashTag = [];

  @override
  void initState() {
    super.initState();
    ResponseFriendsItemProvider().addListener(() { });
  }

  @override
  void dispose() {
    ResponseFriendsItemProvider().removeListener(() { });
    super.dispose();
  }

  List<Widget> selectChip() {
    var selectChipBackgroundColorWarn = (selectedIndex == 2) ? Colors.black : Colors.black;
    return List<Widget>.generate(2, (optionIndex) => SizedBox(
      height: 28,
      child: FilterChip(
        // padding: const EdgeInsets.all(5),
        selectedColor: const Color(0xffd7e3f7),
        side: BorderSide(color: selectChipBackgroundColorWarn, width: 1.0,),
        // backgroundColor: selectChipBackgroundColorWarn,
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
            resIP.modifyTalkDown(selectedIndex, widget.index);
          });
        },
      ),
    )).toList();
  }

  List<Widget> filterChip() {
    var filterChipBackgroundColorWarn = (selectedHashTag.isEmpty) ? Colors.transparent : Colors.transparent;
    return List<Widget>.generate(hashTag.length, (optionIndex) => SizedBox(
      height: 26,
      child: FilterChip(
        label: Text('#${hashTag[optionIndex]}', style: const TextStyle(fontSize: 12.0)),
        padding: const EdgeInsets.symmetric(vertical: -3, horizontal: -3),
        backgroundColor: filterChipBackgroundColorWarn,
        shape: const StadiumBorder(
          side: BorderSide(color: Color(0xff000000), width: 1.0)
        ),
        selected: selectedHashTag.contains(hashTag[optionIndex]),
        selectedColor: const Color(0xffd7e3f7),
        side: const BorderSide(color: Colors.black54, width: 0.5,),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        showCheckmark: false,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              selectedHashTag.add(hashTag[optionIndex]);
              resIP.modifyTag(selectedHashTag, widget.index);
              resIP.modifyTag(selectedHashTag, widget.index);
            } else {
              selectedHashTag.remove(hashTag[optionIndex]);
              resIP.modifyTag(selectedHashTag, widget.index);
            }
          });
        },
      ),
    )).toList();
  }

  void enterBoxArea(PointerEvent details) {
    setState(() {
      enterBox = true;  //영역안에 들어오면 true
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
    final docRef = FirebaseFirestore.instance.collection('friends').doc(resIP.getItem()[widget.index].documentId);
    await docRef.update({
      'document_id': docRef.id,
      'etc': '',
      'kakao_nickname': resIP.getItem()[widget.index].kakaoNickname,
      'managed_count': 0,
      'managed_last_date': '',
      'manager_email': UserData.userEmail,
      'name': '',
      'registered': 0,
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
      'tag': [],
      'talk_down': 2,
      'tier': 0
    });
    resIP.removeItem(resIP.getItem()[widget.index]);
  }

  @override
  Widget build(BuildContext context) {

    resIP = Provider.of<ResponseFriendsItemProvider>(context, listen: true);
    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);

    nickname = resIP.getItem()[widget.index].kakaoNickname?? '';
    middleNickController.text = resIP.getItem()[widget.index].name?? '';
    selectedIndex = resIP.getItem()[widget.index].talkDown?? 2;
    selectedHashTag = resIP.getItem()[widget.index].tag?? [];

    if (sIP.getItem().contains(resIP.getItem()[widget.index])) {
      selectedItem = true;
      selectedItemColor = const Color(0xffd7e3f7);
    } else {
      selectedItem = false;
      selectedItemColor = const Color(0xffffffff);
    }

    //여기서 문제 됨
    //아래 내용 확인하고 변경해야 함

    // if (middleNickController.text.isNotEmpty && selectedIndex != 2 && selectedHashTag.isNotEmpty) {
    //   warnColor = Colors.transparent;
    //   resIP.modifyRegistered(1, widget.index);
    // } else {
    //   warnColor = Colors.red;
    //   resIP.modifyRegistered(0, widget.index);
    // }


    // if (widget.registering) {
    //   if (middleNickController.text.isNotEmpty && selectedIndex != 2 && selectedHashTag.isNotEmpty) {
    //     warnColor = Colors.transparent;
    //     ResponseFriendItem.responseFriend[widget.index].registered = true;
    //   } else {
    //     warnColor = Colors.red;
    //     ResponseFriendItem.responseFriend[widget.index].registered = false;
    //   }
    // } else {
    //   warnColor = Colors.transparent;
    // }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          // decoration: BoxDecoration(
          //   border: Border.all(
          //     color: warnColor,
          //     width: 1
          //   )
          // ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: MouseRegion(
                  // onEnter: enterBoxArea, //영역 감지
                  // onHover: updateLocation,
                  // onExit: exitBoxArea,
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
                        splashColor: const Color(0xffffdf8e), //0xffffffff
                        hoverColor: const Color(0xffbcc0c7),
                        child: Ink(
                          width: double.infinity,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(color: selectedBorderColor, width: 1.0),
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                            color: selectedItemColor,
                          ),
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(left: 10, top: 2),
                            child: Text(
                              nickname,
                              style: buttonTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        onTap: () {
                          if (selectedItem) {
                            sIP.removeItem(resIP.getItem()[widget.index]);
                            setState(() {
                              selectedItem = false;
                            });
                          } else {
                            if (!sIP.getItem().contains(resIP.getItem()[widget.index])) {
                              sIP.addItem(resIP.getItem()[widget.index]);
                              setState(() {
                                selectedItem = true;
                              });
                            }
                          }
                        },
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
                    child: Form(
                      child: TextFormField(
                        controller: middleNickController,
                        style: buttonTextStyle,
                        decoration: const InputDecoration(
                          // hintText: '10자 이내로 입력해 주세요.',
                          // enabledBorder: OutlineInputBorder(
                          //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                          // ),
                            isDense: true,
                            border: InputBorder.none
                        ),
                        onChanged: (value) {
                          if (value.length < 11) {
                            resIP.modifyName(value, widget.index);
                          } else {
                            middleNickController.text = resIP.getItem()[widget.index].name;
                          }
                        },
                      ),
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
                  child: TextMessageNormal(testMsg, 12.0),
                  onTap: () async{
                    await notRegisterFriends();
                  },
                ),
              )
            ],
          ),
        ),

        (enterBox) ? Positioned(
          left: 7,
          child: TextMessageNormal(resIP.getItem()[widget.index].kakaoNickname, 12.0),
        ) : const SizedBox()
      ],
    );

  }
}

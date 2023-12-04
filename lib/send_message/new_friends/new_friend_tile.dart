import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
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

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  DateTime now = DateTime.now();

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

    nickname = resIP.getItem()[widget.index].kakaoNickname?? '';
    middleNickController.text = resIP.getItem()[widget.index].name?? '';
    selectedIndex = resIP.getItem()[widget.index].talkDown?? 2;
    selectedHashTag = resIP.getItem()[widget.index].tag?? [];

    if (middleNickController.text.isNotEmpty && selectedIndex != 2 && selectedHashTag.isNotEmpty) {
      warnColor = Colors.transparent;
      resIP.modifyRegistered(1, widget.index);
    } else {
      warnColor = Colors.red;
      resIP.modifyRegistered(0, widget.index);
    }

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
                            nickname,
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
                    child: Form(
                      child: TextFormField(
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
                  child: Text(
                      testMsg,
                      style: const TextStyle(
                          color:  Color(0xff000000),
                          fontWeight: FontWeight.w100,
                          fontFamily: "NotoSansCJKkr-Regular",
                          fontStyle:  FontStyle.normal,
                          fontSize: 12.0
                      ),
                      textAlign: TextAlign.center
                  ),
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

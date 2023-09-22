import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/etc_widget/text_message.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../user_data/registered_friends_provider.dart';

class ModifyFriendTile extends StatefulWidget {
  const ModifyFriendTile({required this.registeredFriend, required this.registering, super.key});

  final RegisteredFriendsItem registeredFriend;
  final bool registering;

  @override
  State<ModifyFriendTile> createState() => ModifyFriendTileState();
}

class ModifyFriendTileState extends State<ModifyFriendTile> {

  late RegisteredFriendsItemProvider fIP;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  DateTime now = DateTime.now();

  int selectedIndex = 2;
  int selectedFilterIndex = 10;
  List<String> options = ['존대', '반말'];

  double xMousePosition = 0.0;
  double yMousePosition = 0.0;
  bool enterBox = false;

  bool warnNick = false;
  bool warnSelectChip = false;
  bool warnTag = false;
  bool registering = false;
  bool registered = false;

  Color warnColor = Colors.transparent;

  String testMsg = '';
  int selectedOption = 5;
  List<dynamic> hashTag =  TagList.tagList;
  List<dynamic> selectedHashTag = [];

  @override
  void initState() {
    super.initState();
    middleNickController.text = widget.registeredFriend.name;
    selectedIndex = widget.registeredFriend.talkDown;
    selectedHashTag = widget.registeredFriend.tag;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            debugPrint(widget.registeredFriend.tag.toString());
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
    final docRef = FirebaseFirestore.instance.collection('friends').doc(widget.registeredFriend.documentId);
    await docRef.update({
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
      'registered': false,
    });
  }

  Future<void> registerFriends() async{

    final docRef = FirebaseFirestore.instance.collection('friends').doc(widget.registeredFriend.documentId);
    await docRef.update({
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
      'name': middleNickController.text,
      'tag': selectedHashTag,
      'talk_down': selectedIndex,
      'tier': 'normal'
    });

    debugPrint('update ${middleNickController.text}');
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);

    if (middleNickController.text.isNotEmpty && selectedIndex != 2 && selectedHashTag.isNotEmpty) {
      warnColor = Colors.transparent;
    } else {
      warnColor = Colors.red;
    }

    if (widget.registering) { //완료 버튼 누를시

      if (widget.registeredFriend.name != middleNickController.text
          || widget.registeredFriend.talkDown != selectedIndex
          || widget.registeredFriend.tag != selectedHashTag) { //변화가 있다면
        if (middleNickController.text.isEmpty || selectedIndex ==2 || selectedHashTag.isEmpty) { //비어 있는 것이 있으면
          debugPrint('passing');
        } else {  //모든 필드 채워 졌을 시
          if (!registered) {
            registered = true;
            registerFriends();
          }
        }
      } else {  //변화가 없으면
        debugPrint('passing ${middleNickController.text}');
      }

    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.transparent,
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
                            widget.registeredFriend.kakaoNickname,
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
                    // await notRegisterFriends();
                    // widget.updateStateNewFriend();
                  },
                ),
              )
            ],
          ),
        ),

        (enterBox) ? Positioned(
          left: 7,
          child: TextMessageNormal(widget.registeredFriend.kakaoNickname, 12.0),
        ) : const SizedBox()
      ],
    );

  }
}

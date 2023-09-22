import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/send_message/registered_friends/modify_registered_friend_tile.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friend_tile.dart';
import 'package:provider/provider.dart';

import '../../etc_widget/text_message.dart';
import '../../gate/gate_main.dart';
import '../../user_data/registered_friends_provider.dart';

GlobalKey<RegisteredFriendsState> registeredFriendsStateKey = GlobalKey();

class RegisteredFriends extends StatefulWidget {
  const RegisteredFriends({required this.updateStateSelect, Key? key}) : super(key: key);

  final Function() updateStateSelect;

  @override
  State<RegisteredFriends> createState() => RegisteredFriendsState();
}

class RegisteredFriendsState extends State<RegisteredFriends> {

  // late Friends friends;
  late RegisteredFriendsItemProvider fIP;

  // bool registeredFriendBool = false;
  int registeredCount = 0;
  bool modifyRegisteredFriend = false;
  bool registering = false;
  List<String> buttonTitleList = ['수정', '완료'];
  int buttonIndex = 0;

  final ScrollController controller = ScrollController();
  final TextEditingController searchFriendController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);

    if (fIP.getItem().length != 0) {
      int itemCount = 0;
      int boolCount = 0;
      for (RegisteredFriendsItem registeredFriend in fIP.getItem()) {
        itemCount++;
        if (registeredFriend.registered) {
          boolCount++;
          if (itemCount == fIP.getItem().length) {
            registeredCount = boolCount;
          }
        }
      }
    }

    return Column(
      children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xff000000),
                  width: 1
              ),
              color: const Color(0xfff0f0f0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 18),
                child: TextMessageNormal('등록한 사람들 ($registeredCount명)', 12.0),
              ),
              Container(
                margin: const EdgeInsets.only(right: 19),
                child: Material(
                  color: const Color(0xfff0f0f0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: const Color(0xffffdf8e),
                    hoverColor: Colors.grey,
                    child: Ink(
                      width: 100,
                      height: 21,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xffffffff),
                      ),
                      child: Center(
                        child: Text(buttonTitleList[buttonIndex], style: buttonTextStyle,),
                      ),
                    ),
                    onTap: () {
                      switch (buttonIndex) {
                        case 0:
                          buttonIndex = 1;
                          setState(() {
                            modifyRegisteredFriend = true;
                            registering = false;
                          });
                          break;
                        case 1:
                          buttonIndex = 0;
                          setState(() {
                            registering = true;
                          });
                          break;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(  //큰 박스 테두리 넣어야 해서 만듬
          // height: 392,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(color: Color(0xff000000), width: 1.0),
              right: BorderSide(color: Color(0xff000000), width: 1.0),
              bottom: BorderSide(color: Color(0xff000000), width: 1.0),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 32,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: TextMessageNormal('카톡대화명', 12.0)),
                    Expanded(flex: 1, child: TextMessageNormal('호칭', 12.0)),
                    Expanded(flex: 1, child: TextMessageNormal('문구톤 ', 12.0)),
                    Expanded(flex: 2, child: TextMessageNormal('태그', 12.0)),
                  ],
                ),
              ),

              const Divider(height: 1,),

              SizedBox(
                  height: 357,
                  child: (registeredCount == 0) ? Container(
                    margin: const EdgeInsets.only(top: 111),
                    child: const TextMessageNormal(
                        '등록한 사람이 없습니다.\n\"카톡주소 가져오기\"\n버튼을 눌러서 카톡 주소를 가져오세요.',
                        14.0
                    ),
                  ) : ListView.builder(
                      itemCount: fIP.getItem().length + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        //등록된 친구 목록 provider 에서 등록된 목록만 보여줌
                        if (index == fIP.getItem().length) {
                          if (registering) {
                            Future.delayed(const Duration(milliseconds: 500), () {
                              setState(() {
                                modifyRegisteredFriend = false;
                                registering = false;
                              });
                            });
                          }
                        } else {
                          if (modifyRegisteredFriend) {
                            return ModifyFriendTile(registeredFriend: fIP.getItem()[index], registering: registering);
                          } else {
                            if (fIP.getItem()[index].registered) {
                              return RegisteredFriendTile(fIP.getItem()[index]);
                            } else {
                              return const SizedBox();
                            }
                          }
                        }

                      }
                    )
              )
            ],
          ),
        ),
      ],
    );
  }
}

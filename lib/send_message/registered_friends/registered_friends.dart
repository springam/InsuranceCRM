import 'package:flutter/material.dart';
import 'package:mosaicbluenco/send_message/registered_friends/modify_registered_friend_tile.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friend_tile.dart';
import 'package:provider/provider.dart';
import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';

GlobalKey<RegisteredFriendsState> registeredFriendsStateKey = GlobalKey();

class RegisteredFriends extends StatefulWidget {
  const RegisteredFriends({Key? key}) : super(key: key);

  @override
  State<RegisteredFriends> createState() => RegisteredFriendsState();
}

class RegisteredFriendsState extends State<RegisteredFriends> {

  // late Friends friends;
  late RegisteredFriendsItemProvider regIP;

  // bool registeredFriendBool = false;
  int registeredCount = 0;
  bool modifyRegisteredFriend = false;
  bool registering = false;
  List<String> buttonTitleList = ['수정', '완료'];
  int buttonIndex = 0;

  final ScrollController controller = ScrollController();
  final TextEditingController searchFriendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    RegisteredFriendsItemProvider().addListener(() { });
  }

  @override
  void dispose() {
    RegisteredFriendsItemProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    regIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);

    registeredCount = regIP.getItem().length;

    // if (regIP.getItem().length != 0) {
    //   int itemCount = 0;
    //   int boolCount = 0;
    //   for (RegisteredFriendsItem registeredFriend in regIP.getItem()) {
    //     itemCount++;
    //     if (registeredFriend.registered == 1) {
    //       boolCount++;
    //       if (itemCount == regIP.getItem().length) {
    //         registeredCount = boolCount;
    //       }
    //     }
    //   }
    // }

    return Column(
      children: [
        Container(
          height: 32,
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xff000000),
                  width: 1
              ),
              color: const Color(0xfffbf8f1)
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
                    Expanded(flex: 1, child: SizedBox()),
                  ],
                ),
              ),

              const Divider(height: 1,),

              SizedBox(
                  height: 360,
                  child: (registeredCount == 0) ? Container(
                    margin: const EdgeInsets.only(top: 111),
                    child: const TextMessageNormal(
                        '등록한 사람이 없습니다.\n\"카톡주소 가져오기\"\n버튼을 눌러서 카톡 주소를 가져오세요.',
                        14.0
                    ),
                  ) : Scrollbar(
                      controller: controller,
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 12.0,
                      child: ListView.builder(
                          itemCount: registeredCount + 1,
                          controller: controller,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == regIP.getItem().length) {
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
                                return ModifyFriendTile(registeredFriend: regIP.getItem()[index], index: index, registering: registering);
                              } else {
                                return RegisteredFriendTile(regIP.getItem()[index]);
                              }
                            }

                          }
                      )
                  )
              )
            ],
          ),
        ),
      ],
    );
  }
}

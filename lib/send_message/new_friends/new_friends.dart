import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friends.dart';
import 'package:provider/provider.dart';
import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';
import 'new_friend_tile.dart';

class NewFriends extends StatefulWidget {
  const NewFriends({required this.friends, required this.updateStateSelect, super.key});

  final Friends friends;
  final Function() updateStateSelect;

  @override
  State<NewFriends> createState() => _NewFriendsState();
}

class _NewFriendsState extends State<NewFriends> {

  late Friends friends;
  late RegisteredFriendsItemProvider fIP;

  bool registerFriend = false;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  int selectedIndex = 0;
  List<String> options = ['존대', '반말'];

  void updateStateNewFriend() {
    // setState(() {});
    widget.updateStateSelect();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);

    friends = widget.friends;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 32,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color(0xff000000),
                  width: 1
              ),
              color: const Color(0xffc9ced9)
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 18),
            child: const TextMessageNormal('신규 등록 명단', 12.0),
          ),
        ),

        Container(  //큰 박스 테두리 넣어야 해서 만듬
          // height: 200,
          margin: const EdgeInsets.only(bottom: 10),
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
                    Expanded(flex: 1, child: TextMessageNormal('등록여부', 12.0)),
                  ],
                ),
              ),

              const Divider(height: 1,),

              SizedBox(
                  height: (friends.totalCount < 10) ? friends.totalCount * 45 : 500,
                  child: (friends.totalCount == 0) ? const Center(child: TextMessageNormal('불러온 친구 목록이 없습니다.', 12.0)) :
                  ListView.builder(
                      itemCount: friends.totalCount + 1,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {

                        if (index == friends.totalCount) {
                          if (registerFriend) {
                            registerFriend = false;
                            // widget.updateStateSelect();
                          }
                        } else {
                          //신규 목록 중에 등록된 친구가 있는지 체크
                          bool existItem = false;
                          int itemCount = 0;
                          for (RegisteredFriendsItem registeredFriend in Provider.of<RegisteredFriendsItemProvider>(context, listen: true).getItem()) {
                            itemCount++;
                            if (registeredFriend.kakaoId == friends.elements?[index].id) {
                              existItem = true;
                            }
                            if (itemCount == fIP.getItem().length) {
                              if (existItem) {
                                return const SizedBox();
                              } else {
                                return NewFriendTile(friends: friends, index: index, updateStateNewFriend: updateStateNewFriend, registering: registerFriend,);
                              }
                            }
                          }
                        }

                      }
                  )
              ),

              Container(
                height: 34,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 19),
                color: const Color(0xfff0f0f0),
                child: Material(
                  color: const Color(0xfff0f0f0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: const Color(0xffffdf8e),
                    hoverColor: Colors.grey,
                    child: Ink(
                      width: 88,
                      height: 21,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xffffffff),
                      ),
                      child: Center(
                        child: Text('등록하기', style: buttonTextStyle,),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        registerFriend = true;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../../etc_widget/text_message.dart';
import '../../user_data/registered_friends_provider.dart';
import '../../user_data/response_friend_provider.dart';
import 'new_friend_tile.dart';

class NewFriends extends StatefulWidget {
  const NewFriends({required this.updateStateSelect, super.key});

  // final List<RegisteredFriendsItem> responseFriend;
  final Function() updateStateSelect;

  @override
  State<NewFriends> createState() => _NewFriendsState();
}

class _NewFriendsState extends State<NewFriends> {

  late RegisteredFriendsItemProvider fIP;
  late ResponseFriendsItemProvider resIP;

  bool registerFriend = false;
  bool refresh = false;

  final ScrollController controller = ScrollController();
  final TextEditingController middleNickController = TextEditingController();

  int selectedIndex = 0;
  List<String> options = ['존대', '반말'];
  // List<RegisteredFriendsItem> friendList = [];

  void updateStateNewFriend() {
    // setState(() {});
    widget.updateStateSelect();
  }

  @override
  void initState() {
    super.initState();
    // SendMessageFriendsItemProvider().addListener(() { });
    // RegisteredFriendsItemProvider().addListener(() { });
  }

  @override
  void dispose() {
    // SendMessageFriendsItemProvider().removeListener(() { });
    // RegisteredFriendsItemProvider().removeListener(() { });
    super.dispose();
  }

  Future<void> registerFriends() async {

    List<RegisteredFriendsItem> tempItem = [];
    // int count = ResponseFriendItem.responseFriend.length;

    await Future.forEach(resIP.getItem(), (RegisteredFriendsItem item) async {
      if (item.registered) {
        final docRef = FirebaseFirestore.instance.collection('friends').doc();
        await docRef.set({
          'document_id': docRef.id,
          'etc': '',
          'kakao_nickname': item.kakaoNickname,
          'managed_count': 0,
          'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(DateTime.now()),
          'managed_last_date': '',
          'manager_email': UserData.userEmail,
          'name': item.name,
          'registered': true,
          'tag': item.tag,
          'talk_down': item.talkDown,
          'tier': 'normal'
        });
      } else {
        tempItem.add(item);
      }
    });

    // setState(() {
    //   registerFriend = false;
    //   resIP.setItem(tempItem);
    // });
    resIP.setItem(tempItem);
    // widget.updateStateSelect();
  }

  @override
  Widget build(BuildContext context) {

    fIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);
    resIP = Provider.of<ResponseFriendsItemProvider>(context, listen: true);
    int itemCount = resIP.getItem().length;

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

              const Divider(height: 1),

              (registerFriend) ? const SizedBox() : SizedBox(
                  height: (itemCount < 8) ? itemCount * 45 : 360,
                  child: (itemCount == 0) ? const Center(child: TextMessageNormal('불러온 친구 목록이 없습니다.', 12.0)) :
                  ListView.builder(
                      itemCount: itemCount,
                      controller: controller,
                      itemBuilder: (BuildContext context, int index) {
                        return NewFriendTile(index: index, updateStateNewFriend: updateStateNewFriend, registering: registerFriend);
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
                    onTap: () async {
                      // setState(() {
                      //   registerFriend = true;
                      // });
                      await registerFriends();
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

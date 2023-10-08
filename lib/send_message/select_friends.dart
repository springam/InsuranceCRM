import 'package:flutter/material.dart';
import 'package:mosaicbluenco/send_message/new_friends/new_friends.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friends.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/send_message_friend_tile.dart';
import 'package:mosaicbluenco/send_message/registered_friends/tag_list_chip.dart';
import 'package:mosaicbluenco/user_data/status_provider.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../etc_widget/design_widget.dart';
import '../user_data/response_friend_provider.dart';
import 'registered_friends/tag_list_chip_add.dart';
import '../etc_widget/text_message.dart';
import '../user_data/registered_friends_provider.dart';

class SelectFriends extends StatefulWidget {
  const SelectFriends({super.key});

  @override
  State<SelectFriends> createState() => SelectFriendsState();
}

class SelectFriendsState extends State<SelectFriends> {

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  late RegisteredFriendsItemProvider fIP;
  late ResponseFriendsItemProvider resIP;

  final ScrollController controller = ScrollController();
  final ScrollController sendMessageFriendController = ScrollController();
  final TextEditingController searchFriendController = TextEditingController();

  // late Friends friends;
  int channelValue = 3;
  List<String> response = [];
  bool getFriends = false;
  bool gettingFriends = false; //카톡 친구 불러 오는 중
  bool testBool = false;
  double middleFrameWidth = 728;
  double endFrameWidth = 256;

  @override
  void initState() {
    super.initState();
    streamListen();
    SendMessageFriendsItemProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
    RegisteredFriendsItemProvider().addListener(() { });
    channel.sink.add('version');
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    RegisteredFriendsItemProvider().removeListener(() { });
    channel.sink.close();
    super.dispose();
  }

  void updateStateSelect() { //상태 update callback 함수
    setState(() {
      // channelValue = 3;
      registeredFriendsStateKey.currentState?.setState(() {});
    });
  }

  List<Widget> tagList() {  //등록된 친구
    return List<Widget>.generate(
        TagList.tagList.length, (tagIndex) => TagListChip(tagIndex: tagIndex,)).toList();
  }

  Widget channelWidget(int value) {
    switch (value) {
      case 0:
        return const SizedBox();
      case 1:
        return Container(
          color: Colors.red,
          margin: const EdgeInsets.all(10),
          child: const Text('새로운 버전이 출시 되었습니다.\n업그레이드 후 재 실행해 주시기 바랍니다.'),
        );
      case 2:
        return Container(
          color: Colors.red,
          margin: const EdgeInsets.all(10),
          child: const Text('카카오톡을 실행해 주세요'),
        );
      case 3:
        if (resIP.getItem().isEmpty) {
          return const SizedBox();
        } else {
          return NewFriends(updateStateSelect: updateStateSelect);
        }
      default:
        return const SizedBox();
    }
  }

  void streamListen() {

    channel.stream.listen((data) {
      if (data.contains('version')) {
        var version = int.parse(data.substring(8));
        if (version < 1) {
          setState(() {
            channelValue = 1; //localserver 버전 체크
          });
        } else {
          setState(() {
            channelValue = 0;
          });
        }
      } else if (data == 'kakaotalk not found') {
        setState(() {
          gettingFriends = false;
          channelValue = 2; //카카오톡 실행
        });
      } else {
        if (data == '') {
          setState(() {
            gettingFriends = false;
            channelValue = 2; //카카오톡 실행
          });
        } else {
          response = data.split(',');
          int count = fIP.getItem().length;
          List<RegisteredFriendsItem> responseFriend = [];
          for (int i = 0; i < count + 1; i++) {
            if (i < count) {
              if (response.contains(fIP.getItem()[i].kakaoNickname)) { //등록 거부이든 수락이든 어차피 지워야함
                response.remove(fIP.getItem()[i].kakaoNickname);
              }
            } else {
              responseFriend = [];

              for (String name in response) {
                responseFriend.add(RegisteredFriendsItem(
                    managerEmail: UserData.userEmail,
                    name: '',
                    kakaoNickname: name,
                    talkDown: 2,
                    tag: [],
                    registered: false,
                    registeredDate: '',
                    managedLastDate: '',
                    managedCount: 0,
                    tier: '',
                    documentId: '',
                    etc: ''
                ));

                if (name == response.last) {
                  resIP.setItem(responseFriend);
                  setState(() {
                    gettingFriends = false;
                    channelValue = 3; //친구 목록 json 반환시
                  });
                }
              }
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    fIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);
    resIP = Provider.of<ResponseFriendsItemProvider>(context, listen: true);

    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 1.3,
          margin: const EdgeInsets.only(top: 19),
          child: Row(
            children: [
              Expanded(
                flex: 14,
                child: Container(
                  margin: const EdgeInsets.only(left: 36),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TextMessageNormal("카톡 보낼사람 선택하기", 22.0),
                          Container(
                            margin: const EdgeInsets.only(left: 13.5, right: 13.5),
                            child: const Icon(Icons.play_arrow, color: Color(0xffdde1e1),),
                          ),
                          const TextMessage(
                              "메시지 작성하기",
                              Color(0xffd9d9d9),
                              FontWeight.w400,
                              22.0
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextMessageNormal("1. 태그를 선택하거나 등록한 사람 중 카톡 대화명을 선택하세요", 16.0),

                          Material(  //친구 목록 가져오기
                            color: Colors.white,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor: const Color(0xffffdf8e),
                              hoverColor: Colors.grey,
                              child: Ink(
                                width: 115,
                                height: 26,
                                // alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)
                                    ),
                                    border: Border.all(
                                        color: const Color(0xffffdf8e),
                                        width: 1
                                    ),
                                    color: const Color(0xffffdf8e)
                                ),
                                child: Center(
                                  child: Text(
                                    '카톡주소 가져오기',
                                    style: buttonTextStyle,
                                  ),
                                ),
                              ),
                              onTap: () async{
                                setState(() {
                                  channelValue = 0;
                                  gettingFriends = true;
                                });
                                channel.sink.add('getFriend');
                              },
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 10),

                      Container(
                        height: 58,
                        decoration: const BoxDecoration(
                            color: Color(0xfff0f0f0)
                        ),
                        child: Row(
                          children: [
                            Wrap(
                              spacing: 3,
                              children: tagList(),  //tag list widget
                            ),

                            const TagListChipAdd(),  //tag list add widget

                          ],
                        ),
                      ),

                      const SizedBox(height: 13),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 214,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15)
                                ),
                                border: Border.all(
                                    color: const Color(0xffd9d9d9),
                                    width: 1
                                )
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  margin: const EdgeInsets.only(left: 9, right: 4),
                                  child: Image.asset('assets/images/search_friends.png'),
                                ),
                                Container(
                                  width: 160,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: TextField(
                                    controller: searchFriendController,
                                    style: buttonTextStyle,
                                    decoration: const InputDecoration(
                                        hintText: '카톡대화명 검색',
                                        border: InputBorder.none
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 13),

                      channelWidget(channelValue),

                      RegisteredFriends(updateStateSelect: updateStateSelect, key: registeredFriendsStateKey),  //등록친구 widget

                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container( //화살표
                  width: 38,
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 300),
                  child: ClipPath(
                    clipper: MyTriangle(),
                    child: Container(
                      width: 22,
                      height: 43,
                      color: const Color(0xffd9d9d9),
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 5,
                child: Container(
                  // width: 256,
                  margin: const EdgeInsets.only(top: 45, right: 36),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const TextMessageNormal('2. 카톡 보낼 사람을 확인하세요.', 16.0),
                      ),

                      Container(  //명단 리셋 버튼
                        margin: const EdgeInsets.only(top: 10, bottom: 7),
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            splashColor: const Color(0xffffdf8e),
                            hoverColor: Colors.grey,
                            child: Ink(
                              width: 87,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: const Color(0xff525151), width: 1)
                              ),
                              child: Center(
                                child: Text(
                                  '명단 리셋',
                                  style: buttonTextStyle,
                                ),
                              ),
                            ),
                            onTap: () {
                              sIP.setItem([]);
                            },
                          ),
                        ),
                      ),

                      Container(
                        height: 30,
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
                              margin: const EdgeInsets.only(left: 45),
                              child: const TextMessageNormal('카톡대화명', 12.0),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 54),
                              child: const TextMessageNormal('호칭', 12.0),
                            ),
                          ],
                        ),
                      ),

                      Container(  //메시지 보낼 친구 리스트
                        height: 388,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Color(0xff000000), width: 1.0),
                            right: BorderSide(color: Color(0xff000000), width: 1.0),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: sIP.getItem().length,
                            controller: sendMessageFriendController,
                            itemBuilder: (BuildContext context, int index) {
                              if (sIP.getItem().length == 0) {
                                return const Text('select friend');
                              } else {
                                return SendMessageFriendTile(registeredFriend: sIP.getItem()[index]);
                              }
                            }
                        ),
                      ),

                      Container(
                        height: 34,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xfff0f0f0),
                          border: Border(
                            left: BorderSide(color: Color(0xff000000), width: 1.0),
                            right: BorderSide(color: Color(0xff000000), width: 1.0),
                            bottom: BorderSide(color: Color(0xff000000), width: 1.0),
                          ),
                        ),
                        child: TextMessageNormal('카톡 보내는 사람: ${sIP.getItem().length.toString()}명', 12.0),
                      ),

                      const SizedBox(height: 13),

                      Material(
                        color: const Color(0xffffffff),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: const Color(0xffffdf8e),
                          hoverColor: Colors.grey,
                          child: Ink(
                            height: 38,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xfff0f0f0),
                            ),
                            child: Center(
                              child: Text('메시지 작성', style: buttonTextStyle,),
                            ),
                          ),
                          onTap: () {
                            if (sIP.getItem().isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('친구를 선택해 주세요.'),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('확인')
                                        )
                                      ],
                                    );
                                  }
                              );
                            } else {
                              cIP.setCurrentSubPage(1);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

        (gettingFriends) ? Container(
            width: double.infinity,
            height: 668,
            color: Colors.grey.withOpacity(0.7),
            child: Column(
              children: [
                const Expanded(
                  flex: 8,
                  child: Center(
                    child: SelectableText(
                      '카톡에서 주소를 가져오고 있습니다.\n조금만 기다려 주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: () {
                        channel.sink.add('stop');
                      },
                      child: const Text('친구 불러오기 그만하기')
                  ),
                )
              ],
            )
        ) : const SizedBox(),
      ],
    );
  }
}


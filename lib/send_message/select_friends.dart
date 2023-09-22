import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/send_message/new_friends/new_friends.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friends.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/send_message_friend_tile.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/tag_list.dart';
import 'package:mosaicbluenco/user_data/status_provider.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../etc_widget/design_widget.dart';
import '../etc_widget/tag_dialog_message.dart';
import '../etc_widget/text_message.dart';
import '../user_data/registered_friends_provider.dart';

class SelectFriends extends StatefulWidget {
  const SelectFriends({super.key});

  @override
  State<SelectFriends> createState() => SelectFriendsState();
}

class SelectFriendsState extends State<SelectFriends> {

  final _channel = WebSocketChannel.connect(
    // Uri.parse('wss://echo.websocket.events'),
    Uri.parse('ws://localhost:8080'),
  );

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  late RegisteredFriendsItemProvider fIP;

  final ScrollController controller = ScrollController();
  final ScrollController sendMessageFriendController = ScrollController();
  final TextEditingController searchFriendController = TextEditingController();

  late Friends friends;
  bool getFriends = false;
  bool gettingFriends = false; //카톡 친구 불러 오는 중
  bool testBool = false;
  double middleFrameWidth = 728;
  double endFrameWidth = 256;

  @override
  void initState() {
    super.initState();
    SendMessageFriendsItemProvider().addListener(() { });
    _channel.sink.add('version');
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    _channel.sink.close();
    super.dispose();
  }

  void updateStateSelect() { //상태 update callback 함수
    setState(() {
      registeredFriendsStateKey.currentState?.setState(() {});
    });
  }

  // Future<dynamic> getFriendsList() async{  //친구 목록 가져오기
  //   try {
  //     friends = await TalkApi.instance.friends(limit: 10);
  //     // debugPrint('카카오톡 친구 목록 가져오기 성공'
  //     //     '\n${friends.elements?.map((friend) => friend.profileNickname).join('\n')}');
  //     setState(() {
  //       getFriends = true;
  //       gettingFriends = false;
  //     });
  //   } catch (error) {
  //     debugPrint('카카오톡 친구 목록 가져오기 실패 $error');
  //   }
  // }

  List<Widget> tagList() {
    return List<Widget>.generate(
        TagList.tagList.length, (tagIndex) => TagListChip(tagIndex: tagIndex,)).toList();
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    fIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);


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

                          Material(  //카톡 주소 가져오기
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
                                  friends = Friends([], 0, 0, '', '');
                                  getFriends = true;
                                  // fIP.setItem([]);
                                });
                                _channel.sink.add('getFriend');
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
                              children: tagList(),
                            ),
                            
                            Container(
                              width: 33,
                              height: 33,
                              margin: const EdgeInsets.only(left: 7),
                              alignment: Alignment.center,
                              child: Material(
                                color: const Color(0xfff0f0f0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(33),
                                  splashColor: const Color(0xffffdf8e),
                                  hoverColor: Colors.grey,
                                  child: Ink(
                                    width: 33,
                                    height: 33,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(33)),
                                      color: Color(0xffffffff),
                                    ),
                                    child: const CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Text('+', style: TextStyle(color: Colors.black, fontSize: 14.0)),
                                    ),
                                  ),
                                  onTap: () {
                                    if (TagList.tagList.length < 6) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const TagPopupDialog();
                                          }
                                      ).then((value) {
                                        setState(() {});
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('더이상 태그를 추가할 수 없습니다.'),
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
                                    }
                                  },
                                ),
                              ),
                            ),
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

                      StreamBuilder(
                        stream: _channel.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.contains('version')) {
                              var version = int.parse(snapshot.data.substring(8));
                              if (version < 1) {
                                return const Text('새로운 버전이 출시 되었습니다.\n업그레이드 후 재 실행해 주시기 바랍니다.');
                              } else {
                                return const SizedBox();
                              }
                            } else if (snapshot.data == 'kakaotalk not found') {
                              print(snapshot.data);
                              return const Text('카카오톡을 실행해 주세요');
                            } else {
                              setState(() {
                                getFriends = false;
                              });
                              List<String> result = snapshot.data.split(',');
                              return NewFriends(friendList: result, updateStateSelect: updateStateSelect);
                            }
                          } else {
                            return Text((snapshot.hasData) ? snapshot.data : '');
                          }
                        },
                      ),

                      RegisteredFriends(updateStateSelect: updateStateSelect, key: registeredFriendsStateKey),

                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
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

                      Container(
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

                      Container(
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
            child: const Column(
              children: [
                Expanded(
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
                  child: Text('주소 가져오기 멈추기'),
                )
              ],
            )
        ) : const SizedBox(),
      ],
    );
  }
}


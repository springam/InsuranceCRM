import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/send_message/new_friends/new_friends.dart';
import 'package:mosaicbluenco/send_message/registered_friends/registered_friends.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/send_message_friend_list.dart';
import 'package:mosaicbluenco/send_message/send_message_friends/send_message_friend_tile.dart';
import 'package:mosaicbluenco/send_message/registered_friends/tag_list_chip.dart';
import 'package:mosaicbluenco/user_data/status_provider.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../etc_widget/alert_dialog.dart';
import '../etc_widget/design_widget.dart';
import '../user_data/response_friend_provider.dart';
import 'registered_friends/tag_list_chip_add.dart';
import '../etc_widget/text_message.dart';
import '../user_data/registered_friends_provider.dart';
import 'package:mosaicbluenco/etc_widget/toast_message.dart';

class SelectFriends extends StatefulWidget {
  const SelectFriends({super.key});

  @override
  State<SelectFriends> createState() => SelectFriendsState();
}

class SelectFriendsState extends State<SelectFriends> {

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080'),
  );

  // final _formKey = GlobalKey<FormState>();

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  late FriendsItemProvider fIP;
  late RegisteredFriendsItemProvider regIP;
  late ResponseFriendsItemProvider resIP;
  // late NotSetItemProvider nsIP;

  final ScrollController controller = ScrollController();
  final ScrollController sendMessageFriendController = ScrollController();
  final TextEditingController searchFriendController = TextEditingController();

  late FToast fToast;

  bool channelValue = false;
  List<String> response = [];
  bool getFriends = false;
  bool gettingFriends = false; //카톡 친구 불러 오는 중
  bool testBool = false;
  double middleFrameWidth = 728;
  double endFrameWidth = 256;
  List<RegisteredFriendsItem> registerFriendsMap = [];
  List<RegisteredFriendsItem> responseFriendsMap = [];
  String searchText = '';

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    streamListen();
    SendMessageFriendsItemProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
    FriendsItemProvider().addListener(() { });
    RegisteredFriendsItemProvider().addListener(() { });
    ResponseFriendsItemProvider().addListener(() { });
    // NotSetItemProvider().addListener(() { });
    channel.sink.add('version');
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    FriendsItemProvider().removeListener(() { });
    RegisteredFriendsItemProvider().removeListener(() { });
    ResponseFriendsItemProvider().removeListener(() { });
    // NotSetItemProvider().removeListener(() { });
    channel.sink.close();
    super.dispose();
  }

  // void updateStateSelect() { //상태 update callback 함수
  //   setState(() {
  //     registeredFriendsStateKey.currentState?.setState(() {});
  //   });
  // }

  List<Widget> tagList() {  //등록된 친구
    return List<Widget>.generate(
        TagList.tagList.length, (tagIndex) => TagListChip(tagIndex: tagIndex,)).toList();
  }

  // Widget channelWidget() {
  //   if (resIP.getItem().isEmpty) {
  //     return const SizedBox();
  //   } else {
  //     return NewFriends(updateStateSelect: updateStateSelect);
  //   }
  // }

  Future<void> addFriends(String name) async{
    final docRef = FirebaseFirestore.instance.collection('friends').doc();
    await docRef.set({
      'document_id': docRef.id,
      'etc': '',
      'kakao_nickname': name,
      'managed_count': 0,
      'managed_last_date': '',
      'manager_email': UserData.userEmail,
      'name': '',
      'registered': 2,
      'registered_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(DateTime.now()),
      'tag': [],
      'talk_down': 2,
      'tier': 0
    });
  }

  void streamListen() {

    channel.stream.listen((data) {
      if (data.contains('version')) {
        var version = int.parse(data.substring(8));
        if (version < 4) { //version check
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertMessage(
                  title: 'Windows Support 버전 업데이트',
                  message: '자료실에서 최신 버전을 설치해 주시기 바랍니다.',
                );
              }
          );
        }
      } else if (data == 'kakaotalk not found') {
        if (gettingFriends) {
          gettingFriends = false;
          Navigator.of(context).pop();
        }
        showToast('카카오톡을 실행해 주세요.');
      } else {
        if (data == '') {
          if (gettingFriends) {
            gettingFriends = false;
            Navigator.of(context).pop();
          }
          showToast('카카오톡을 실행해 주세요.');
        } else {
          if (gettingFriends) {
            gettingFriends = false;
            Navigator.of(context).pop();
          } //추가함
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
                addFriends(name); //동기화 필요한지 확인 해야 함

                responseFriend.add(RegisteredFriendsItem(
                    managerEmail: UserData.userEmail,
                    name: '',
                    kakaoNickname: name,
                    talkDown: 2,
                    tag: [],
                    registered: 0,
                    registeredDate: '',
                    managedLastDate: '',
                    managedCount: 0,
                    tier: 0,
                    documentId: '',
                    etc: ''
                ));

                if (name == response.last) {
                  resIP.addItems(responseFriend);
                  setState(() {
                    gettingFriends = false;
                    channelValue = true; //친구 목록 json 반환시
                  });
                }
              }
            }
          }
        }
      }
    });
  }

  void setFriendList(String searchText) {

    regIP.initItem();
    resIP.initItem();

    for (RegisteredFriendsItem item in fIP.getItem()) {
      bool exitResponse = false;
      bool exitRegister = false;

      if (item.registered == 1) {
        for (int i = 0; i < regIP.getItem().length + 1; i++) {
          if (i < regIP.getItem().length) {
            if (regIP.getItem()[i].kakaoNickname == item.kakaoNickname) {
              exitRegister = true;
            }
          } else {
            if (!exitRegister) {
              registerFriendsMap.add(item);
            }
          }
        }
      } else if (item.registered == 2) {
        if (searchText.isEmpty) {
          for (int i = 0; i < resIP.getItem().length + 1; i++) {
            if (i < resIP.getItem().length) {
              if (resIP.getItem()[i].kakaoNickname == item.kakaoNickname) {
                exitResponse = true;
              }
            } else {
              if (!exitResponse) {
                responseFriendsMap.add(item);
              }
            }
          }
        } else {
          if (item.kakaoNickname.contains(searchText)) {
            for (int i = 0; i < resIP.getItem().length + 1; i++) {
              if (i < resIP.getItem().length) {
                if (resIP.getItem()[i].kakaoNickname == item.kakaoNickname) {
                  exitResponse = true;
                }
              } else {
                if (!exitResponse) {
                  responseFriendsMap.add(item);
                }
              }
            }
          }
        }
      }

      if (item == fIP.getItem().last) {

        if (registerFriendsMap.isNotEmpty) {
          regIP.addItems(registerFriendsMap);
        }
        if (responseFriendsMap.isNotEmpty) {
          resIP.addItems(responseFriendsMap);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    fIP = Provider.of<FriendsItemProvider>(context, listen: true);
    regIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);
    resIP = Provider.of<ResponseFriendsItemProvider>(context, listen: true);
    // nsIP = Provider.of<NotSetItemProvider>(context, listen: true);

    registerFriendsMap = [];
    responseFriendsMap = [];
    resIP.initItem();

    setFriendList(searchText);

    return Container(
      // height: MediaQuery.of(context).size.height * 1.3,
      margin: const EdgeInsets.only(top: 19),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Color(0xff000000),
                          FontWeight.w400,
                          22.0
                      ),
                    ],
                  ),

                  const SizedBox(height: 17),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextMessageNormal("1. 아래의 태그를 선택하거나 등록한 사람들에서 카톡 대화명을 선택하세요", 16.0),

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
                              channelValue = false;
                              gettingFriends = true; //stack으로 비활성화 구현시 true로 변경해 줘야 함
                            });
                            channel.sink.add('getFriend');

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      width: 484,
                                      height: 295,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffffffff),
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 45),
                                          const TextMessage(
                                              '카톡에서 주소를 가져오고 있습니다.',
                                              Color(0xff000000),
                                              FontWeight.w700,
                                              20.0
                                          ),
                                          const SizedBox(height: 26),
                                          const TextMessageNormal('시간이 걸릴 수 있습니다. 조금만 기다려 주세요\n'
                                              '아래의 \"그만하기\" 버튼을 누르면 불러오기가 중단되지만,\n'
                                              '다시 "가져오기"를 하면 중단된 이후부터 다시 불러오기를\n'
                                              '진행합니다.',
                                              14.0
                                          ),
                                          const SizedBox(height: 48),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xfff0f0f0),
                                                foregroundColor: const Color(0xff000000), //버튼 글씨 색
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0
                                                ),
                                                padding: const EdgeInsets.only(left: 90, top: 13, right: 90, bottom: 13)
                                            ),
                                            child: const Text('그만하기'),
                                            onPressed: () {
                                              gettingFriends = false; //추가함
                                              channel.sink.add('stop');
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    height: 58,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0xff000000),
                                width: 1.0
                            )
                        )
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
                              // child: Form(
                              //   key: _formKey,
                              //   child: TextFormField(
                              //     controller: searchFriendController,
                              //     onFieldSubmitted: (value) {
                              //       print('Enter here');
                              //       setState(() {
                              //         print(value);
                              //         resIP.initItem();
                              //         searchText = value;
                              //       });
                              //     },
                              //   ),
                              // )

                              child: TextField(
                                maxLines: null,
                                controller: searchFriendController,
                                style: buttonTextStyle,
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    hintText: '카톡대화명 검색',
                                    border: InputBorder.none
                                ),
                                onChanged: (value) {

                                  setState(() {
                                    // resIP.initItem();
                                    searchText = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 13),

                  (resIP.getItem().isEmpty) ? const SizedBox() : const NewFriends(),

                  // (channelValue) ? (resIP.getItem().isEmpty) ? const SizedBox() : NewFriends() : const SizedBox(),

                  RegisteredFriends(key: registeredFriendsStateKey),  //등록친구 widget

                  const SizedBox(height: 30),

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

          const Expanded(
            flex: 5,
            child: SendMessageFriendList(),
          ),

        ],
      ),
    );
  }
}


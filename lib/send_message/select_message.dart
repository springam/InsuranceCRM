import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosaicbluenco/send_message/message_templates/message_theme_list.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../etc_widget/alert_dialog.dart';
import '../etc_widget/design_widget.dart';
import '../etc_widget/text_message.dart';
import '../user_data/image_provider.dart';
import '../user_data/message_provider.dart';
import '../user_data/registered_friends_provider.dart';
import '../user_data/status_provider.dart';
import 'message_templates/message_view.dart';

class SelectMessage extends StatefulWidget {
  const SelectMessage({super.key});

  @override
  State<SelectMessage> createState() => _SelectMessageState();
}

class _SelectMessageState extends State<SelectMessage> {

  final _channel = WebSocketChannel.connect(
    // Uri.parse('wss://echo.websocket.events'),
    Uri.parse('ws://localhost:8080'),
  );

  late SendMessageFriendsItemProvider sIP;
  late TextMessageProvider tIP;
  late CurrentPageProvider cIP;
  late ImageCardProvider icIP;

  final ScrollController controller = ScrollController();

  double listHeight = 0.0;
  String selectedMessage = '';
  int talkDownFalseCount = 0;
  int talkDownTrueCount = 0;
  int selectedTalkDownIndex = 0;

  List<String> talkOption = ['존대', '반말'];

  bool messageClear = false;

  @override
  void initState() {
    super.initState();
    SendMessageFriendsItemProvider().addListener(() { });
    TextMessageProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
    ImageCardProvider().addListener(() { });
  }

  @override
  void dispose() {
    SendMessageFriendsItemProvider().removeListener(() { });
    TextMessageProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    ImageCardProvider().removeListener(() { });
    _channel.sink.close();
    super.dispose();
  }

  List<Widget> themeList() {
    return List<Widget>.generate(
        ThemeList.themeList.length, (themeIndex) => MessageThemeListChip(themeIndex: themeIndex,)).toList();
  }

  void sendMe() async {
    String result = json.encode({
      'request':'sendMe',
      'imageMessage': '${icIP.getImagePath()}',
      'textMessage':tIP.getTextMessageTalkDown(),
      'name':UserData.userNickname});
    _channel.sink.add(result);
  }

  void sendFriends() async {
    List<dynamic> messageItem = [];
    for (RegisteredFriendsItem value in sIP.getItem()) {
      if (value.talkDown == 0) {
        messageItem.add({
          'request':'sendFriends',
          'imageMessage':'${icIP.getImagePath()}',
          'textMessage':tIP.getTextMessage(),
          'name':value.kakaoNickname});
      } else {
        messageItem.add({
          'request':'sendFriends',
          'imageMessage':'${icIP.getImagePath()}',
          'textMessage':tIP.getTextMessageTalkDown(),
          'name':value.kakaoNickname});
      }
    }
    String result = json.encode(messageItem);
    _channel.sink.add(result);
  }

  List<Widget> selectChip() {
    return List<Widget>.generate(2, (optionIndex) => SizedBox(
      height: 28,
      child: FilterChip(
        // padding: const EdgeInsets.all(5),
        selectedColor: const Color(0xffd7e3f7),
        side: const BorderSide(color: Colors.black54, width: 0.5,),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        selected: selectedTalkDownIndex == optionIndex,
        showCheckmark: false,
        label: Text(talkOption[optionIndex], textAlign: TextAlign.center,),
        shape: ContinuousRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 3.0), //이거 왜 선이 안 보이냐
          borderRadius: BorderRadius.circular(0.0),
        ),
        labelStyle: buttonTextStyle,
        avatar: null,
        onSelected: (selected) {
          setState(() {
            if (selected) {
              cIP.setTalkDown(optionIndex);
            } else {
              cIP.setTalkDown(0);
            }
            // selectedTalkDownIndex = (selected) ? optionIndex : 0;
          });
        },
      ),
    )).toList();
  }

  Widget fileOptionWidget(String title) {
    return Container(
      width: 110,
      height: 25,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 15, top: 5, right: 0, bottom: 5),
      child: Material(
        color: const Color(0xfff0f0f0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: const Color(0xffffdf8e),
          hoverColor: const Color(0xffbcc0c7),
          child: Ink(
            // width: 88,
            // height: 21,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xffffffff)
            ),
            child: Center(
              child: Text(
                  title,
                  style: const TextStyle(
                      color:  Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansCJKKR",
                      fontStyle:  FontStyle.normal,
                      fontSize: 12.0
                  )
              ),
            ),
          ),
          onTap: () {

          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    sIP = Provider.of<SendMessageFriendsItemProvider>(context, listen: true);
    tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    icIP = Provider.of<ImageCardProvider>(context, listen: true);

    if (MediaQuery.of(context).size.width >1280) {
      listHeight = 80;
    } else {
      listHeight = 100; //140
    }

    if (cIP.getTalkDown() == 0) {
      selectedTalkDownIndex = 0;
      selectedMessage = tIP.textMessage;
    } else {
      selectedTalkDownIndex = 1;
      selectedMessage = tIP.textMessageTalkDown;
    }

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
                          const TextMessage(
                              "카톡 보낼사람 선택하기",
                              Color(0xffd9d9d9),
                              FontWeight.w400,
                              22.0
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 13.5, right: 13.5),
                            child: const Icon(Icons.play_arrow, color: Color(0xffdde1e1),),
                          ),
                          const TextMessageNormal("메시지 작성하기", 22.0),
                        ],
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 17),
                        child: const TitleNormal("3. 메시지를 작성하세요.", 16.0),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 17, bottom: 10),
                        child: const TitleNormal('1. 아래에 원하는 주제 버튼을 눌러서 보낼 문구나 이미지를 선택 하세요. 문구와 이미지를 둘다 보낼 수도 있습니다.', 14.0),
                      ),

                      Container(
                        width: double.infinity,
                        height: listHeight,
                        decoration: const BoxDecoration(
                            color: Color(0xfff0f0f0)
                        ),
                        padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                        child: Wrap(spacing: 10, children: themeList()),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const TitleNormal('2. 선택한 문구를 나에게 맞게 변경해서 보내세요. 물론 그냥 보내셔도 됩니다.', 14.0),
                      ),

                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                            color: const Color(0xfff0f0f0)
                        ),
                        padding: const EdgeInsets.only(left: 20, top: 7, right: 20, bottom: 15),
                       child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Material(
                                  color: const Color(0xfff0f0f0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: const Color(0xffffdf8e),
                                    hoverColor: const Color(0xffbcc0c7),
                                    child: Ink(
                                      width: 87,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.black, width: 1),
                                          color: const Color(0xffffffff)
                                      ),
                                      child: Center(child: Text('내용 지우기', style: buttonTextStyle),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        tIP.setTextMessage('');
                                        tIP.setTextMessageTalkDown('');
                                        icIP.setImagePath('');
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: MessageView(talkDown: false, reset: messageClear)
                                ),
                                const SizedBox(width: 30),
                                Flexible(
                                    flex: 1,
                                    child: MessageView(talkDown: true, reset: messageClear)
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: const TitleNormal('3. 보내고 싶은 이미지나 링크가 있으면 아래에서 선택하거나 입력하세요.', 14.0),
                      ),

                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xfff0f0f0)
                        ),
                        padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 33,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 5, bottom: 5),
                              child: const Text(
                                  '첨부',
                                  style: TextStyle(
                                      color:  Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "NotoSansCJKKR",
                                      fontStyle:  FontStyle.normal,
                                      fontSize: 12.0
                                  )
                              ),
                            ),

                            fileOptionWidget('이미지'),
                            fileOptionWidget('링크'),
                            fileOptionWidget('파일'),

                          ],
                        ),
                      ),

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
                        alignment: Alignment.center,
                        child: Wrap(
                          spacing: 0,
                          children: selectChip(),
                        ),
                      ),

                     const SizedBox(height: 10),

                      Container(
                        height: 570,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(45)),
                            border: Border.all(
                                color: const Color(0xffd0d6df),
                                width: 2
                            ),
                            color: const Color(0xffffffff)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: const Color(0xffd0d6df),
                                          width: 2
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    width: 60,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          color: const Color(0xffd0d6df),
                                          width: 2
                                      ),
                                    ),
                                  ),
                                ),

                                const Expanded(
                                  flex: 1,
                                  child: SizedBox(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Container(
                              height: 400,
                              width: double.infinity,
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xffd0d6df),
                                    width: 2
                                ),
                              ),
                              child: Scrollbar(
                                  controller: controller,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  thickness: 12.0,
                                child: SingleChildScrollView(
                                  controller: controller,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 25,
                                            width: 25,
                                            margin: const EdgeInsets.only(left: 0, bottom: 5),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    // image: AssetImage('assets/images/kakao_person.png')
                                                  image: NetworkImage(UserData.userImageUrl)
                                                )
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                                            alignment: Alignment.centerLeft,
                                            child: SelectableText(UserData.userNickname),
                                          ),
                                        ],
                                      ),

                                      (selectedMessage.isNotEmpty || icIP.getImagePath().length != 0) ? Container(
                                        // width: 19,
                                        alignment: Alignment.centerLeft,
                                        margin: const EdgeInsets.only(left: 22),
                                        child: ClipPath(
                                          clipper: MessageTriangle(),
                                          child: Container(
                                            width: 19,
                                            height: 15,
                                            // alignment: Alignment.centerLeft,
                                            color: const Color(0xffffdf8e),
                                          ),
                                        ),
                                      ) : const SizedBox(),

                                      Column(
                                        children: [
                                          (icIP.getImagePath().length == 0) ? const SizedBox() : Container(
                                            height: 250,
                                            // width: double.infinity,
                                            padding: const EdgeInsets.all(10),
                                            color: const Color(0xffffdf8e),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                // shape: BoxShape.circle,
                                                  color: const Color(0xffffdf8e),
                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fitWidth,
                                                      // image: AssetImage('assets/images/kakao_person.png')
                                                    image: NetworkImage(icIP.getImagePath())
                                                  )
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            alignment: Alignment.centerLeft,
                                            color: (selectedMessage.isEmpty) ? Colors.transparent : const Color(0xffffdf8e),
                                            child: Text(
                                              selectedMessage,
                                              style: buttonTextStyle,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            )
                          ],
                        ),
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
                              color: Color(0xffd7e3f7),
                            ),
                            child: Center(
                              child: Text('나에게 테스트', style: buttonTextStyle,),
                            ),
                          ),
                          onTap: () {
                            if (icIP.getImagePath() == 'empty' && tIP.getTextMessage().length == 0 && tIP.getTextMessageTalkDown().length == 0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertMessage(
                                      title: '선택된 메시지가 없습니다.',
                                      message: '메시지를 선택하거나 직접 입력해 주세요.',
                                    );
                                  }
                              );
                            } else {
                              sendMe();
                            }
                          },
                        ),
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
                              color: Color(0xffffdf8e),
                            ),
                            child: Center(
                              child: Text('카톡 발송 [${sIP.getItem().length}명]', style: buttonTextStyle,),
                            ),
                          ),
                          onTap: () {
                            if (icIP.getImagePath() == 'empty' && tIP.getTextMessage().length == 0 && tIP.getTextMessageTalkDown().length == 0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertMessage(
                                      title: '선택된 메시지가 없습니다.',
                                      message: '메시지를 선택하거나 직접 입력해 주세요.',
                                    );
                                  }
                              );
                            } else {
                              sendFriends();
                            }
                          },
                        ),
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
                              color: Color(0xffffdf8e),
                            ),
                            child: Center(
                              child: Text('뒤로가기(테스트용 버튼)', style: buttonTextStyle,),
                            ),
                          ),
                          onTap: () {
                            sIP.initItem();
                            cIP.setCurrentSubPage(0);
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
      ],
    );
  }
}

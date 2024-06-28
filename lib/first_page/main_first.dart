import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../etc_widget/text_message.dart';
import '../user_data/registered_friends_provider.dart';
import '../user_data/response_friend_provider.dart';
import '../user_data/status_provider.dart';


class MainFirst extends StatefulWidget {
  const MainFirst({super.key});

  @override
  State<MainFirst> createState() => _MainFirstState();
}

class _MainFirstState extends State<MainFirst> {

  late SendMessageFriendsItemProvider sIP;
  late CurrentPageProvider cIP;
  late FriendsItemProvider fIP;
  late RegisteredFriendsItemProvider regIP;
  late ResponseFriendsItemProvider resIP;

  List<RegisteredFriendsItem> registerFriendsMap = [];
  List<RegisteredFriendsItem> responseFriendsMap = [];
  List<RegisteredFriendsItem> rankingFriends = [];

  final ScrollController controller = ScrollController();

  bool seeMore = false;
  String seeMoreText = '더 보기';
  int rankCount = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setFriendList(String searchText) {

    rankingFriends = fIP.getItem();
    rankingFriends.sort((a, b) => a.managedCount.compareTo(b.managedCount));

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

    registerFriendsMap = [];
    responseFriendsMap = [];
    resIP.initItem();

    setFriendList('');

    if (seeMore) {
      rankCount = 10;
      seeMoreText = '접기';
    } else {
      rankCount = 5;
      seeMoreText = '더 보기';
    }

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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextMessageNormal("메인", 22.0),
                    ],
                  ),

                  const SizedBox(height: 17),

                  Container(
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16, bottom: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xffbcc0c7)
                    ),
                    child: Image.asset(
                      'assets/images/entryAD.png',
                      scale: 1.0,
                      fit: BoxFit.fill,
                    ),
                  ),

                  const SizedBox(height: 13),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          color: const Color(0xffbcc0c7),
                          margin: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                alignment: Alignment.centerLeft,
                                child: const TextMessageNormal('고객 관리 지수 (내 점수)', 12.0),
                              ),
                              Container(
                                height: 250,
                                alignment: Alignment.center,
                                child: const TextMessage(
                                    '756',
                                    Color(0xff000000),
                                    FontWeight.w700,
                                    30.0
                                ),
                              )
                            ],
                          ),
                        )
                      ),

                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          color: const Color(0xffbcc0c7),
                          margin: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10, left: 10),
                                alignment: Alignment.centerLeft,
                                child: const TextMessageNormal('관리 고객 수', 12.0),
                              ),
                              Container(
                                height: 250,
                                alignment: Alignment.center,
                                child: TextMessage(
                                    regIP.getItem().length.toString(),
                                    const Color(0xff000000),
                                    FontWeight.w700,
                                    30.0
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
          ),

          const Expanded(
            flex: 1,
            child: SizedBox(width: 38),
          ),

          Expanded(
            flex: 5,
            child: Container(
              height: 700,
              margin: const EdgeInsets.only(top: 50, right: 36),
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 12.0,
                child: ListView.builder(
                    itemCount: rankCount + 2,
                    controller: controller,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Container(
                          height: 38,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16, bottom: 5),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color(0xffbcc0c7)
                          ),
                          child: const Text('랭킹'),
                        );
                      } else if (index == rankCount + 1) {
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Material(
                            color: const Color(0xffffffff),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              splashColor: const Color(0xffffdf8e),
                              hoverColor: Colors.grey,
                              child: Ink(
                                height: 30,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xfff0f0f0),
                                ),
                                child: Center(
                                  child: Text('더 보기', style: buttonTextStyle,),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (seeMore) {
                                    seeMore = false;
                                  } else {
                                    seeMore = true;
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 38,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: const BoxDecoration(
                              color: Color(0xffbcc0c7)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text('${(index)} 등'),
                                  )
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Center(
                                    child: Text(rankingFriends[index].managedCount.toString()),
                                  )
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Text(rankingFriends[index].kakaoNickname)
                              ),
                            ],
                          ),
                        );
                      }
                    }
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

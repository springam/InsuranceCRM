import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../home_main/home_main.dart';
import '../user_data/registered_friends_provider.dart';


////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItemList extends StatelessWidget {
  const RegisteredFriendsItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    RegisteredFriendsItemProvider fIP;

    fIP = Provider.of<RegisteredFriendsItemProvider>(context);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('friends').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<RegisteredFriendsItem> registeredFriendsMap = [];
          snapshot.data.docs.map((doc){
            //디비의 등록 친구를 메니져 id 쿼리로 가져 오는게 맞으면 변경 해야 함
            //디비의 등록 친구 목록 전체를 비교하며 manager id == user id 이면 provider 에 담음
            if (doc.data()['manager_id'] == UserData.userId) {
              registeredFriendsMap.add(RegisteredFriendsItem(
                  kakaoId: doc.data()['kakao_id'],
                  kakaoUuid: doc.data()['kakao_uuid'],
                  managerId: doc.data()['manager_id'],
                  name: doc.data()['name'],
                  kakaoNickname: doc.data()['kakao_nickname'],
                  talkDown: doc.data()['talk_down'],
                  tag: doc.data()['tag'],
                  registered: doc.data()['registered'],
                  managedLastDate: doc.data()['managed_last_date'],
                  managedCount: doc.data()['managed_count'],
                  tier: doc.data()['tier'],
                  documentId: doc.data()['document_id'],
                  etc: doc.data()['etc']
              ));
            }
          }).toList();
          fIP.setItem(registeredFriendsMap);
          return const HomeMain();
        } else
        if (snapshot.hasError) {
          Text('${snapshot.error}');
        }
        return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Container(
                padding: const EdgeInsets.only(left: 75.0, right: 75.0),
                child: const LinearProgressIndicator(),
              ) ,
            )
        );
      },
    );
  }
}
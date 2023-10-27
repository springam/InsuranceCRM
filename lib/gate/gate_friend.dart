import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_data/registered_friends_provider.dart';
import 'gate_message.dart';


////////////////////////////////////////////////////////////////////////////////
class RegisteredFriendsItemList extends StatelessWidget {
  const RegisteredFriendsItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    FriendsItemProvider fIP;
    RegisteredFriendsItemProvider regIP;
    NotSetItemProvider nsIP;

    fIP = Provider.of<FriendsItemProvider>(context, listen: true);
    regIP = Provider.of<RegisteredFriendsItemProvider>(context, listen: true);
    nsIP = Provider.of<NotSetItemProvider>(context, listen: true);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('friends')
          .where('manager_email', isEqualTo: UserData.userEmail).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<RegisteredFriendsItem> registeredFriendsMap = [];
          List<RegisteredFriendsItem> totalFriendsMap = [];
          List<RegisteredFriendsItem> notSetFriendsMap = [];
          snapshot.data.docs.map((doc){
            //디비의 등록 친구를 메니져 id 쿼리로 가져 오는게 맞으면 변경 해야 함
            //디비의 등록 친구 목록 전체를 비교하며 manager id == user id 이면 provider 에 담음
            switch (doc.data()['registered']) {
              case 1:
                registeredFriendsMap.add(RegisteredFriendsItem(
                    managerEmail: doc.data()['manager_email'],
                    name: doc.data()['name'],
                    kakaoNickname: doc.data()['kakao_nickname'],
                    talkDown: doc.data()['talk_down'],
                    tag: doc.data()['tag'],
                    registered: doc.data()['registered'],
                    registeredDate: doc.data()['registered_date'],
                    managedLastDate: doc.data()['managed_last_date'],
                    managedCount: doc.data()['managed_count'],
                    tier: doc.data()['tier'],
                    documentId: doc.data()['document_id'],
                    etc: doc.data()['etc']
                ));
                break;
              case 2:
                notSetFriendsMap.add(RegisteredFriendsItem(
                    managerEmail: doc.data()['manager_email'],
                    name: doc.data()['name'],
                    kakaoNickname: doc.data()['kakao_nickname'],
                    talkDown: doc.data()['talk_down'],
                    tag: doc.data()['tag'],
                    registered: doc.data()['registered'],
                    registeredDate: doc.data()['registered_date'],
                    managedLastDate: doc.data()['managed_last_date'],
                    managedCount: doc.data()['managed_count'],
                    tier: doc.data()['tier'],
                    documentId: doc.data()['document_id'],
                    etc: doc.data()['etc']
                ));
                break;
            }
            totalFriendsMap.add(RegisteredFriendsItem(
                managerEmail: doc.data()['manager_email'],
                name: doc.data()['name'],
                kakaoNickname: doc.data()['kakao_nickname'],
                talkDown: doc.data()['talk_down'],
                tag: doc.data()['tag'],
                registered: doc.data()['registered'],
                registeredDate: doc.data()['registered_date'],
                managedLastDate: doc.data()['managed_last_date'],
                managedCount: doc.data()['managed_count'],
                tier: doc.data()['tier'],
                documentId: doc.data()['document_id'],
                etc: doc.data()['etc']
            ));

          }).toList();
          fIP.setItem(totalFriendsMap);
          regIP.setItem(registeredFriendsMap);
          nsIP.setItem(notSetFriendsMap);
          // resIP.setItem(notSetFriendsMap);
          return const PreSetItemList();
        } else
        if (snapshot.hasError) {
          Text('${snapshot.error}');
        }
        return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.only(left: 75.0, right: 75.0),
                child: const LinearProgressIndicator(),
              ),
            )
        );
      },
    );
  }
}
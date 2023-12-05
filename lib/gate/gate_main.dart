import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gate_friend.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    UserItemProvider uIP;

    uIP = Provider.of<UserItemProvider>(context);

    DateTime now = DateTime.now();

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('customer').where('kakao_id', isEqualTo: UserData.userId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<UserItem> userItemsMap = [];
          snapshot.data.docs.map((doc) =>
              userItemsMap.add(UserItem(
                  kakaoId: doc.data()['kakao_id'],
                  email: doc.data()['email'],
                  phoneNumber: doc.data()['phone_number'],
                  name: doc.data()['name'],
                  dateJoin: doc.data()['date_join'],
                  dateStart: doc.data()['date_start'],
                  dateEnd: doc.data()['date_end'],
                  tier: doc.data()['tier'],
                  documentId: doc.data()['document_id'],
                  etc: doc.data()['etc'],
                  userCompany: doc.data()['user_company'],
                  userTeam: doc.data()['user_team']
              ))
          ).toList();

          UserData.userTier = userItemsMap[0].tier;

          if (userItemsMap.isNotEmpty) {
            uIP.setItem(userItemsMap);
            return const RegisteredFriendsItemList();
          } else {
            final docRef = FirebaseFirestore.instance.collection('customer').doc();
            docRef.set({
              'kakao_id': UserData.userId,
              'email': UserData.userEmail,
              'phone_number': '',
              'name': '',
              'date_join': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
              'date_start': '',
              'date_end': '',
              'tier': 'normal',
              'document_id': docRef.id,
              'etc': '',
              'user_company': '',
              'user_team': ''
            });
          }

        } else if (snapshot.hasError) {
          Text('${snapshot.error}');
        }
        return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  const SizedBox(height: 30.0,),
                  const Text('Mosaic', style: TextStyle(color: Colors.white, fontSize: 26.0),),
                  const SizedBox(height: 100.0,),
                  const Text('Loading......', style: TextStyle(color: Colors.white),),
                  const SizedBox(height: 10.0,),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.only(left: 75.0, right: 75.0),
                    child: const LinearProgressIndicator(),
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_main/home_main.dart';
import '../user_data/message_provider.dart';
import 'gate_image.dart';

class PreSetItemList extends StatefulWidget {
  const PreSetItemList({super.key});

  @override
  State<PreSetItemList> createState() => _PreSetItemListState();
}

class _PreSetItemListState extends State<PreSetItemList> {
  @override
  Widget build(BuildContext context) {

    MessageItemProvider mIP;
    mIP = Provider.of<MessageItemProvider>(context, listen: true);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('message').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PresetMessageItem> presetMessageMap = [];
          snapshot.data.docs.map((doc){
            presetMessageMap.add(PresetMessageItem(
                subjectIndex: doc.data()['subject_index'],
                messageBody: doc.data()['message_body'],
                messageBodyTalkDown: doc.data()['message_body_talk_down'],
                customMessage: doc.data()['custom_message'],
                madeBy: doc.data()['made_by'],
                creationDate: doc.data()['creation_date'],
                documentId: doc.data()['document_id'],
                consumedCount: doc.data()['consumed_count']
            ));
          }).toList();
          mIP.setItem(presetMessageMap);
          return const PreSetImageItemList();
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

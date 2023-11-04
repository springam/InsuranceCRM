import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_main/home_main.dart';
import '../user_data/image_provider.dart';
import '../user_data/message_provider.dart';

class PreSetImageItemList extends StatefulWidget {
  const PreSetImageItemList({super.key});

  @override
  State<PreSetImageItemList> createState() => _PreSetImageItemListState();
}

class _PreSetImageItemListState extends State<PreSetImageItemList> {
  @override
  Widget build(BuildContext context) {

    ImageCardItemProvider iIP;
    iIP = Provider.of<ImageCardItemProvider>(context, listen: true);

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('image').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ImageCardItem> presetImageMap = [];
          snapshot.data.docs.map((doc){
            presetImageMap.add(ImageCardItem(
                subjectIndex: doc.data()['subject_index'],
                imagePath: doc.data()['image_path'],
                message: doc.data()['message'],
                customMessage: doc.data()['custom_message'],
                madeBy: doc.data()['made_by'],
                creationDate: doc.data()['creation_date'],
                documentId: doc.data()['document_id'],
                consumedCount: doc.data()['consumed_count']
            ));
          }).toList();
          iIP.setItem(presetImageMap);
          return const HomeMain();
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

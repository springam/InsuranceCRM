import 'dart:html';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import '../../user_data/image_provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/status_provider.dart';
import 'package:http/http.dart' as http;

class ImageGridViewBox extends StatefulWidget {
  const ImageGridViewBox({required this.imageCard, required this.modifyMessage, super.key});

  final ImageCardItem imageCard;
  final bool modifyMessage;

  @override
  State<ImageGridViewBox> createState() => _ImageGridViewBoxState();
}

class _ImageGridViewBoxState extends State<ImageGridViewBox> {

  // late TextMessageProvider tIP;
  late CurrentPageProvider cIP;
  late ImageCardProvider icIP;

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    TextMessageProvider().addListener(() { });
    CurrentPageProvider().addListener(() { });
  }

  @override
  void dispose() {
    TextMessageProvider().removeListener(() { });
    CurrentPageProvider().removeListener(() { });
    super.dispose();
  }

  Future<void> deleteMessage() async {
    Reference ref = FirebaseStorage.instance.ref().child('card');
    await ref.child('/${widget.imageCard.fileName}').delete();
    deleteData(widget.imageCard.documentId);
  }

  Future<void> deleteData(String documentId) async{
    final docRef = FirebaseFirestore.instance.collection('image');
    await docRef.doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {

    // tIP = Provider.of<TextMessageProvider>(context, listen: true);
    cIP = Provider.of<CurrentPageProvider>(context, listen: true);
    icIP = Provider.of<ImageCardProvider>(context, listen: true); //현재 보여질 이미지 프로바이더

    return InkWell(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Color(0xffffffff)
        ),
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          trackVisibility: true,
          thickness: 5.0,
          child: SingleChildScrollView(
            controller: controller,
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ImageNetwork(
                    image: widget.imageCard.imagePath,
                    height: 250,
                    width: constraints.maxWidth,
                    fitWeb: BoxFitWeb.fill,
                    borderRadius: BorderRadius.circular(10),
                    // onLoading: const CircularProgressIndicator(
                    //   color: Colors.indigoAccent,
                    // ),
                    duration: 100,
                    onPointer: true,
                    onLoading: const SizedBox(),
                    onTap: () {
                      icIP.setImagePath(widget.imageCard.imagePath, widget.imageCard.documentId);
                      cIP.setCurrentSubPage(1);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        if (widget.modifyMessage) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Image'),
                  content: const Text('Are you sure?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          deleteMessage();
                        },
                        child: const Text('ok')
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('cancel')
                    ),
                  ],
                );
              }
          );
        } else {
          icIP.setImagePath(widget.imageCard.imagePath, widget.imageCard.documentId);
          cIP.setCurrentSubPage(1);
        }
      },
    );
  }
}

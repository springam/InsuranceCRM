import 'dart:convert';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mosaicbluenco/message_template/theme_list.dart';
import '../etc_widget/text_message.dart';
import '../etc_widget/toast_message.dart';
import '../user_data/user_data.dart';
import 'dart:io' as io;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_network/image_network.dart';


class ImageCardGenerate extends StatefulWidget {
  const ImageCardGenerate({super.key});

  @override
  State<ImageCardGenerate> createState() => _ImageCardGenerateState();
}

class _ImageCardGenerateState extends State<ImageCardGenerate> {

  final TextEditingController messageController = TextEditingController();

  // late XFile pickedFile;
  // XFile? pickedImage;
  // late Image pickedImage = Image.asset('assets/images/mosaic_logo.png');
  Uint8List? bytesFromPicker;

  late FToast fToast;

  double listHeight = 0.0;

  @override
  void initState() {
    super.initState();
    SelectedTheme.selectedTheme = [];
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> themeList() {
    return List<Widget>.generate(
        ThemeList.themeList.length, (themeIndex) => ThemeListChip(themeIndex: themeIndex,)).toList();
  }

  Future getImage() async {
    var getImage = await ImagePickerWeb.getImageAsBytes();
    if (getImage != null) {
      setState(() {
        bytesFromPicker = getImage!;
      });
    }

    // pickedFile = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    // setState(() {
    //   pickedImage = XFile(pickedFile.path);
    // });
  }

  Future<void> uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('card').child('/$fileName.png'); //.child('/$fileName.bmp')
    await ref.putData(bytesFromPicker!); //(kIsWeb) ? putData() : putFile()
    String downloadUrl = await ref.getDownloadURL();
    print(ref.getDownloadURL());
    saveData(downloadUrl);
  }

  Future<void> saveData(String downloadUrl) async{
    final docRef = FirebaseFirestore.instance.collection('image').doc();
    await docRef.set({
      'subject_index': SelectedTheme.selectedTheme,
      'image_path': downloadUrl,
      'message': messageController.text,
      'custom_message': false,
      'made_by': UserData.userDocumentId,
      'creation_date': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(DateTime.now()),
      'document_id': docRef.id,
      'consumed_count': 0,
    });
  }

  @override
  Widget build(BuildContext context) {

    if (MediaQuery.of(context).size.width >1280) {
      listHeight = 100;
    } else {
      listHeight = 100; //140
    }

    return Column(
      children: [
        Text('입력자: ${UserData.userNickname}'),
        const Text('커스텀 메시지: false'),
        const Text ('사용된 횟수: 0'),
        Container(
          width: double.infinity,
          height: listHeight,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xfff0f0f0)
          ),
          child: Wrap(
            spacing: 3,
            children: themeList(),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(30),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    (bytesFromPicker != null) ? Container(
                      height: 310,
                      width: double.infinity,
                      color: const Color(0xffffffff),
                      padding: const EdgeInsets.all(5),
                      child: Image.memory(bytesFromPicker!),
                    ) : SizedBox(
                      height: 310,
                      width: double.infinity,
                      child: Image.asset('assets/images/mosaic_logo.png'),
                    ),
                    // (pickedImage != null) ? Container(
                    //   height: 310,
                    //   width: double.infinity,
                    //   color: const Color(0xffffffff),
                    //   padding: const EdgeInsets.all(5),
                    //   child: Image.network(pickedImage!.path),
                    // ) : const SizedBox(
                    //   height: 310,
                    //   width: double.infinity,
                    // ),
                    Container(
                      color: const Color(0xffffffff),
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        child: const Text('이미지를 선택해 주세요'),
                        onPressed: () async {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      height: 310,
                      width: double.infinity,
                      color: const Color(0xffffffff),
                      padding: const EdgeInsets.all(5),
                      child: TextField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: buttonTextStyle,
                        decoration: const InputDecoration(
                            hintText: '필요 없으면 빼야함',
                            labelText: '이미지 설명',
                            // enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(color: Color(0xffd9d9d9), width: 1.0,)
                            // ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ElevatedButton(
            onPressed: () async {
              showToast('이미지 카드를 저장 중 입니다. 잠시만 기다려 주세요');
              await uploadImage();
              setState(() {
                bytesFromPicker = null;
                messageController.text = '이미지를 저장 하였습니다.';
              });
            },
            child: const Text('확인 작업 없습니다. 한 번 더 보고 저장해 주세요.')
        )
      ],
    );
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../user_data/image_provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/status_provider.dart';
import 'package:http/http.dart' as http;

class ImageGridViewBox extends StatefulWidget {
  const ImageGridViewBox({required this.imageCard,  super.key});

  final ImageCardItem imageCard;

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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.transparent
              ),
              // child: Image.memory(imageBytes),
              child: Image.network(widget.imageCard.imagePath),
            ),
          ),
        ),
      ),
      onTap: () {
        icIP.setImagePath(widget.imageCard.imagePath, widget.imageCard.documentId);
        cIP.setCurrentSubPage(1);
      },
    );
  }
}

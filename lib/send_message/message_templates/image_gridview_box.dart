import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import '../../user_data/image_provider.dart';
import '../../user_data/message_provider.dart';
import '../../user_data/status_provider.dart';

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
        icIP.setImagePath(widget.imageCard.imagePath, widget.imageCard.documentId);
        cIP.setCurrentSubPage(1);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mosaicbluenco/user_data/status_provider.dart';
import 'package:provider/provider.dart';

import '../../user_data/message_provider.dart';
import '../../user_data/user_data.dart';

class MessageThemeSubject extends StatefulWidget {
  const MessageThemeSubject({required this.themeIndex, super.key});

  final int themeIndex;

  @override
  State<MessageThemeSubject> createState() => _MessageThemeSubjectState();
}

class _MessageThemeSubjectState extends State<MessageThemeSubject> {

  late CurrentPageProvider cIP;

  Color selectedTextColor = const Color(0xffffdf8e);
  Color normalTextColor = const Color(0xff000000);
  Color textColor = const Color(0xff000000);

  bool isHovering = false;
  double itemWidth = 50;

  @override
  void initState() {
    super.initState();
    CurrentPageProvider().addListener(() { });
  }

  @override
  void dispose() {
    CurrentPageProvider().removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    if (widget.themeIndex == cIP.getSelectedThemeIndex()) {
      textColor = selectedTextColor;
    } else {
      if (isHovering) {
        textColor = selectedTextColor;
      } else {
        textColor = normalTextColor;
      }
    }

    if (widget.themeIndex > 5 && widget.themeIndex < 9) {
      itemWidth = 60;
    } else if (widget.themeIndex >8) {
      itemWidth = 100;
    } else {
      itemWidth = 50;
    }

    return Container(
      width: itemWidth,
      alignment: Alignment.center,
      // margin: const EdgeInsets.only(top: 5, bottom: 5),
      color: const Color(0xffc9ced9),
      child: InkWell(
        child: Center(
          child: Text(
              ThemeList.themeList[widget.themeIndex],
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSansCJKKR",
                  fontStyle:  FontStyle.normal,
                  fontSize: 14.0
              )
          ),
        ),
        onHover: (value) {
          setState(() {
            textColor = value? selectedTextColor : normalTextColor;
            isHovering = value;
          });
        },
        onTap: () {
          cIP.setSelectedThemeIndex(widget.themeIndex);
        },
      ),
    );

  }
}

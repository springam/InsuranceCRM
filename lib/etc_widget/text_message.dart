
import 'package:flutter/material.dart';


class TextMessage extends StatelessWidget {
  const TextMessage(this.textContent, this.textColor, this.textFontWeight, this.textSize, {super.key});

  final String textContent;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text( //선택 가능하게 할지?
        textContent,
        style: TextStyle(
            color:  textColor,
            fontWeight: textFontWeight,
            fontFamily: "NotoSansCJKkr-Regular",
            fontFeatures: const [FontFeature.proportionalFigures()],
            fontStyle:  FontStyle.normal,
            fontSize: textSize,
        ),
        textAlign: TextAlign.center
    );
  }
}

class TextMessageNormal extends StatelessWidget {
  const TextMessageNormal(this.textContent, this.textSize, {super.key});

  final String textContent;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text( //글 선택 가능하게 할지?
        textContent,
        style: TextStyle(
            color:  const Color(0xff000000),
            fontWeight: FontWeight.w100,
            fontFamily: "NotoSansCJKkr-Regular",
            fontFeatures: const [FontFeature.proportionalFigures()],
            fontStyle:  FontStyle.normal,
            fontSize: textSize,
        ),
        textAlign: TextAlign.center
    );
  }
}

class TextMessage400 extends StatelessWidget {
  const TextMessage400(this.textContent, this.textSize, {super.key});

  final String textContent;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text( //SelectableText 글 선택 가능
        textContent,
        style: TextStyle(
          color:  const Color(0xff000000),
          fontWeight: FontWeight.w400,
          fontFamily: "NotoSansCJKkr-Regular",
          fontFeatures: const [FontFeature.proportionalFigures()],
          fontStyle:  FontStyle.normal,
          fontSize: textSize,
        ),
        textAlign: TextAlign.center
    );
  }
}

class TitleNormal extends StatelessWidget {
  const TitleNormal(this.textContent, this.textSize, {super.key});

  final String textContent;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text(
        textContent,
        style: TextStyle(
            color:  const Color(0xff000000),
            fontWeight: FontWeight.w100,
            fontFamily: "NotoSansCJKkr-Regular",
            fontFeatures: const [FontFeature.proportionalFigures()],
            fontStyle:  FontStyle.normal,
            fontSize: textSize,
        ),
        textAlign: TextAlign.left
    );
  }
}

class TitleHeavy extends StatelessWidget {
  const TitleHeavy(this.textContent, this.textSize, {super.key});

  final String textContent;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Text(
        textContent,
        style: TextStyle(
          color:  const Color(0xff000000),
          fontWeight: FontWeight.w600,
          fontFamily: "NotoSansCJKkr-Regular",
          fontFeatures: const [FontFeature.proportionalFigures()],
          fontStyle:  FontStyle.normal,
          fontSize: textSize,
        ),
        textAlign: TextAlign.left
    );
  }
}

TextStyle buttonTextStyle = const TextStyle(
    color:  Color(0xff000000),
    fontWeight: FontWeight.w100,
    fontFamily: "NotoSansCJKkr-Regular",
    fontFeatures: [FontFeature.proportionalFigures()],
    fontStyle:  FontStyle.normal,
    fontSize: 12.0,
);


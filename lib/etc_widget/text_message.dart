import 'dart:ui';

import 'package:flutter/material.dart';


class TextMessage extends StatelessWidget {
  const TextMessage(this.textContent, this.textColor, this.textFontWeight, this.textSize, {super.key});

  final String textContent;
  final Color textColor;
  final FontWeight textFontWeight;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
        textContent,
        style: TextStyle(
            color:  textColor,
            fontWeight: textFontWeight,
            // fontFamily: "NotoSansCJKKR",
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
    return SelectableText(
        textContent,
        style: TextStyle(
            color:  const Color(0xff000000),
            fontWeight: FontWeight.w400,
            // fontFamily: "NotoSansCJKKR",
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
    return SelectableText(
        textContent,
        style: TextStyle(
            color:  const Color(0xff000000),
            fontWeight: FontWeight.w400,
            // fontFamily: "NotoSansCJKKR",
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
    return SelectableText(
        textContent,
        style: TextStyle(
          color:  const Color(0xff000000),
          fontWeight: FontWeight.w600,
          // fontFamily: "NotoSansCJKKR",
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
    fontWeight: FontWeight.w400,
    // fontFamily: "NotoSansCJKKR",
    fontFeatures: [FontFeature.proportionalFigures()],
    fontStyle:  FontStyle.normal,
    fontSize: 12.0,
);


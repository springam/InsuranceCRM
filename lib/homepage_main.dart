import 'package:flutter/material.dart';


class HomepageMain extends StatefulWidget {
  const HomepageMain({super.key});

  @override
  State<HomepageMain> createState() => _HomepageMainState();
}

class _HomepageMainState extends State<HomepageMain> {



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/homepage_main_background.jpg')
        )
      ),
      alignment: Alignment.topCenter,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: 1200,
          height: 100,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/mosaic_logo.png')
                          )
                      ),
                    ),

                    InkWell(
                      child: const Text(
                        '사용법',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () {

                      },
                    ),

                    InkWell(
                      child: const Text(
                          '윈도우 프로그램 설치',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () {

                      },
                    ),

                    InkWell(
                      child: const Text(
                          '활용사례',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () {

                      },
                    ),

                    InkWell(
                      child: const Text(
                          '고객센터',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () {

                      },
                    ),

                    InkWell(
                      child: const Text(
                          '로그인',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center
                      ),
                      onTap: () async {
                        // await kakaoTalkLogin();
                      },
                    )
                  ],
                ),

                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Text(
                          '쉬운 고객관리 모자이크로 하나의 그림을 완성하세요',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center
                      ),

                      const Text(
                          '고객관리의 노하우를 제공합니다.',
                          style: TextStyle(
                            color:  Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: "NotoSansCJKkr-Regular",
                            fontFeatures: [FontFeature.proportionalFigures()],
                            fontStyle:  FontStyle.normal,
                            fontSize: 22.0,
                          ),
                          textAlign: TextAlign.center
                      ),

                      InkWell(
                        child: Image.asset('assets/images/kakao_login_large_narrow.png', scale: 2.0,),
                        onTap: () async{
                          // await kakaoTalkLogin();
                          // await getUserInfoWithKakao();
                        },
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}

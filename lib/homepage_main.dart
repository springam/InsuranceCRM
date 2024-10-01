import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'gate/gate_main.dart';
import 'user_data/kakao_login.dart';


class HomepageMain extends StatefulWidget {
  const HomepageMain({super.key});

  @override
  State<HomepageMain> createState() => _HomepageMainState();
}

class _HomepageMainState extends State<HomepageMain> {

  @override
  Widget build(BuildContext context) {

    if (UserToken.hasToken) {
      return const UserCheck();

      // if (UserData.userId == 0) {
      //   kakaoTalkLogin();
      //   return const HomepageIndex();
      // } else {
      //   return const UserCheck();
      // }
    } else {
      return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/homepage_main_background.jpg')
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 1200,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      child: Row(
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
                                  fontSize: 20.0,
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
                                  fontSize: 20.0,
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
                                  fontSize: 20.0,
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
                                  fontSize: 20.0,
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
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center
                            ),
                            onTap: () async {
                              // await kakaoTalkLogin();
                            },
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 30, right: 30),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const SizedBox(height: 80),
                          const Text(
                              '쉬운 고객관리! 모자이크로 하나의 그림을 완성하세요.',
                              style: TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansCJKkr-Regular",
                                fontFeatures: [FontFeature.proportionalFigures()],
                                fontStyle:  FontStyle.normal,
                                fontSize: 30.0,
                              ),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 80),
                          const Text(
                              '고객관리의 노하우를 제공합니다.',
                              style: TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansCJKkr-Regular",
                                fontFeatures: [FontFeature.proportionalFigures()],
                                fontStyle:  FontStyle.normal,
                                fontSize: 40.0,
                              ),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 80),
                          const Text(
                              '처음 접속한 화면에서 아래쪽이나 맨위 오른쪽에 로그인을 두면...',
                              style: TextStyle(
                                color:  Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "NotoSansCJKkr-Regular",
                                fontFeatures: [FontFeature.proportionalFigures()],
                                fontStyle:  FontStyle.normal,
                                fontSize: 30.0,
                              ),
                              textAlign: TextAlign.center
                          ),
                          const SizedBox(height: 80),
                          InkWell(
                            child: Image.asset('assets/images/kakao_login_large_narrow.png', scale: 2.0,),
                            onTap: () async{
                              if (UserToken.hasToken) {
                                if (UserData.userId == 0) {
                                  await kakaoTalkLogin();
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserCheck()));
                                }
                              } else {
                                await kakaoTalkLogin();
                                setState(() {});
                              }

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
        ),
      );
    }
  }

}

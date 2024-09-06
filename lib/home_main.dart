import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/user_data/kakao_login.dart';
import 'package:mosaicbluenco/message_template/image_card_generate.dart';
import 'package:mosaicbluenco/message_template/message_generate.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import 'etc_widget/text_message.dart';
import 'etc_widget/theme_set.dart';
import 'first_page/main_first.dart';
import 'friend_care/friend_care.dart';
import 'homepage_main.dart';
import 'login.dart';
import 'message_template/message_modify.dart';
import 'send_message/message_templates/message_preset.dart';
import 'send_message/select_friends.dart';
import 'send_message/select_message.dart';
import 'user_data/status_provider.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  // final UserData userData;

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {

  late CurrentPageProvider cIP;

  int hoveringNumber = 0;
  Color menuColor = ThemeSet.leftMenuColor; //left menu Color변수
  Color menuNormalColor = ThemeSet.leftMenuColor; //const Color(0xfffbf8f1);
  Color menuHoverColor = ThemeSet.leftMenuSelectedColor; //선택되거나 올려진 컬러
  // Color imageColor = const Color(0xffffffff);
  // Color imageColorNormal = const Color(0xffffffff); //const Color(0xff000000);
  // Color imageColorHover = ThemeSet.hoverColor;
  FontWeight fontWeight = FontWeight.w400;
  FontWeight fontWeightNormal = FontWeight.w400;
  FontWeight fontWeightHover = FontWeight.w700;
  List<String> leftMenuTextList = [
    '메인',
    '카톡 보내기',
    '고객 관리카드',
    '활용사례',
    '처음세팅',
    '메시지 입력',
    '이미지 카드 입력',
    '이미지 카드 수정'
  ];
  List<String> leftMenuImageList = [
    'menu_home',
    'menu_message',
    'menu_customer_card',
    'menu_example',
    'menu_setting',
    'menu_setting',
    'menu_setting',
    'menu_setting',
  ];
  String leftMenuImage = 'menu_home';
  String leftMenuText = '메인';

  double screenWidth = 1280;

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

  Widget leftMenu(int menuNumber) {

    if (hoveringNumber == menuNumber) {
      menuColor = menuHoverColor; //메뉴 text의 선택되거나 hover 색상
      // imageColor = imageColorHover; //메뉴 아이콘의 선택되거나 hover 색상
      fontWeight = fontWeightHover;
    } else {
      menuColor = menuNormalColor;
      // imageColor = imageColorNormal;
      fontWeight = fontWeightNormal;
    }

    leftMenuImage = leftMenuImageList[menuNumber - 1];
    leftMenuText = leftMenuTextList[menuNumber - 1];

    return InkWell(
      child: Container(
        height: 55,
        padding: const EdgeInsets.only(left: 50),
        decoration: BoxDecoration(color: ThemeSet.leftMenuBackGroundColor),
        child: Row(
          children: [
            // Container( //아이콘 삭제함
            //   height: 55,
            //   margin: const EdgeInsets.only(left: 15),
            //   child: Image.asset('assets/images/$leftMenuImage.png', scale: 1.0, color: imageColor,),
            // ),
            Container(
              height: 55,
              margin: const EdgeInsets.only(left: 5),
              alignment: Alignment.center,
              color: ThemeSet.leftMenuBackGroundColor,
              child: Text(
                  leftMenuText,
                  style: TextStyle(
                      color: menuColor,
                      fontWeight: fontWeight,
                      fontFamily: "NotoSansCJKkr-Regular",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),
                  textAlign: TextAlign.left
              ),
            )
          ],
        ),
      ),
      onHover: (value) { //value type is bool
        setState(() {
          hoveringNumber = value? menuNumber : 0;
        });
      },
      onTap: () {
        cIP.setCurrentMainPage(menuNumber - 1);
      },
    );
  }

  Widget currentPage() {

    switch (cIP.getMainPage()) {
      case 0:
        return const MainFirst();
      case 1:
        if (cIP.getSubPage() == 0) {
          return const SelectFriends();
        } else if (cIP.getSubPage() == 1) {
          return const SelectMessage();
        } else {
          // return const MessagePreset();
        }
      case 2:
        if (cIP.getSubPage() == 0) {
          return const FriendCare();
        } else if (cIP.getSubPage() == 1) {
          return const SelectMessage();
        } else {
          // return const MessagePreset();
        }
      case 3:
        return const Center(child: TitleHeavy('준비중입니다.', 20));
      case 4:
        return const Center(child: TitleHeavy('준비중입니다.', 20));
      case 5:
        return const MessageGenerate();
      case 6:
        return const ImageCardGenerate();
      case 7:
        return const MessageModify();
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    screenWidth = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).size.width < 1200 || MediaQuery.of(context).size.height < 650) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, size: 30, color: Colors.black),
              SizedBox(height: 30),
              TitleHeavy('모자이크 화면 크기 안내', 16.0),
              SizedBox(height: 30),
              TitleNormal('모자이크는 가로 1200, 세로 600 이상에 동작 하지만', 14.0),
              TitleNormal('가로 1500, 세로 720 이상에 최적화 되어 있습니다.', 14.0),
              TitleNormal('창 크기를 키우거나 전체 창 모드로 실행해 주시기 바랍니다.', 14.0),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  // width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 15,
                        child: Container( //left menu
                          width: 192,
                          height: MediaQuery.of(context).size.height * 1.5,
                          decoration: const BoxDecoration(
                              color: Color(0xff384d6a)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 109,
                                height: 89,
                                margin: const EdgeInsets.only(top: 16, bottom: 37),
                                decoration: const BoxDecoration(
                                    color: Color(0xff384d6a)
                                ),
                                child: Image.asset('assets/images/mosaic_logo.png', scale: 1.0),
                              ),

                              leftMenu(1),
                              leftMenu(2),
                              leftMenu(3),
                              leftMenu(4),
                              leftMenu(5),
                              (UserData.userTier == 'master') ? leftMenu(6) : const SizedBox(),
                              (UserData.userTier == 'master') ? leftMenu(7) : const SizedBox(),
                              (UserData.userTier == 'master') ? leftMenu(8) : const SizedBox(),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                          flex: 85,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor: const Color(0xffffdf8e),
                                        hoverColor: Colors.grey,
                                        onTap: () async{
                                          try {
                                            await UserApi.instance.logout();
                                            debugPrint('로그아웃 성공, SDK에서 토큰 삭제');
                                            setState(() {
                                              UserToken.hasToken = false;
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomepageMain())); //이전버전은 Login()임
                                            });
                                          } catch (error) {
                                            debugPrint('로그아웃 실패, SDK에서 토큰 삭제 $error');
                                          }
                                        },
                                        child: Ink(
                                          width: 81,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                                              border: Border.all(color: const Color(0xff525151), width: 1)
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '로그아웃',
                                              style: TextStyle(
                                                  color:  Color(0xff000000),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "NotoSansCJKkr-Regular",
                                                  fontStyle:  FontStyle.normal,
                                                  fontSize: 12.0
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 23),

                                    Container(
                                        width: 1,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                            color: Color(0xfff0f0f0)
                                        )
                                    ),

                                    SizedBox(
                                      width: 188,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 36,
                                            width: 36,
                                            margin: const EdgeInsets.only(left: 20, right: 12),
                                            child: ImageNetwork(
                                              image: UserData.userImageUrl,
                                              height: 30,
                                              width: 30,
                                              fitWeb: BoxFitWeb.fill,
                                              borderRadius: BorderRadius.circular(15),
                                              onLoading: const CircularProgressIndicator(
                                                color: Colors.indigoAccent,
                                              ),
                                              onError: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          SelectableText(UserData.userNickname)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Divider(
                                height: 1,
                                color: Color(0xfff0f0f0),
                              ),

                              currentPage(), //보여줄 페이지 선택

                            ],
                          )
                      )
                    ],
                  ),
                )
            ),

            (cIP.getSubPage() == 2) ? const MessagePreset() : const SizedBox()
          ],
        ),
      );
    }
  }
}


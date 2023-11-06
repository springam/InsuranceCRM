import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/kakao_login.dart';
import 'package:mosaicbluenco/message_template/image_card_generate.dart';
import 'package:mosaicbluenco/message_template/message_generate.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../etc_widget/text_message.dart';
import '../send_message/message_templates/message_preset.dart';
import '../send_message/select_friends.dart';
import '../send_message/select_message.dart';
import '../user_data/status_provider.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  // final UserData userData;

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {

  late CurrentPageProvider cIP;

  int hoveringNumber = 0;
  Color menuColor = const Color(0xffbcc0c7);
  Color normalColor = const Color(0xffbcc0c7);
  Color hoverColor = const Color(0xffc9ced9);
  Color imageColor = Colors.white;
  Color imageColorNormal = const Color(0xffffffff);
  Color imageColorHover = const Color(0xffe96558);
  FontWeight fontWeight = FontWeight.w400;
  FontWeight fontWeightNormal = FontWeight.w400;
  FontWeight fontWeightHover = FontWeight.w700;
  String leftMenuImage = 'menu_home';
  String leftMenuImage1= 'menu_home';
  String leftMenuImage2= 'menu_message';
  String leftMenuImage3= 'menu_customer_card';
  String leftMenuImage4= 'menu_example';
  String leftMenuImage5= 'menu_setting';
  String leftMenuText = '메인';
  String leftMenuText1 = '메인';
  String leftMenuText2 = '카톡 보내기';
  String leftMenuText3 = '고객 관리카드';
  String leftMenuText4 = '활용사례';
  String leftMenuText5 = '처음세팅';

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
      menuColor = hoverColor;
      imageColor = imageColorHover;
      fontWeight = fontWeightHover;
    } else {
      menuColor = normalColor;
      imageColor = imageColorNormal;
      fontWeight = fontWeightNormal;
    }

    switch (menuNumber) {
      case 1:
        leftMenuImage = leftMenuImage1;
        leftMenuText = leftMenuText1;
        break;
      case 2:
        leftMenuImage = leftMenuImage2;
        leftMenuText = leftMenuText2;
        break;
      case 3:
        leftMenuImage = leftMenuImage3;
        leftMenuText = leftMenuText3;
        break;
      case 4:
        leftMenuImage = leftMenuImage4;
        leftMenuText = leftMenuText4;
        break;
      case 5:
        leftMenuImage = leftMenuImage5;
        leftMenuText = leftMenuText5;
        break;
      default:
        leftMenuImage = leftMenuImage1;
        leftMenuText = leftMenuText1;
    }

    return InkWell(
      child: Container(
        height: 55,
        decoration: BoxDecoration(color: menuColor),
        child: Row(
          children: [
            Container(
              height: 55,
              margin: const EdgeInsets.only(left: 15),
              child: Image.asset('assets/images/$leftMenuImage.png', scale: 1.0, color: imageColor,),
            ),
            Container(
              height: 55,
              margin: const EdgeInsets.only(left: 5),
              alignment: Alignment.center,
              child: Text(
                  leftMenuText,
                  style: TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: fontWeight,
                      fontFamily: "NotoSansCJKKR",
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
        debugPrint('$menuNumber Tap');
        cIP.setCurrentMainPage(menuNumber - 1);
      },
    );
  }

  Widget currentPage() {

    switch (cIP.getMainPage()) {
      case 0:
        return const MessageGenerate();
      case 1:
        if (cIP.getSubPage() == 0) {
          return const SelectFriends();
        } else if (cIP.getSubPage() == 1) {
          return const SelectMessage();
        } else {
          // return const MessagePreset();
        }
      case 2:
        return const ImageCardGenerate();
      case 3:
        break;
      case 4:
        break;
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {

    cIP = Provider.of<CurrentPageProvider>(context, listen: true);

    screenWidth = MediaQuery.of(context).size.width;


    if (MediaQuery.of(context).size.width < 1500 || MediaQuery.of(context).size.height < 720) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, size: 30, color: Colors.black),
              SizedBox(height: 30),
              TitleHeavy('모자이크 화면 크기 안내', 16.0),
              SizedBox(height: 30),
              TitleNormal('모자이크는 가로 1500, 세로 720 이상에 최적화 되어 있습니다.', 14.0),
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
                              color: Color(0xffbcc0c7)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 109,
                                height: 89,
                                margin: const EdgeInsets.only(top: 16, bottom: 37),
                                decoration: const BoxDecoration(
                                    color: Color(0xffbcc0c7)
                                ),
                                child: Image.asset('assets/images/mosaic_logo.png', scale: 1.0),
                              ),

                              leftMenu(1),
                              leftMenu(2),
                              leftMenu(3),
                              leftMenu(4),
                              leftMenu(5),
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
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
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
                                                  fontFamily: "NotoSansCJKKR",
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
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    // image: AssetImage('assets/images/kakao_person.png')
                                                  image: NetworkImage(UserData.userImageUrl)
                                                )
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

                              // const SelectFriends(),  //메시지 보내기, 선택된 메뉴에 따라 페이지 변경

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


import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/kakao_login.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:provider/provider.dart';
import '../send_message/message_templates/message_preset.dart';
import '../send_message/select_friends.dart';
import '../send_message/select_message.dart';
import '../user_data/registered_friends_provider.dart';
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
  double screenHeight = 720;

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
                      // fontFamily: "NotoSansCJKKR",
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
      },
    );
  }

  Widget currentPage() {

    switch (cIP.getMainPage()) {
      case 0:
        break;
      case 1:
        if (cIP.getSubPage() == 0) {
          return const SelectFriends();
        } else if (cIP.getSubPage() == 1) {
          return const SelectMessage();
        } else {
          return const MessagePreset();
        }
      case 2:
        break;
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

    if (MediaQuery.of(context).size.width >1280) {
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      screenWidth = 1280;
    }

    if (MediaQuery.of(context).size.height >720) {
      screenHeight = MediaQuery.of(context).size.height * 2;
    } else {
      screenHeight = 720;
    }

    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: screenWidth,
              height: MediaQuery.of(context).size.height * 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 15,
                    child: Container( //left menu
                      width: 192,
                      // height: screenHeight,
                      decoration: const BoxDecoration(
                          color: Color(0xffbcc0c7)
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 109,
                            height: 89,
                            margin: const EdgeInsets.only(top: 16, bottom: 37),
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

                        currentPage() //보여줄 페이지 선택

                        // const SelectFriends(),  //메시지 보내기, 선택된 메뉴에 따라 페이지 변경

                      ],
                    )
                  )
                ],
              ),
            )
          ),
        ),
    );
  }
}


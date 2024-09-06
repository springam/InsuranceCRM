import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'gate/gate_main.dart';
import 'homepage/homepage_index.dart';
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
      if (UserData.userId == 0) {
        kakaoTalkLogin();
        return const HomepageIndex();
      } else {
        return const UserCheck();
      }
    } else {
      return const HomepageIndex();
    }



  }

}

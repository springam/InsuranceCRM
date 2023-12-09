import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'gate/gate_main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late UserItemProvider uIP;

  Future<dynamic> getUserInfoWithKakao() async{ // 웹애서 사용자 정보 받아 오기

    try {
      User user = await UserApi.instance.me();
      setState(() {
        UserData.userId = user.id;
        UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
        UserData.userEmail = '${user.kakaoAccount?.email}';
        UserData.userImageUrl = '${user.kakaoAccount?.profile?.profileImageUrl}';
      });

    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
    }
  }

  // Future<dynamic> authorizeNewScope() async{ //redirect 방식에는 이리 가서 authorizeNewScope() 써야 한다는데 '/' 오류 남
  //   List<String> scopes = ['friends', 'talk_message', 'account_email'];
  //   try {
  //     debugPrint('추가 항목 동의 받기 진입');
  //     await AuthCodeClient.instance.authorizeWithNewScopes(
  //         scopes: scopes,
  //         // redirectUri: 'https://mosaic-bluenco.web.app',
  //         redirectUri: 'http://localhost:5000'
  //     );
  //     debugPrint('추가 항목 동의 받기 성공');
  //   } catch (error) {
  //     debugPrint('추가 항목 동의 받기 실패 $error');
  //   }
  // }

  Future<dynamic> loginWithAuthorize() async{  //안드로이드 사용자 정보와 추가 동의 동시 진행
    User user;
    try {
      user = await UserApi.instance.me();

      setState(() {
        UserData.userId = user.id;
        UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
        UserData.userEmail = '${user.kakaoAccount?.email}';
        UserData.userImageUrl = '${user.kakaoAccount?.profile?.profileImageUrl}';
      });

      UserToken.hasToken = true;
    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
      UserToken.hasToken = false;
      return;
    }

    //////////////////////////////////////////////////////////////////////////

    // // 사용자의 추가 동의가 필요한 사용자 정보 동의 항목 확인
    // List<String> scopes = ['friends', 'talk_message' ,'account_email'];
    //
    // try {
    //   token = await UserApi.instance.loginWithNewScopes(scopes);
    // } catch (error) {
    //   debugPrint('추가 동의 요청 실패 $error');
    //   return;
    // }
    //
    // try { //추가 동의 항목 후 토큰 재 발급
    //   User user = await UserApi.instance.me();
    //
    //   UserData.userId = user.id;
    //   UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
    //   UserData.userEmail = '${user.kakaoAccount?.email}';
    //   UserData.userImageUrl = '${user.kakaoAccount?.profile?.profileImageUrl}';
    //
    // } catch (error) {
    //   debugPrint('사용자 정보 요청 실패 $error');
    //   return;
    // }
  }

  Future<dynamic> kakaoTalkLogin() async{  //카카오 로그인

    // debugPrint(await KakaoSdk.origin);

    // bool isInstalled = await isKakaoTalkInstalled();
    //
    // OAuthToken token = isInstalled
    //     ? await UserApi.instance.loginWithKakaoTalk()
    //     : await UserApi.instance.loginWithKakaoAccount();

    if (await isKakaoTalkInstalled()) {
      try {
        // OAuthToken token = await UserApi.instance.loginWithKakaoTalk();  //인가 코드 받기
        await UserApi.instance.loginWithKakaoTalk();
        await loginWithAuthorize(); //추가 항목 동의
      } catch (error) {
        debugPrint(error.toString());
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
      }
    } else {  //카카오톡 미 설치시
      try {
        // OAuthToken token = await UserApi.instance.loginWithKakaoAccount(); //재 로그인 해야 한다네
        await UserApi.instance.loginWithKakaoAccount();
        await loginWithAuthorize();  //기본 구현 방식? 이거 앱방식 아냐?
      } catch (error) {
        debugPrint(error.toString());
      }
    }

  }

  Future<void> hasToken() async{
    if (await AuthApi.instance.hasToken()) {
      debugPrint('토큰 있음');
      try {
        AccessTokenInfo tokenInfo =
        await UserApi.instance.accessTokenInfo();
        debugPrint('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          debugPrint('토큰 만료 $error');
          UserToken.hasToken = false;
        } else {
          debugPrint('토큰 정보 조회 실패 $error');
          UserToken.hasToken = false;
        }

        // try {
        //   // 카카오계정으로 로그인
        //   OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        //   print('로그인 성공 ${token.accessToken}');
        // } catch (error) {
        //   print('로그인 실패 $error');
        // }
      }
    } else {
      debugPrint('발급된 토큰 없음');
      setState(() {
        UserToken.hasToken = false;
      });
      // try {
      //   OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      //   print('로그인 성공 ${token.accessToken}');
      // } catch (error) {
      //   print('로그인 실패 $error');
      // }
    }
  }

  Widget loginPage() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text('Welcome to Mosaic', style: TextStyle(fontSize: 20.0)),

            const SizedBox(height: 30),

            InkWell(
              child: Image.asset('assets/images/kakao_login_large_narrow.png', scale: 2.0,),
              onTap: () async{
                await kakaoTalkLogin();
                // await getUserInfoWithKakao();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    uIP = Provider.of<UserItemProvider>(context);

    if (UserToken.hasToken) {
      if (UserData.userId == 0) {
        kakaoTalkLogin();
        return loginPage();
      } else {
        return const UserCheck();
      }
    } else {
      return loginPage();
    }
  }
}


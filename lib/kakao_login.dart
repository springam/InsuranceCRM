import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'dart:developer' as developer;

class Login extends StatelessWidget {
  const Login({super.key});

  Future<dynamic> kakaoTalkLogin() async{

    // bool isInstalled = await isKakaoTalkInstalled();
    //
    // OAuthToken token = isInstalled
    //     ? await UserApi.instance.loginWithKakaoTalk()
    //     : await UserApi.instance.loginWithKakaoAccount();

    String REDIRECT_URI = 'http://localhost:50437';

    // if (await isKakaoTalkInstalled()) {
    //   try {
    //     await AuthCodeClient.instance.authorizeWithTalk(
    //       redirectUri: '${REDIRECT_URI}',
    //     );
    //     print('카카오톡 로그인');
    //   } catch (error) {
    //     print('카카오톡 로그인 실패');
    //   }
    // } else {
    //   try {
    //     await AuthCodeClient.instance.authorize(
    //       redirectUri: '${REDIRECT_URI}'
    //     );
    //     print('이리 옴');
    //   } catch (error) {
    //     print('여기까지 왔어');
    //     print('카카오계정으로 로그인 실패 $error');
    //   }
    // }

    if (await isKakaoTalkInstalled()) {

      try {
        OAuthToken token =
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
      }
    } else {
      try {
        OAuthToken token =
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(
          // style: ElevatedButton.styleFrom(
          // padding: const EdgeInsets.all(10)),
          child: Image.asset('assets/images/kakao_login_large_narrow.png'),
          onPressed: () async{
            kakaoTalkLogin();

            // try {
            //   AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
            //   print('이미 액세스 토큰이 존재하므로 로그인을 시도하지 않습니다.');
            //
            //   User user = await UserApi.instance.me();
            //   print('사용자 정보 요청 성공'
            //       '\n회원번호: ${user.id}'
            //       '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            //       '\n이메일: ${user.kakaoAccount?.email}');
            // } catch (error) {
            //   print('액세스 토큰이 존재하지 않습니다. 로그인을 시도합니다.');
            //   OAuthToken token = await kakaoLogin();
            //   User user = await UserApi.instance.me();
            //   if(token != null) {
            //     print('사용자 정보 요청 성공'
            //         '\n회원번호: ${user.id}'
            //         '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            //         '\n이메일: ${user.kakaoAccount?.email}');
            //   }
            // }

          },
        )
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import '../gate/gate_main.dart';

late UserItemProvider uIP;

Future<dynamic> getUserInfoWithKakao() async{ // 웹애서 사용자 정보 받아 오기

  try {
    User user = await UserApi.instance.me();
    UserData.userId = user.id;
    UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
    UserData.userEmail = '${user.kakaoAccount?.email}';
    UserData.userImageUrl = '${user.kakaoAccount?.profile?.profileImageUrl}';

  } catch (error) {
    debugPrint('사용자 정보 요청 실패 $error');
  }
}

Future<dynamic> loginWithAuthorize() async {
  //안드로이드 사용자 정보와 추가 동의 동시 진행
  User user;
  try {
    user = await UserApi.instance.me();

    UserData.userId = user.id;
    UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
    UserData.userEmail = '${user.kakaoAccount?.email}';
    UserData.userImageUrl =
    '${user.kakaoAccount?.profile?.profileImageUrl}';

    UserToken.hasToken = true;
  } catch (error) {
    debugPrint('사용자 정보 요청 실패 $error');
    UserToken.hasToken = false;
    return;
  }
}

Future<dynamic> kakaoTalkLogin() async{  //카카오 로그인

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

    }
  } else {
    debugPrint('발급된 토큰 없음');
    UserToken.hasToken = false;
  }
}



import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as prefix;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:http/http.dart' as http;
import 'kakao_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy(); //
  KakaoSdk.init(
    nativeAppKey: '0c1d21b2ac161d3f13d08dea127666d7',
    javaScriptAppKey: '2849088ddba15764563fb0f98e2a1cdf',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosaic Blue&co',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mosaic Blue&co'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String accessToken = 'null';
  int userId = 00000;
  var userNickname = '';
  var userEmail = 'Email 추가요청 구형해야 함';

  Future<dynamic> getUserInfoWithKakao() async{
    try {
      User user = await UserApi.instance.me();
      // userId = user.id as String;
      // userNickname = user.kakaoAccount?.profile?.nickname as String;
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');

      setState(() {
        accessToken = 'UserID : ${user.id}/n nickname : ${user.kakaoAccount?.profile?.nickname}/n Email : ${user.kakaoAccount?.email}';
        userId = user.id;
        userNickname = '${user.kakaoAccount?.profile?.nickname}';
      });

    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  Future<dynamic> kakaoTalkLogin() async{

    // print(await KakaoSdk.origin);

    // bool isInstalled = await isKakaoTalkInstalled();
    //
    // OAuthToken token = isInstalled
    //     ? await UserApi.instance.loginWithKakaoTalk()
    //     : await UserApi.instance.loginWithKakaoAccount();

    if (await isKakaoTalkInstalled()) {
      try {
        // OAuthToken token =
        await UserApi.instance.loginWithKakaoTalk();
        await getUserInfoWithKakao();
      } catch (error) {
        setState(() {
          accessToken = error.toString();
        });

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

      }
    } else {
      try {
        // OAuthToken token =
        await UserApi.instance.loginWithKakaoAccount();
        await getUserInfoWithKakao();
      } catch (error) {
        setState(() {
          accessToken = error.toString();
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {

    if (userId == 00000) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                accessToken,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              InkWell(
                child: Image.asset('assets/images/kakao_login_large_narrow.png'),
                onTap: () {
                  kakaoTalkLogin();
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('$userNickname 님 반갑습니다.'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                accessToken,
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              InkWell(
                child: Image.asset('assets/images/kakao_login_large_narrow.png'),
                onTap: () {
                  setState(() {
                    userId = 00000;
                  });
                },
              ),
            ],
          ),
        ),
      );
    }



  }
}

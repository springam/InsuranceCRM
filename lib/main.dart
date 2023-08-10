import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as prefix;
import 'package:flutter/foundation.dart';
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
      initialRoute: '',
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
  String accessToken = 'access token is empty';
  int userId = 00000;
  var userNickname = '';
  var userEmail = 'Email 추가요청 구형해야 함';

  Future<dynamic> getUserInfoWithKakao() async{ // 웹애서 사용자 정보 받아 오기

    try {
      User user = await UserApi.instance.me();
      // userId = user.id as String;
      // userNickname = user.kakaoAccount?.profile?.nickname as String;
      debugPrint('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');

      setState(() {
        accessToken = 'UserID : ${user.id}\n nickname : ${user.kakaoAccount?.profile?.nickname}\n Email : ${user.kakaoAccount?.email}';
        userId = user.id;
        userNickname = '${user.kakaoAccount?.profile?.nickname}';
        userEmail = '${user.kakaoAccount?.email}';
      });

    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
    }
  }

  Future<dynamic> authorizeNewScope() async{ //추가 동의 받기
    try {
      debugPrint('추가 항목 동의 받기 진입');
      await AuthCodeClient.instance.authorizeWithNewScopes(
        scopes: ['friends', 'talk_message', 'account_email'],
        // redirectUri: 'https://mosaic-bluenco.web.app',
        redirectUri: 'http://localhost:5000'
      );
      debugPrint('추가 항목 동의 받기 성공');
    } catch (error) {
      debugPrint('추가 항목 동의 받기 실패 $error');
    }
  }

  Future<dynamic> loginWithAuthorize() async{  //안드로이드 사용자 정보와 추가 동의 동시 진행
    User user;
    OAuthToken token;
    try {
      user = await UserApi.instance.me();
      debugPrint('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');

      setState(() {
        accessToken = 'UserID : ${user.id}\n nickname : ${user.kakaoAccount?.profile?.nickname}\n Email : ${user.kakaoAccount?.email}';
        userId = user.id;
        userNickname = '${user.kakaoAccount?.profile?.nickname}';
      });
    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
      return;
    }

    // 사용자의 추가 동의가 필요한 사용자 정보 동의 항목 확인
    List<String> scopes = ['friends', 'talk_message' ,'account_email'];

    try {
      token = await UserApi.instance.loginWithNewScopes(scopes);
      debugPrint('현재 사용자가 동의한 동의 항목: ${token.scopes}');
    } catch (error) {
      debugPrint('추가 동의 요청 실패 $error');
      return;
    }

    try {
      User user = await UserApi.instance.me();
      debugPrint('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
    }
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
        // OAuthToken token =
        await UserApi.instance.loginWithKakaoTalk();  //인가 코드 받기
        if (kIsWeb) {
          await getUserInfoWithKakao();  //인가 코드로 토근 받기
        } else {
          await loginWithAuthorize();  //안드로이드 항목동의까지 한번에 진행
        }

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
    } else {  //카카오톡 미 설치시
      try {
        // OAuthToken token =
        await UserApi.instance.loginWithKakaoAccount();
        if (kIsWeb) {
          await getUserInfoWithKakao();
        } else {
          await loginWithAuthorize();
        }
      } catch (error) {
        setState(() {
          accessToken = error.toString();
        });
      }
    }

  }

  Future<dynamic> getFriendsList() async{  //친구 목록 가져오기
    try {
      Friends friends = await TalkApi.instance.friends();
      debugPrint('카카오톡 친구 목록 가져오기 성공'
          '\n${friends.elements?.map((friend) => friend.profileNickname).join('\n')}');
    } catch (error) {
      debugPrint('카카오톡 친구 목록 가져오기 실패 $error');
    }
  }

  Future<dynamic> messageSendMe() async{

    final FeedTemplate defaultFeed = FeedTemplate(
      content: Content(
        title: '딸기 치즈 케익',
        description: '#케익 #딸기 #삼평동 #카페 #분위기 #소개팅',
        imageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        link: Link(
            webUrl: Uri.parse('https://developers.kakao.com'),
            mobileWebUrl: Uri.parse('https://developers.kakao.com')),
      ),
      itemContent: ItemContent(
        profileText: 'Kakao',
        profileImageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        titleImageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        titleImageText: 'Cheese cake',
        titleImageCategory: 'cake',
        items: [
          ItemInfo(item: 'cake1', itemOp: '1000원'),
          ItemInfo(item: 'cake2', itemOp: '2000원'),
          ItemInfo(item: 'cake3', itemOp: '3000원'),
          ItemInfo(item: 'cake4', itemOp: '4000원'),
          ItemInfo(item: 'cake5', itemOp: '5000원')
        ],
        sum: 'total',
        sumOp: '15000원',
      ),
      social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
      buttons: [
        Button(
          title: '웹으로 보기',
          link: Link(
            webUrl: Uri.parse('https: //developers.kakao.com'),
            mobileWebUrl: Uri.parse('https: //developers.kakao.com'),
          ),
        ),
        Button(
          title: '앱으로보기',
          link: Link(
            androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
            iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
          ),
        ),
      ],
    );

    try {
      await TalkApi.instance.sendDefaultMemo(defaultFeed);
      debugPrint('나에게 보내기 성공');
    } catch (error) {
      debugPrint('나에게 보내기 실패 $error');
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
              if (!kIsWeb) Text("android? ${Platform.isAndroid}"),
              if (!kIsWeb) Text("ios? ${Platform.isIOS}"),
              if (kIsWeb) const Text("This platform is web"),
              Text(
                accessToken
              ),

              const SizedBox(height: 10,),

              InkWell(
                child: Image.asset('assets/images/kakao_login_large_narrow.png', scale: 2.0,),
                onTap: () async{
                  userId = 000;
                  await kakaoTalkLogin();
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
                accessToken
              ),

              // InkWell(
              //   child: Image.asset('assets/images/kakao_login_large_narrow.png', scale: 2.0,),
              //   onTap: () {
              //     setState(() {
              //       userId = 00000;
              //     });
              //   },
              // ),

              ElevatedButton(
                  child: const Text('나에게 메시지 보내기'),
                  onPressed: () async{
                    if (kIsWeb) await authorizeNewScope();  //web 환경이면 추가 항목 동의 받기
                    // await getFriendsList();
                    messageSendMe();
                  },
              )
            ],
          ),
        ),
      );
    }



  }
}

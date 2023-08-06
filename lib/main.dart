import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Mosaic BlueNco',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String accessToken = 'null';

  static const String redirectUri = 'http://localhost:60559';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Future<dynamic> kakaoTalkLogin() async { //return value : UserCredential
  //
  //   final clientState = const Uuid().v4();
  //   final authUri = Uri.https('kauth.kakao.com', '/oauth/authorize', {
  //     'response_type': 'code',
  //     'client_id': '330134bf7dd94dd04c719abce6080d18',
  //     'response_mode': 'form_post',
  //     'redirect_uri': redirectUri,
  //     'scope': 'account_email', // account_email profile
  //     // 'state': clientState,
  //   });
  //   print('여기 온건가?');
  //   print(authUri.toString());
  //   final authResponse = await FlutterWebAuth.authenticate(
  //       url: authUri.toString(),
  //       callbackUrlScheme: "webauthcallback"
  //   );
  //   print(authResponse);
  //   print('토큰 요청');
  //   final code = Uri.parse(authResponse).queryParameters['code'];
  //   final tokenUri = Uri.https('kauth.kakao.com', '/oauth/token', {
  //     'grant_type': 'authorization_code',
  //     'client_id': '330134bf7dd94dd04c719abce6080d18',
  //     'redirect_uri': redirectUri,
  //     'code': code,
  //   });
  //   print('토큰 받아 왔어');
  //   final tokenResult = await http.post(tokenUri);
  //   final accessToken = json.decode(tokenResult.body)['access_token'];
  //   print(accessToken.toString());
  //   final response = await http.get(
  //       Uri.parse('$redirectUri/kakao/token?accessToken=$accessToken')
  //   );
  //   print(response.body);
  //   // return await FirebaseAuth.instance.signInWithCustomToken(response.body);
  // }

  Future<dynamic> kakaoTalkLogin() async{

    // bool isInstalled = await isKakaoTalkInstalled();
    //
    // OAuthToken token = isInstalled
    //     ? await UserApi.instance.loginWithKakaoTalk()
    //     : await UserApi.instance.loginWithKakaoAccount();

    print('여긴 온거니?');
    setState(() {
      accessToken = '여기서 시작';
    });

    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인

    if (await isKakaoTalkInstalled()) {
      print('카카오 깔았네');
      try {
        setState(() {
          accessToken = '카카오 있어서 이리로 왔구나?';
        });
        print('기점 1');
        OAuthToken token =
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공 ${token.accessToken}');
        setState(() {
          accessToken = token.accessToken;
        });
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          print('기점 2');
          OAuthToken token =
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      print('카카오 없어?');
      try {
        print('카카오 없어서 로그인하러 왔구나?');
        setState(() {
          accessToken = '카카오 없어서 로그인하러 왔구나?';
        });
        OAuthToken token =
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공 ${token.accessToken}');
        setState(() {
          accessToken = token.accessToken;
        });
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

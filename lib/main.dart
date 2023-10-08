import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/kakao_login.dart';
import 'package:mosaicbluenco/user_data/registered_friends_provider.dart';
import 'package:mosaicbluenco/user_data/response_friend_provider.dart';
import 'package:mosaicbluenco/user_data/status_provider.dart';
import 'package:mosaicbluenco/user_data/message_provider.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCYifgblNoq-cYEAXpUFyzMlpfuXFtNtYc',
      appId: '1:21784424587:web:182e43a8fad5997cbc648e',
      messagingSenderId: '21784424587',
      projectId: 'mosaic-bluenco',
      authDomain: 'mosaic-bluenco.firebaseapp.com',
      storageBucket: 'mosaic-bluenco.appspot.com',
      measurementId: 'G-XQB6FE3Z74',
    )
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserItemProvider()),
        ChangeNotifierProvider(
            create: (_) => RegisteredFriendsItemProvider()),
        ChangeNotifierProvider(
            create: (_) => SendMessageFriendsItemProvider()),
        ChangeNotifierProvider(
            create: (_) => CurrentPageProvider()),
        ChangeNotifierProvider(
            create: (_) => MessageItemProvider()),
        ChangeNotifierProvider(
            create: (_) => TextMessageProvider()),
        ChangeNotifierProvider(
            create: (_) => ResponseFriendsItemProvider()),
      ],
      child: MaterialApp(
        title: 'Mosaic Blue&co',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // home: const Login(title: 'Mosaic Blue&co'),
        home: const Scaffold(
            body: Login()
        ),
      ),
    );
  }
}



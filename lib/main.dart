import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/user_data/registered_friends_provider.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:url_strategy/url_strategy.dart';
import 'gate/gate_main.dart';


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
  // runApp(MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(
  //         create: (_) => UserItemProvider()),
  //     ChangeNotifierProvider(
  //         create: (_) => RegisteredFriendsItemProvider()),
  //   ],
  //   child: const MyApp(),
  // ));
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
      ],
      child: MaterialApp(
        title: 'Mosaic Blue&co',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // home: const Login(title: 'Mosaic Blue&co'),
        home: const Scaffold(
            body: UserItemList()
        ),
      ),
    );
    // return MaterialApp(
    //   title: 'Mosaic Blue&co',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    //     useMaterial3: true,
    //   ),
    //   // home: const Login(title: 'Mosaic Blue&co'),
    //   home: const Scaffold(
    //       body: UserItemList()
    //   ),
    // );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mosaicbluenco/home_main/home_main.dart';
import 'package:mosaicbluenco/user_data/user_data.dart';
import 'package:mosaicbluenco/user_data/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'gate/gate_friend.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late UserItemProvider uIP;

  DateTime now = DateTime.now();

  // Future<dynamic> getUserInfoWithKakao() async{ // 웹애서 사용자 정보 받아 오기
  //
  //   try {
  //     User user = await UserApi.instance.me();
  //     setState(() {
  //       accessToken = 'UserID : ${user.id}\n nickname : ${user.kakaoAccount?.profile?.nickname}\n Email : ${user.kakaoAccount?.email}';
  //       userId = user.id;
  //       userProfileImage = '${user.kakaoAccount?.profile?.profileImageUrl}';
  //       userNickname = '${user.kakaoAccount?.profile?.nickname}';
  //       userEmail = '${user.kakaoAccount?.email}';
  //     });
  //
  //   } catch (error) {
  //     debugPrint('사용자 정보 요청 실패 $error');
  //   }
  // }

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

  Future<dynamic> registerMosaic(int userId) async{
    for (UserItem userItem in uIP.getItem()) {
      if (userItem.kakaoId == userId) {
        UserData.userId = userId;
      }
    }
  }

  Future<dynamic> loginWithAuthorize() async{  //안드로이드 사용자 정보와 추가 동의 동시 진행
    User user;
    OAuthToken token;
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

    // 사용자의 추가 동의가 필요한 사용자 정보 동의 항목 확인
    List<String> scopes = ['friends', 'talk_message' ,'account_email'];

    try {
      token = await UserApi.instance.loginWithNewScopes(scopes);

      await registerMosaic(user.id);  //회원 체크

      if (UserData.userId == 0) { //등록된 회원정보가 없을 시
        final docRef = FirebaseFirestore.instance.collection('customer').doc();
        docRef.set({
          'kakao_id': user.id,
          'email': user.kakaoAccount?.email,
          'phone_number': '',
          'name': '',
          'date_join': DateFormat("yyyy년 MM월 dd일 hh시 mm분").format(now),
          'date_start': '',
          'date_end': '',
          'tier': 'normal',
          'document_id': docRef.id,
          'etc': ''
        });
      } else {

      }

      debugPrint('현재 사용자가 동의한 동의 항목: ${token.scopes}');
    } catch (error) {
      debugPrint('추가 동의 요청 실패 $error');
      return;
    }

    try { //추가 동의 항목 후 토큰 재 발급
      User user = await UserApi.instance.me();

      UserData.userId = user.id;
      UserData.userNickname = '${user.kakaoAccount?.profile?.nickname}';
      UserData.userEmail = '${user.kakaoAccount?.email}';
      UserData.userImageUrl = '${user.kakaoAccount?.profile?.profileImageUrl}';

    } catch (error) {
      debugPrint('사용자 정보 요청 실패 $error');
      return;
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
        await loginWithAuthorize();
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
        // OAuthToken token =
        await UserApi.instance.loginWithKakaoAccount();
        await loginWithAuthorize();  //기본 구현 방식? 이거 앱방식 아냐?
      } catch (error) {
        debugPrint(error.toString());
      }
    }

  }

  Future<dynamic> getFriendsList() async{  //친구 목록 가져오기
    try {
      Friends friends = await TalkApi.instance.friends();
      // debugPrint('카카오톡 친구 목록 가져오기 성공'
      //     '\n${friends.elements?.map((friend) => friend.profileNickname).join('\n')}');
    } catch (error) {
      debugPrint('카카오톡 친구 목록 가져오기 실패 $error');
    }
  }

  Future<dynamic> messageSendMe() async{

    final FeedTemplate defaultFeed = FeedTemplate(
      content: Content(
        title: '고객 관리 비서 모자이크',
        description: '#보험 #고객관리 #모자이크 #CRM #자동관리',
        imageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        link: Link(
            webUrl: Uri.parse('https://mosaic-bluenco.web.app'),
            mobileWebUrl: Uri.parse('https://mosaic-bluenco.web.app')),
      ),
      itemContent: ItemContent(
        profileText: '모자이크',
        profileImageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        titleImageUrl: Uri.parse(
            'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
        titleImageText: '타이틀 이미지',
        titleImageCategory: '이미지 category',
        items: [
          ItemInfo(item: '1개월 사용료', itemOp: '30,000원'),
          ItemInfo(item: '3개월 사용료', itemOp: '80,000원'),
          ItemInfo(item: '6개월 사용료', itemOp: '150,000원'),
          ItemInfo(item: '1년 사용료', itemOp: '400,000원'),
          ItemInfo(item: 'Premium', itemOp: '500,00원')
        ],
        sum: '오픈 이벤트',
        sumOp: '20,000원',
      ),
      social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
      buttons: [
        Button(
          title: '홈 페이지로 이동',
          link: Link(
            webUrl: Uri.parse('https://mosaic-bluenco.web.app'),
            mobileWebUrl: Uri.parse('https://mosaic-bluenco.web.app'),
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
        return const RegisteredFriendsItemList();
      }
    } else {
      return loginPage();
    }
  }
}


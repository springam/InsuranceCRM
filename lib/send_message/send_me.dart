import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<dynamic> messageSendMe() async{

  final FeedTemplate defaultFeed = FeedTemplate(
    content: Content(
      title: '',
      description: '#보험 #고객관리 #모자이크 #CRM #자동관리',
      imageUrl: Uri.parse(''),
      link: Link(webUrl: Uri.parse(''), mobileWebUrl: Uri.parse('')),
    ),
    itemContent: ItemContent(
    //   profileText: '모자이크',
    //   profileImageUrl: Uri.parse(
    //       'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
    //   titleImageUrl: Uri.parse(
    //       'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
    //   titleImageText: '타이틀 이미지',
    //   titleImageCategory: '이미지 category',
    //   items: [
    //     ItemInfo(item: '1개월 사용료', itemOp: '30,000원'),
    //     ItemInfo(item: '3개월 사용료', itemOp: '80,000원'),
    //     ItemInfo(item: '6개월 사용료', itemOp: '150,000원'),
    //     ItemInfo(item: '1년 사용료', itemOp: '400,000원'),
    //     ItemInfo(item: 'Premium', itemOp: '500,00원')
    //   ],
    //   sum: '오픈 이벤트',
    //   sumOp: '20,000원',
    // ),
    // social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
    // buttons: [
    //   Button(
    //     title: '홈 페이지로 이동',
    //     link: Link(
    //       webUrl: Uri.parse('https://mosaic-bluenco.web.app'),
    //       mobileWebUrl: Uri.parse('https://mosaic-bluenco.web.app'),
    //     ),
    //   ),
    //   Button(
    //     title: '앱으로보기',
    //     link: Link(
    //       androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
    //       iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
    //     ),
    //   ),
    // ],
  );

  try {
    await TalkApi.instance.sendDefaultMemo(defaultFeed);
    debugPrint('나에게 보내기 성공');
  } catch (error) {
    debugPrint('나에게 보내기 실패 $error');
  }
}

// final FeedTemplate defaultFeed = FeedTemplate(
//   content: Content(
//     title: '고객 관리 비서 모자이크',
//     description: '#보험 #고객관리 #모자이크 #CRM #자동관리',
//     imageUrl: Uri.parse(
//         'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
//     link: Link(
//         webUrl: Uri.parse('https://mosaic-bluenco.web.app'),
//         mobileWebUrl: Uri.parse('https://mosaic-bluenco.web.app')),
//   ),
//   itemContent: ItemContent(
//     profileText: '모자이크',
//     profileImageUrl: Uri.parse(
//         'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
//     titleImageUrl: Uri.parse(
//         'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png'),
//     titleImageText: '타이틀 이미지',
//     titleImageCategory: '이미지 category',
//     items: [
//       ItemInfo(item: '1개월 사용료', itemOp: '30,000원'),
//       ItemInfo(item: '3개월 사용료', itemOp: '80,000원'),
//       ItemInfo(item: '6개월 사용료', itemOp: '150,000원'),
//       ItemInfo(item: '1년 사용료', itemOp: '400,000원'),
//       ItemInfo(item: 'Premium', itemOp: '500,00원')
//     ],
//     sum: '오픈 이벤트',
//     sumOp: '20,000원',
//   ),
//   social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
//   buttons: [
//     Button(
//       title: '홈 페이지로 이동',
//       link: Link(
//         webUrl: Uri.parse('https://mosaic-bluenco.web.app'),
//         mobileWebUrl: Uri.parse('https://mosaic-bluenco.web.app'),
//       ),
//     ),
//     Button(
//       title: '앱으로보기',
//       link: Link(
//         androidExecutionParams: {'key1': 'value1', 'key2': 'value2'},
//         iosExecutionParams: {'key1': 'value1', 'key2': 'value2'},
//       ),
//     ),
//   ],
// );
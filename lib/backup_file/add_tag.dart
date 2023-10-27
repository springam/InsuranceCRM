






// Container(
//   width: 33,
//   height: 33,
//   margin: const EdgeInsets.only(left: 7),
//   alignment: Alignment.center,
//   child: Material(
//     color: const Color(0xfff0f0f0),
//     child: InkWell(
//       borderRadius: BorderRadius.circular(33),
//       splashColor: const Color(0xffffdf8e),
//       hoverColor: Colors.grey,
//       child: Ink(
//         width: 33,
//         height: 33,
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(33)),
//           color: Color(0xffffffff),
//         ),
//         child: const CircleAvatar(
//           backgroundColor: Colors.transparent,
//           child: Text('+', style: TextStyle(color: Colors.black, fontSize: 14.0)),
//         ),
//       ),
//       onTap: () {
//         if (TagList.tagList.length < 20) {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return const TagPopupDialog();
//               }
//           ).then((value) {
//             setState(() {});
//           });
//         } else {
//           showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('더이상 태그를 추가할 수 없습니다.'),
//                   actions: [
//                     ElevatedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('확인')
//                     )
//                   ],
//                 );
//               }
//           );
//         }
//       },
//     ),
//   ),
// ),
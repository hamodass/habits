// import 'package:espitalia/localization/lang_const.dart';
// import 'package:espitalia/routes/route_names.dart';
// import 'package:espitalia/utilitis/constants.dart';

// import 'package:flutter/material.dart';
// import 'package:habit_tracker_application_main/utilitis/constants.dart';

// enum DialogActions { yes, no, abort }

// Widget _dialogButton(BuildContext context) {
//   return InkWell(
//     onTap: () {
//       Navigator.pushNamedAndRemoveUntil(
//           context, loginPageRoute, (route) => false);
//     },
//     child: Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           color: kFullGreenColor, borderRadius: BorderRadius.circular(10)),
//       child: Center(
//         child: Text(
//           'Done',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     ),
//   );
// }

// class DialogMessageWidget {
//   static Future<DialogActions> messageDialog(BuildContext context,
//       IconData icon, Color color, String title, String body) async {
//     final action = await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             title: Column(
//               children: [
//                 Container(
//                   height: 70,
//                   width: 70,
//                   decoration: BoxDecoration(
//                       color: Colors.grey.shade200, shape: BoxShape.circle),
//                   child: Center(
//                     child: Icon(
//                       icon,
//                       color: color,
//                       size: 35,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//             content: Text(body),
//             actions: [_dialogButton(context)],
//           );
//         });
//     return (action != null) ? action : DialogActions.abort;
//   }
// }
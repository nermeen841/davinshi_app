// // ignore_for_file: avoid_print
// import 'package:davinci/davinci.dart';
// import 'package:flutter/material.dart';

// class TestScreen extends StatefulWidget {
//   const TestScreen({Key? key}) : super(key: key);

//   @override
//   _TestScreenState createState() => _TestScreenState();
// }

// class _TestScreenState extends State<TestScreen> {
//   GlobalKey? imageKey;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ///2. wrap the desired widget with Davinci widget
//             Davinci(
//               builder: (key) {
//                 ///3. set the widget key to the globalkey
//                 imageKey = key;
//                 return Container(
//                   height: 150,
//                   width: double.infinity,
//                   color: Colors.black,
//                   child: Padding(
//                     padding: const EdgeInsets.all(18.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: 50,
//                           width: 50,
//                           color: Colors.red,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(38.0),
//               child: TextButton(
//                 onPressed: () async {
//                   ///4. pass the globalKey varible to DavinciCapture.click.
//                   await DavinciCapture.click(imageKey!,
//                       openFilePreview: true, saveToDevice: true);
//                 },
//                 child: const Text('capture',
//                     style: TextStyle(
//                       color: Colors.white,
//                     )),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

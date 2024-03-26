// import 'package:flutter/material.dart';
// import 'package:ticket_widget/ticket_widget.dart';

// class MyTicketView extends StatelessWidget {
//   const MyTicketView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black87,
//       body: Center(
//         child: TicketWidget(
//           width: 350,
//           height: 550,
//           isCornerRounded: true,
//           padding: EdgeInsets.all(20),
//           child: TicketData(),
//         ),
//       ),
//     );
//   }
// }

// class TicketData extends StatelessWidget {
//   const TicketData({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/uaem.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 50,
//                 width: 150,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/park_sinfondo2.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 20.0),
//             child: Text(
//               'Ticket del Estacionamiento',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 25.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ticketDetailsWidget(
//                     'Passengers', 'Hafiz M Mujahid', 'Date', '28-08-2022'),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0, right: 52.0),
//                   child:
//                       ticketDetailsWidget('Flight', '76836A45', 'Gate', '66B'),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 12.0, right: 53.0),
//                   child:
//                       ticketDetailsWidget('Class', 'Business', 'Seat', '21B'),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
//             child: Container(
//               width: 250.0,
//               height: 60.0,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage('assets/barcode.png'), fit: BoxFit.cover),
//               ),
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
//             child: Text(
//               '0000 +9230 2884 5163',
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           const Text('         Developer: instagram.com/DholaSain')
//         ],
//       ),
//     );
//   }
// }

// Widget ticketDetailsWidget(String firstTitle, String firstDesc,
//     String secondTitle, String secondDesc) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Padding(
//         padding: const EdgeInsets.only(left: 12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               firstTitle,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: Text(
//                 firstDesc,
//                 style: const TextStyle(color: Colors.black),
//               ),
//             )
//           ],
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(right: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               secondTitle,
//               style: const TextStyle(color: Colors.grey),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: Text(
//                 secondDesc,
//                 style: const TextStyle(color: Colors.black),
//               ),
//             )
//           ],
//         ),
//       )
//     ],
//   );
// }

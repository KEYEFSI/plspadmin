



// import 'package:plsp/College/CollegeCounterController.dart';
// import 'package:plsp/College/CollegeCounterModel.dart';
// import 'package:plsp/College/UpdateFeesGrad.dart';
// import 'package:plsp/common/common.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:lottie/lottie.dart';

// class AddPaymentComponent extends StatefulWidget {
//   const AddPaymentComponent({
//     super.key,
//     required StudentCollege? selectedStudent,
//     required this.priceController,
//     required this.priceFocusNode,
//     required this.paymentnameController,
//     required this.paymentnameFocusNode,
//     required this.onPaymentSaved,
//   }) : _selectedStudent = selectedStudent;

//   final StudentCollege? _selectedStudent;
//   final TextEditingController priceController;
//   final FocusNode priceFocusNode;
//   final TextEditingController paymentnameController;
//   final FocusNode paymentnameFocusNode;
//   final VoidCallback onPaymentSaved;

//   @override
//   State<AddPaymentComponent> createState() => _AddPaymentComponentState();
// }

// class _AddPaymentComponentState extends State<AddPaymentComponent> {
//   final FeeController feeController = FeeController(baseUrl: kUrl);
//   final GetCollege getIS = GetCollege(kUrl);

//   // void _saveFeeDetails() async {
//   //   if (widget._selectedStudent == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('No student selected')),
//   //     );
//   //     return;
//   //   }

//   //   final String priceText = widget.priceController.text;
//   //   final double price = double.tryParse(priceText) ??
//   //       -1.0; // Use -1.0 to indicate invalid input

//   //   if (price <= 0) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('Please enter a valid transaction amount')),
//   //     );
//   //     return;
//   //   }

//   //   final String username = widget._selectedStudent!.username!;
//   //   final String fullname = widget._selectedStudent!.fullname!;
//   //   final String feeName = widget.paymentnameController.text;

//   //   final double oldBalance = widget._selectedStudent!.balance!;

//   //   final double newBalance = oldBalance + price;

//   //   final feeDetails = FeeDetails(
//   //     username: username,
//   //     fullname: fullname,
//   //     feeName: feeName,
//   //     price: price,
//   //     oldBalance: oldBalance,
//   //     newBalance: newBalance,
//   //   );

//   //   final success = await feeController.saveFeeDetails(feeDetails);

//   //   if (success) {
//   //     widget.onPaymentSaved();
//   //     Navigator.of(context).pop();
//   //     _showDialog('Success', 'Fee details saved successfully');
//   //   } else {
//   //     _showDialog('Error', 'Failed to save fee details');
//   //   }
//   // }

//   // void _showDialog(String title, String message) {
//   //   showDialog(
//   //     context: context,
//   //     barrierDismissible: false,
//   //     builder: (context) {
//   //       return StatefulBuilder(
//   //         builder: (context, setState) {
//   //           // Show the dialog
//   //           WidgetsBinding.instance.addPostFrameCallback((_) {
//   //             Future.delayed(Duration(seconds: 2), () async {
//   //               Navigator.of(context).pop();
//   //             });
//   //           });

//   //           return AlertDialog(
//   //             backgroundColor: Colors.transparent,
//   //             elevation: 0,
//   //             contentPadding: EdgeInsets.zero,
//   //             content: Container(
//   //               decoration: BoxDecoration(
//   //                 color: Colors.transparent,
//   //                 borderRadius: BorderRadius.circular(12),
//   //               ),
//   //               child: Lottie.asset(
//   //                 'assets/success.json',
//   //                 fit: BoxFit.cover,
//   //               ),
//   //             ),
//   //             actions: [],
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         'Add Outstanding Balance',
//         style: GoogleFonts.poppins(
//             color: Colors.green.shade900, fontWeight: FontWeight.bold),
//       ),
//       content: Container(
//         width: MediaQuery.of(context).size.width / 4,
//         height: MediaQuery.of(context).size.width / 4,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Divider(
//               thickness: 2,
//               color: Colors.green.shade900,
//             ),
//             Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
//                     child: Text(
//                       'Php',
//                       style: GoogleFonts.poppins(
//                           color: Colors.green.shade900,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   // Text(
//                   //   widget._selectedStudent != null
//                   //       ? ' ${widget._selectedStudent!.balance?.toStringAsFixed(2) ?? '00.00'}'
//                   //       : ' 00.00',
//                   //   style: GoogleFonts.poppins(
//                   //     color: Colors.green.shade900,
//                   //     fontWeight: FontWeight.bold,
//                   //     fontSize: 60,
//                   //   ),
//                   // ),
//                 ]),
//             Divider(
//               thickness: 1,
//               color: Colors.green,
//               indent: 120,
//               endIndent: 120,
//             ),
//             Text(
//               'Outstanding Balance',
//               style: GoogleFonts.poppins(
//                 color: Colors.green.shade900,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Align(
//               alignment: AlignmentDirectional(-1, 0),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 24.0, right: 24),
//                 child: Text(
//                   'Transaction Amount',
//                   style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.green.shade900,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
//               child: TextField(
//                 controller: widget.priceController,
//                 focusNode: widget.priceFocusNode,
//                 autofillHints: const [AutofillHints.transactionAmount],
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'Transaction Amount',
//                   labelStyle: GoogleFonts.poppins(
//                     fontSize: 14.0,
//                     color: Colors.green.shade900,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).primaryColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).hintColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).cardColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).disabledColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   filled: false,
//                   fillColor: Theme.of(context).primaryColorLight,
//                   prefixIcon: Icon(
//                     FontAwesome.money,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 style: GoogleFonts.poppins(
//                   fontSize: 14.0,
//                   color: Theme.of(context).hoverColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Align(
//               alignment: AlignmentDirectional(-1, 0),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 24.0, right: 24),
//                 child: Text(
//                   'Education Cost Name',
//                   style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.green.shade900,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
//               child: TextField(
//                 controller: widget.paymentnameController,
//                 focusNode: widget.paymentnameFocusNode,
//                 autofillHints: const [AutofillHints.transactionAmount],
//                 obscureText: false,
//                 decoration: InputDecoration(
//                   labelText: 'Education Cost Name',
//                   labelStyle: GoogleFonts.poppins(
//                     fontSize: 14.0,
//                     color: Colors.green.shade900,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).primaryColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).hintColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).cardColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderSide: BorderSide(
//                       color: Theme.of(context).disabledColor,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   filled: false,
//                   fillColor: Theme.of(context).primaryColorLight,
//                   prefixIcon: Icon(
//                     MaterialCommunityIcons.tag_heart,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//                 style: GoogleFonts.poppins(
//                   fontSize: 14.0,
//                   color: Theme.of(context).hoverColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 keyboardType: TextInputType.text,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 24.0, right: 24),
//               child: ElevatedButton(
//                 onPressed: _saveFeeDetails,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.zero,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Container(
//                   width: double.infinity,
//                   height: MediaQuery.of(context).size.height / 20,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.green.shade900,
//                         Colors.greenAccent.shade700,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         MaterialIcons.move_to_inbox,
//                         color: Colors.white,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         'Save',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

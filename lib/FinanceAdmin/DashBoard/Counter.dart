
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Model.dart';
import 'ORno.dart';
import 'controller.dart';

class Counter extends StatefulWidget {
  const Counter({
    super.key,
    required this.fontsize,
  });

  final double fontsize;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late final RequestCountsTodayController _controller;

 late CurrentORNumberController _ORController;
  late Future<CurrentORNumber?> _ORFuture;



  void _refreshORNumber() {
    setState(() {
      _ORFuture = _ORController.fetchCurrentORNumber();
    });
  }
  @override
  void initState() {
    super.initState();
    _controller = RequestCountsTodayController();
     _ORController = CurrentORNumberController();
    _ORFuture = _ORController.fetchCurrentORNumber(); // Initialize your controller
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    final fontsize = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(widget.fontsize / 100.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.fontsize / 80),
                color: Colors.white),
            child: StreamBuilder<RequestCountsToday>(
              stream: _controller.requestCountsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final requestCounts = snapshot.data!;

                  return Row(
                    children: [
                      OrNUmber(
                        ORFuture: _ORFuture,
                        fontsize: fontsize,
                        onCallback: _refreshORNumber,
                      ),
                      
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: fontsize / 100.0),
                          child: Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fontsize / 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFD3FFE7).withOpacity(0.5),
                                    ),
                                    child: Lottie.asset(
                                      'assets/Request.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Unpaid Requests',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.totalUnpaidRequests
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 300.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  requestCounts
                                                          .increaseUnpaidRequests
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .increaseUnpaidRequests
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.percentageUnpaidRequests.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .increaseUnpaidRequests
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Daily Requests ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.grey.shade900,
                                                      fontSize: fontsize / 160,
                                                      letterSpacing: 0,
                                                      wordSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: fontsize / 100.0),
                          child: Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fontsize / 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFD3FFE7).withOpacity(0.5),
                                    ),
                                    child: Lottie.asset(
                                      'assets/Transaction.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Paid Requests',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.totalPaidRequests
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 300.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  requestCounts
                                                          .increasePaidRequests
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .increasePaidRequests
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.percentagePaidRequests.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .increasePaidRequests
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Daily Accomodated ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade900,
                                                      fontSize: fontsize / 160,
                                                      letterSpacing: 0,
                                                      wordSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: fontsize / 100.0),
                          child: Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fontsize / 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFD3FFE7).withOpacity(0.5),
                                    ),
                                    child: Lottie.asset(
                                      'assets/Pending.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pending Documents',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.unclaimedDocuments
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 300.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  requestCounts
                                                          .increaseUnclaimedDocuments
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .increaseUnclaimedDocuments
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.percentageUnclaimedDocuments.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .increaseUnclaimedDocuments
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Pending Documents ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade900,
                                                      fontSize: fontsize / 160,
                                                      letterSpacing: 0,
                                                      wordSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: fontsize / 100.0),
                          child: Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fontsize / 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFD3FFE7).withOpacity(0.5),
                                    ),
                                    child: Lottie.asset(
                                      'assets/Ready.json',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Requests',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.claimedDocuments
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 300.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  requestCounts
                                                          .increaseClaimedDocuments
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .increaseClaimedDocuments
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.percentageClaimedDocuments.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .increaseClaimedDocuments
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Daily Requests ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color:
                                                          Colors.grey.shade900,
                                                      fontSize: fontsize / 160,
                                                      letterSpacing: 0,
                                                      wordSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return Lottie.asset('assets/Loading.json'); // Loading state
              },
            )),
      ),
    );
  }
}

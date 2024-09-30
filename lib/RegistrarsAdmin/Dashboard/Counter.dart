
import 'package:plsp/RegistrarsAdmin/Dashboard/Model.dart';
import 'package:plsp/RegistrarsAdmin/Dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = RequestCountsTodayController(); // Initialize your controller
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                                      'assets/Student.json',
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
                                        'Registered Students',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: fontsize / 120,
                                        ),
                                      ),
                                      Text(
                                        requestCounts.collegeStudentsCount
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
                                            left: fontsize / 300),
                                        child: Text(
                                          'Number of Students',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey.shade900,
                                            fontSize: fontsize / 160,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
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
                                        'Processing Requests',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey,
                                          fontSize: fontsize / 120,
                                        ),
                                      ),
                                      Text(
                                        requestCounts.unpaidDocumentsCount
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
                                                        .isUnpaidIncreasing
                                                    ? Feather.trending_up
                                                    : Feather.trending_down,
                                                color: requestCounts
                                                        .isUnpaidIncreasing
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: fontsize / 150,
                                              ),
                                              Gap(fontsize / 400),
                                              Text(
                                                '${requestCounts.unpaidPercentageChange.toStringAsFixed(0)}% ',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color: requestCounts
                                                          .isUnpaidIncreasing
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
                                          'Claimable Requests',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.paidDocumentsCount
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
                                                          .isPaidIncreasing
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .isPaidIncreasing
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.paidPercentageChange.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .isPaidIncreasing
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Unclaimed Documents ',
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
                                          'Claimed Documents',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          requestCounts.claimedDocumentsCount
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
                                                          .isClaimedIncreasing
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: requestCounts
                                                          .isClaimedIncreasing
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${requestCounts.claimedPercentageChange.toStringAsFixed(0)}% ',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: requestCounts
                                                            .isClaimedIncreasing
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Daily Claimed ',
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

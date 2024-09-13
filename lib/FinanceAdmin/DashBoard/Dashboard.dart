import 'package:plsp/FinanceAdmin/DashBoard/Calendar.dart';
import 'package:plsp/FinanceAdmin/DashBoard/Controllers.dart';
import 'package:plsp/FinanceAdmin/DashBoard/Model.dart';
import 'package:plsp/FinanceAdmin/DashBoard/ORno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

class Dashboard extends StatefulWidget {
  final String username;
  final String fullname;

  const Dashboard({super.key, required this.username, required this.fullname});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  late CurrentORNumberController _ORController;
  late Future<CurrentORNumber?> _ORFuture;
  final RequestStatisticsController controller = RequestStatisticsController();

  @override
  void initState() {
    super.initState();
    _ORController = CurrentORNumberController();
    _ORFuture = _ORController.fetchCurrentORNumber();
  }

  void _refreshORNumber() {
    setState(() {
      _ORFuture = _ORController.fetchCurrentORNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Scaffold(
      appBar: AppBar(
        title: Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      'Hello,',
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    Text(
                      ' ${widget.fullname}! ',
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    Container(
                        height: height / 20,
                        child:
                            Lottie.asset('assets/hi.json', fit: BoxFit.cover)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: fontsize / 80),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      formatted,
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(fontsize / 100.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: AssetImage('assets/dashboardbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    children: [
                      OrNUmber(
                        ORFuture: _ORFuture,
                        fontsize: fontsize,
                        onCallback: _refreshORNumber,
                      ),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: fontsize / 100.0,
                                      left: fontsize / 100.0,
                                      right: fontsize / 100.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Colors.white,
                                    ),
                                    child: StreamBuilder<RequestStatistics>(
                                        stream: controller.statisticsStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          } else if (snapshot.hasData) {
                                            final stats = snapshot.data!;
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  fontsize /
                                                                      300),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                      0xFFD3FFE7)
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Lottie.asset(
                                                              'assets/Student.json',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Registered Students',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize:
                                                                      fontsize /
                                                                          120,
                                                                ),
                                                              ),
                                                              Text(
                                                                stats
                                                                    .studentsCount
                                                                    .toString()
                                                                    .padLeft(
                                                                        3, '0'),
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green
                                                                      .shade900,
                                                                  fontSize:
                                                                      fontsize /
                                                                          80,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left:
                                                                        fontsize /
                                                                            300),
                                                                child: Expanded(
                                                                  child: Text(
                                                                    'Number of Students',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade900,
                                                                      fontSize:
                                                                          fontsize /
                                                                              160,
                                                                    ),
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
                                                Expanded(
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  fontsize /
                                                                      300),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                      0xFFD3FFE7)
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Lottie.asset(
                                                              'assets/Request.json',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Total Requests',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  stats
                                                                      .totalUnpaidRequests
                                                                      .toString()
                                                                      .padLeft(
                                                                          3,
                                                                          '0'),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                    fontSize:
                                                                        fontsize /
                                                                            80,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: fontsize /
                                                                            300.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          stats.hasRequestIncreased
                                                                              ? Feather.trending_up
                                                                              : Feather.trending_down,
                                                                          color: stats.hasRequestIncreased
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                          size: fontsize /
                                                                              150,
                                                                        ),
                                                                        Gap(fontsize /
                                                                            400),
                                                                        Text(
                                                                          '${stats.dailyRequestPercentage.toString()}% ',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: stats.hasRequestIncreased
                                                                                ? Colors.green
                                                                                : Colors.redAccent,
                                                                            fontSize:
                                                                                fontsize / 120,
                                                                            letterSpacing:
                                                                                0,
                                                                          ),
                                                                        ),
                                                                        Gap(fontsize /
                                                                            400),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            'Daily Requests ',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
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
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  fontsize /
                                                                      300),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color(
                                                                      0xFFD3FFE7)
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Lottie.asset(
                                                            'assets/Transaction.json',
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Total Accomodated',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  stats
                                                                      .totalPaidRequests
                                                                      .toString()
                                                                      .padLeft(
                                                                          3,
                                                                          '0'),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                    fontSize:
                                                                        fontsize /
                                                                            80,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: fontsize /
                                                                            300.0),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          stats.hasPaidRequestIncreased
                                                                              ? Feather.trending_up
                                                                              : Feather.trending_down,
                                                                          color: stats.hasRequestIncreased
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                          size: fontsize /
                                                                              150,
                                                                        ),
                                                                        Gap(fontsize /
                                                                            400),
                                                                        Text(
                                                                          '${stats.dailyPaidPercentage.toString()}% ',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: stats.hasPaidRequestIncreased
                                                                                ? Colors.green
                                                                                : Colors.redAccent,
                                                                            fontSize:
                                                                                fontsize / 120,
                                                                            letterSpacing:
                                                                                0,
                                                                          ),
                                                                        ),
                                                                        Gap(fontsize /
                                                                            400),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            'Daily Accomodation ',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
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
                                                )
                                              ],
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    Text('No data available'));
                                          }
                                        }),
                                  ),
                                ),
                              ),
                              Calendar(fontsize: fontsize),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Controller.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final DocumentStatisticsController _controller =
      DocumentStatisticsController();

  @override
  void initState() {
    super.initState();
    _controller.startFetching(); // Start periodic data fetching
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the stream controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    return Card(
        elevation: 11,
        color: Colors.white,
        child: StreamBuilder<DocumentStatisticsResponse>(
            stream: _controller.statisticsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
        
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
        
              if (!snapshot.hasData) {
                return const Center(child: Text("No statistics available."));
              }
        
              final data = snapshot.data!;
              final bool isIncreasedPending =
                  data.pendingCount > data.approvedCount;
                  final bool isIncreasedApproved =
                  data.pendingCount < data.approvedCount;
              final bool isIncreasedRejected =
                  data.rejectedCount > data.approvedCount;
        
              return Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(fontsize / 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(fontsize / 300),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFD3FFE7).withOpacity(0.5),
                            ),
                            child: Lottie.asset(
                              'assets/Payment.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Documents Requests',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                                fontSize: fontsize / 100,
                              ),
                            ),
                            Text(
                              data.totalCount.toString().padLeft(3, '0'),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                                fontSize: fontsize / 75,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: fontsize / 300),
                              child: Text(
                                'Overall Total Requests',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade900,
                                  fontSize: fontsize / 140,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: fontsize / 100.0,
                        bottom: fontsize / 100,
                        right: fontsize / 200),
                    child: VerticalDivider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.all(fontsize / 300),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(fontsize / 300),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(0xFFD3FFE7).withOpacity(0.5),
                                    ),
                                    child: Lottie.asset(
                                      'assets/Request.json',
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
                                          'Pending Requests',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          data.pendingCount
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
                                                  isIncreasedPending
                                                      ? Feather.trending_up
                                                      : Feather.trending_down,
                                                  color: isIncreasedPending
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: fontsize / 150,
                                                ),
                                                Gap(fontsize / 400),
                                                Text(
                                                  '${double.parse(data.pendingPercentage.replaceAll('%', '')).toInt()}%',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: isIncreasedPending
                                                        ? Colors.green
                                                        : Colors.redAccent,
                                                    fontSize: fontsize / 120,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                                Gap(fontsize / 400),
                                                Expanded(
                                                  child: Text(
                                                    'Pending Requests ',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors
                                                          .grey.shade900,
                                                      fontSize:
                                                          fontsize / 160,
                                                      letterSpacing: 0,
                                                      wordSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]),
                                ),
                              ]))),
                              Padding(
                              padding: EdgeInsets.only(
                                  top: fontsize / 100.0,
                                  bottom: fontsize / 100,
                                  right: fontsize / 200),
                              child: VerticalDivider(
                                color: Colors.grey.withOpacity(0.5),
                                thickness: 2,
                              ),
                            ),
        
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(fontsize / 300),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            fontsize / 300),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFD3FFE7)
                                                .withOpacity(0.5),
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
                                                'Approved Requests',
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.normal,
                                                  color: Colors.grey,
                                                  fontSize:
                                                      fontsize / 120,
                                                ),
                                              ),
                                              Text(
                                               data.approvedCount
                                                    .toString()
                                                    .padLeft(3, '0'),
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: Colors
                                                      .green.shade900,
                                                  fontSize: fontsize / 80,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          left: fontsize /
                                                              300.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isIncreasedApproved
                                                            ? Feather
                                                                .trending_up
                                                            : Feather
                                                                .trending_down,
                                                        color: isIncreasedApproved
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: fontsize /
                                                            150,
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Text(
                                                       '${double.parse(data.approvedPercentage.replaceAll('%', '')).toInt()}%',
                                    
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                          color: isIncreasedApproved
                                                              ? Colors
                                                                  .green
                                                              : Colors
                                                                  .redAccent,
                                                          fontSize:
                                                              fontsize /
                                                                  120,
                                                          letterSpacing:
                                                              0,
                                                        ),
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Expanded(
                                                        child: Text(
                                                          'Approved Requests ',
                                                          style:
                                                              GoogleFonts
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
                                                            letterSpacing:
                                                                0,
                                                            wordSpacing:
                                                                0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            ]),
                                      ),
                                                                ]
                                    ))),
                                    Padding(
                              padding: EdgeInsets.only(
                                  top: fontsize / 100.0,
                                  bottom: fontsize / 100,
                                  right: fontsize / 200),
                              child: VerticalDivider(
                                color: Colors.grey.withOpacity(0.5),
                                thickness: 2,
                              ),
                            ),
        
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.all(fontsize / 300),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            fontsize / 300),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFD3FFE7)
                                                .withOpacity(0.5),
                                          ),
                                          child: Lottie.asset(
                                            'assets/error.json',
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
                                                'Rejected Requests',
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.normal,
                                                  color: Colors.grey,
                                                  fontSize:
                                                      fontsize / 120,
                                                ),
                                              ),
                                              Text(
                                               data.rejectedCount
                                                    .toString()
                                                    .padLeft(3, '0'),
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color: Colors
                                                      .green.shade900,
                                                  fontSize: fontsize / 80,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(
                                                          left: fontsize /
                                                              300.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        isIncreasedRejected
                                                            ? Feather
                                                                .trending_up
                                                            : Feather
                                                                .trending_down,
                                                        color: isIncreasedRejected
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: fontsize /
                                                            150,
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Text(
                                                       '${double.parse(data.rejectedPercentage.replaceAll('%', '')).toInt()}%',
                                    
                                                        style: GoogleFonts
                                                            .poppins(
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                          color: isIncreasedRejected
                                                              ? Colors
                                                                  .green
                                                              : Colors
                                                                  .redAccent,
                                                          fontSize:
                                                              fontsize /
                                                                  120,
                                                          letterSpacing:
                                                              0,
                                                        ),
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Expanded(
                                                        child: Text(
                                                          'Rejected Requests ',
                                                          style:
                                                              GoogleFonts
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
                                                            letterSpacing:
                                                                0,
                                                            wordSpacing:
                                                                0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                            ]),
                                      ),
                                                                ]
                                    ))),
                ],
              );
           
            }));
  }
}

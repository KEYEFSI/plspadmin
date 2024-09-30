import 'package:plsp/RegistrarsAdmin/Claimed/Model.dart';
import 'package:plsp/RegistrarsAdmin/College/CollegeCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required Future<AccomplishedDocumentsCount> studentCount,
  }) : _studentCount = studentCount;

  final Future<AccomplishedDocumentsCount> _studentCount;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    return FutureBuilder<AccomplishedDocumentsCount?>(
        future: _studentCount,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:  Lottie.asset(
                                                'assets/Loading.json',
                                                  fit: BoxFit.contain,
                                                ),);
          } else if (snapshot.hasError) {
            return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
            }
            final AccomplishedDocumentsCount counts = snapshot.data!;

            final bool isIncreased =
                counts.dailyUnclaimedCount < counts.dailyClaimedCount;
            return Expanded(
              child: Row(children: [
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(fontsize / 100.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14)),
                            child: Row(children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(fontsize / 300.0),
                                  child: Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.all(fontsize / 300),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFFD3FFE7)
                                                    .withOpacity(0.5),
                                              ),
                                              child: Lottie.asset(
                                                'assets/Student.json',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Claimed',
                                                style: GoogleFonts.poppins(
                                                  fontWeight:
                                                      FontWeight.normal,
                                                  color: Colors.grey,
                                                  fontSize: fontsize / 120,
                                                ),
                                              ),
                                              Text(
                                                counts.totalCount
                                                    .toString()
                                                    .padLeft(3, '0'),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      Colors.green.shade900,
                                                  fontSize: fontsize / 80,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: fontsize / 300),
                                                child: Text(
                                                  'Overall Total Claimed',
                                                  style:
                                                      GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors
                                                        .grey.shade900,
                                                    fontSize:
                                                        fontsize / 160,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                  ),
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
                                      child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                      'Total Unclaimed',
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
                                                      counts.unclaimedCount
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
                                                              isIncreased
                                                                  ? Feather
                                                                      .trending_up
                                                                  : Feather
                                                                      .trending_down,
                                                              color: isIncreased
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              size: fontsize /
                                                                  150,
                                                            ),
                                                            Gap(fontsize / 400),
                                                            Text(
                                                              '${counts.dailyUnclaimedPercent.round()}% ',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: isIncreased
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
                                                                'Unclaimed Documents ',
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
                                          )))),

                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: fontsize / 100,
                                                  bottom: fontsize / 100,
                                                  right: fontsize / 200),
                                              child: VerticalDivider(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                thickness: 2,
                                              ),
                                            ),
                                            Expanded(
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    fontsize /
                                                                        300.0),
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
                                                              child:
                                                                  Lottie.asset(
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
                                                                'Daily Claimed',
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
                                                                counts
                                                                    .claimedCount
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
                                                                          90,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: fontsize /
                                                                        300.0),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      isIncreased
                                                                          ? Feather
                                                                              .trending_up
                                                                          : Feather
                                                                              .trending_down,
                                                                      color: isIncreased
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red,
                                                                      size: fontsize /
                                                                          100,
                                                                    ),
                                                                    Gap(fontsize /
                                                                        200),
                                                                    Text(
                                                                      '${counts.dailyClaimedPercent}% ',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: isIncreased
                                                                            ? Colors.green
                                                                            : Colors.redAccent,
                                                                        fontSize:
                                                                            fontsize /
                                                                                140,
                                                                        letterSpacing:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                    Gap(fontsize /
                                                                        250),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'Weekly Processed Requests ',
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade900,
                                                                          fontSize:
                                                                              fontsize / 200,
                                                                          letterSpacing:
                                                                              0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                        ]))))
                                          ]))))
                         
              ]),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        });
  }
}

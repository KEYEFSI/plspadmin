import 'package:plsp/FinanceAdmin/Payees/ISCounterController.dart';
import 'package:plsp/FinanceAdmin/Payees/ISCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Counter extends StatefulWidget {
  const Counter({
    super.key,

  })  ;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
   late PayeesController _payeesController;
 @override
  void initState() {
    super.initState();
    _payeesController = PayeesController();
  }

  @override
  void dispose() {
    _payeesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<PayeesData>(
        stream: _payeesController.payeesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:Lottie.asset('assets/Loading.json'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            PayeesData data = snapshot.data!;

            return Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: fontsize / 80.0, horizontal: height / 42),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(fontsize / 200.0),
                                child: Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                        padding: EdgeInsets.all(fontsize / 200),
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
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              data.student.totalCount
                                                  .toStringAsFixed(0)
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
                                          ]))
                                    ])))),
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            "Today's Requests",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                              fontSize: fontsize / 120,
                                            ),
                                          ),
                                          Text(
                                            data.requests.dailyUnpaidCount
                                                .toStringAsFixed(0)
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
                                                    data.requests.isIncreased
                                                        ? Feather.trending_up
                                                        : Feather.trending_down,
                                                    color: data.requests
                                                            .isIncreased
                                                        ? Colors.green
                                                        : Colors.red,
                                                    size: fontsize / 150,
                                                  ),
                                                  Gap(fontsize / 400),
                                                  Text(
                                                    '${data.requests.percentageIncrease.round()}% ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: data.requests
                                                              .isIncreased
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: fontsize / 100,
                              bottom: fontsize / 100,
                              right: fontsize / 200),
                          child: VerticalDivider(
                            color: Colors.grey.withOpacity(0.5),
                            thickness: 2,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.all(fontsize / 500.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFD3FFE7)
                                                .withOpacity(0.5),
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
                                                'Total Accomodated',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                  fontSize: fontsize / 120,
                                                ),
                                              ),
                                              Text(
                                                data.transaction.dailyCount
                                                    .toStringAsFixed(0)
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
                                                        data.transaction
                                                                .isIncreased
                                                            ? Feather
                                                                .trending_up
                                                            : Feather
                                                                .trending_down,
                                                        color: data.transaction
                                                                .isIncreased
                                                            ? Colors.green
                                                            : Colors.red,
                                                        size: fontsize / 150,
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Text(
                                                        '${data.transaction.percentageIncrease.round()}% ',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: data
                                                                  .transaction
                                                                  .isIncreased
                                                              ? Colors.green
                                                              : Colors
                                                                  .redAccent,
                                                          fontSize:
                                                              fontsize / 120,
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                      Gap(fontsize / 400),
                                                      Expanded(
                                                        child: Text(
                                                          'Daily Accomodation ',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
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
                                      )
                                    ]))))
                      ]),
                    )));
          } else {
            return Center(child: Text('No data available'));
          }
        });
  }
}

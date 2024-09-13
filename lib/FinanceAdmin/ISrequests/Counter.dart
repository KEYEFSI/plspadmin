import 'package:plsp/FinanceAdmin/ISrequests/ISCounterController.dart';
import 'package:plsp/FinanceAdmin/ISrequests/ISCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Counter extends StatelessWidget {
  const Counter({
    super.key,
    required Future<ISStudentCount> studentCount,
    required Future<ISRequestsCount> requestsCount,
    required Future<ISStudentTransactionCount> transactionCount,
  })  : _studentCount = studentCount,
        _requestsCount = requestsCount,
        _transactionCount = transactionCount;

  final Future<ISStudentCount> _studentCount;
  final Future<ISRequestsCount> _requestsCount;
  final Future<ISStudentTransactionCount> _transactionCount;

  @override
  Widget build(BuildContext context) {
    final fontsize = 
        MediaQuery.of(context).size.width;
        final height =  MediaQuery.of(context).size.height;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: fontsize/80.0, horizontal: height/42),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(fontsize / 200.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(fontsize / 200),
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
                        FutureBuilder<ISStudentCount>(
                            future: _studentCount,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Lottie.asset('assets/Loading.json');
                              } else if (snapshot.hasError) {
                                return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                              } else if (snapshot.hasData) {
                                return Expanded(
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
                                        snapshot.data!.count
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
                                        child: Expanded(
                                          child: Text(
                                            'Number of Students',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade900,
                                              fontSize: fontsize / 160,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(child: Text('No data available'));
                              }
                            }),
                      ],
                    ),
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
                              'assets/Request.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        FutureBuilder<ISRequestsCount>(
                            future: _requestsCount,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Lottie.asset('assets/Loading.json'));
                              } else if (snapshot.hasError) {
                                return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                              } else if (snapshot.hasData) {
                               final data = snapshot.data;
                                final isIncreased = data!.isIncreased;
                                
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        data.totalCount
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
                                              isIncreased
                                                  ? Feather.trending_up
                                                  : Feather.trending_down,
                                              color: isIncreased
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: fontsize / 150,
                                            ),
                                             Gap(fontsize/400),
                                            Text(
                                             '${data.percentageIncrease.round()}% ',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: isIncreased? Colors.green: Colors.redAccent,
                                                fontSize: fontsize /120,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            Gap(fontsize/400),
                                            Expanded(
                                              child: Text(
                                                'Daily Requests ',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade900,
                                                  fontSize: fontsize / 160,
                                                  letterSpacing: 0,
                                                  wordSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                    ],
                                    )
                                    )]
                                  ),
                                );
                              } else {
                                return Center(child: Text('No data available'));
                              }
                            }),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(fontsize / 500.0),
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
                        FutureBuilder<ISStudentTransactionCount>(
                            future: _transactionCount,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Lottie.asset('assets/Loading.json'));
                              } else if (snapshot.hasError) {
                                return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                              } else if (snapshot.hasData) {
                                final data = snapshot.data;
                                final isIncreased = data!.isIncreased;
                                
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        data.totalCount
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
                                              isIncreased
                                                  ? Feather.trending_up
                                                  : Feather.trending_down,
                                              color: isIncreased
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: fontsize / 150,
                                            ),
                                             Gap(fontsize/400),
                                            Text(
                                             '${data.percentageIncrease.round()}% ',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: isIncreased? Colors.green: Colors.redAccent,
                                                fontSize: fontsize / 120,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                            Gap(fontsize/400),
                                            Expanded(
                                              child: Text(
                                                'Daily Accomodation ',
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade900,
                                                  fontSize: fontsize / 160,
                                                  letterSpacing: 0,
                                                  wordSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                    ],
                                    )
                                    )]
                                  ),
                                );
                              } else {
                                return Center(child: Text('No data available'));
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

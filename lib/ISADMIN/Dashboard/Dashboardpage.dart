

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'Calendar.dart';
import 'Counter.dart';
import 'daily.dart';

class DashboardPage extends StatefulWidget {
  final String username;
  final String fullname;

  const DashboardPage(
      {super.key, required this.username, required this.fullname});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Scaffold(
        appBar: AppBar(
          title: Row(
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
        body: Padding(
                  padding: EdgeInsets.all(fontsize / 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                              image: AssetImage('assets/dashboardbg.png'),
                              fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                              Counter(fontsize: fontsize),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: fontsize / 100,
                                      left: fontsize / 100,
                                      right: fontsize / 100),
                                  child: Row(
                                    children: [
                                      Daily(fontsize: fontsize),
                                      Calendar(fontsize: fontsize),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ));
  }
}

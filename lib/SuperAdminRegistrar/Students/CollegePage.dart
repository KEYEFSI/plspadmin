import 'package:plsp/SuperAdminRegistrar/Students/ApprovedAccts/ApprovedAcct.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingAccounts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CollegePage extends StatefulWidget {
  final String username;
  final String fullname;

  const CollegePage(
      {super.key, required this.username, required this.fullname});

  @override
  State<CollegePage> createState() => _CollegePageState();
}

class _CollegePageState extends State<CollegePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                      child: Lottie.asset('assets/hi.json', fit: BoxFit.cover)),
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
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(fontsize / 100.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: DefaultTabController(
                        length: 2,
                        child: Stack(
                          children: [
                            // Replace Expanded with Positioned.fill or remove Expanded
                            Positioned.fill(
                              child: Container(
                                child: TabBarView(
                                  children: [
                                    PendingAccounts(),
                                    ApprovedAccounts(),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(1, 1),
                              child: Padding(
                                padding: EdgeInsets.all(fontsize / 100.0),
                                child: Container(
                                  width: fontsize / 3,
                                  height: height / 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.green.shade100,
                                    border: Border.all(
                                      color: Colors.green.shade900,
                                      width: 2,
                                    ),
                                  ),
                                  child: TabBar(
                                    indicator: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.green,
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelColor: Colors.white,
                                    labelStyle: GoogleFonts.poppins(
                                      fontSize: fontsize / 70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    unselectedLabelColor: Colors.black,
                                    unselectedLabelStyle: GoogleFonts.poppins(
                                      fontSize: fontsize / 80,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    tabs: [
                                      Tab(text: 'Pending'),
                                      Tab(text: 'Approved'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
    );
  }}
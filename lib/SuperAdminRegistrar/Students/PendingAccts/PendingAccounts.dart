import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingAlumni.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingGraduates.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingOrdinary.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingPayees.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/PendingTCP.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingAccounts extends StatefulWidget {
  const PendingAccounts({
    super.key,
  });

  @override
  State<PendingAccounts> createState() => _PendingAccountsState();
}

class _PendingAccountsState extends State<PendingAccounts> {

  
  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: [
        Gap(height / 101),
        Text(
          'Pending Student Accounts',
          style: GoogleFonts.poppins(
            fontSize: fontsize / 60,
            color: Colors.green.shade900,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        Divider(
          thickness: 1,
          height: 1,
          color: Colors.green.shade900,
        ),
        Gap(height / 101),
        Expanded(
          child: DefaultTabController(
            length: 5, // Match the number of tabs
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(fontsize / 100.0),
                  child: Container(
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
                        color: Colors.green.shade900,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: Colors.white,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelColor: Colors.black,
                      unselectedLabelStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 90,
                        fontWeight: FontWeight.bold,
                      ),
                      tabs: const [
                        Tab(text: 'College'),
                        Tab(text: 'Payees'),
                        Tab(text: 'Graduates School'),
                        Tab(text: 'TCP Students'),
                        Tab(text: 'Alumni'),
                      ],
                    ),
                  ),
                ),
                
                const Expanded(
                  child: TabBarView(
                    children: [
                      CollegeOrdinary(),
                      CollegePayees(),
                      PendingGraduates(),
                      PendingTCP(),
                      PendingAlumni(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}




import 'package:plsp/RegistrarsAdmin/PendingDocuments/Controller.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Counter.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/PendingList.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Program extends StatefulWidget {
  final String username;
  final String fullname;

  const Program({super.key, required this.username, required this.fullname});

  @override
  State<Program> createState() => _ProgramTab();
}
  
class _ProgramTab extends State<Program> with TickerProviderStateMixin {
  final ProgramWindowController controller = ProgramWindowController();

  @override
  void initState() {
    super.initState();
    controller.startFetching(widget.username);
  }

  @override
  void dispose() {
    controller.stopFetching();
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
              child: Padding(
                padding: EdgeInsets.all(fontsize / 100.0),
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                          right: fontsize / 120.0,
                          bottom: fontsize / 120),
                      child: Counter(fontsize: fontsize),
                    )),
                    Expanded(
                      flex: 4,
                      child: PendingList(
                        fontsize: fontsize,
                        username: widget.username,
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

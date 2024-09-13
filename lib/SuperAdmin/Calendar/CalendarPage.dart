import 'package:plsp/SuperAdmin/Calendar/EventsList.dart';
import 'package:plsp/SuperAdmin/Calendar/InsertHoliday.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarController.dart';
import 'package:plsp/SuperAdmin/Calendar/HolidayCalendar.dart';

class CalendarPage extends StatefulWidget {

   final String username;
  final String fullname;

   const CalendarPage(
      {super.key, required this.username, required this.fullname});

      
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {





  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final containerHeight = height / 1.2;
    final fontsize = (MediaQuery.of(context).size.width);



    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HolidayDateController()..fetchHolidayDates(),
        ),
        ChangeNotifierProvider(
          create: (_) => HolidayDateDeleteController(),
        ),
      ],
      child: Scaffold(
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
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(fontsize/80, 0, fontsize/80, height/42),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/dashboardbg.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(24),
                            topStart: Radius.circular(24))),
                    child: Expanded(
                      child: Center(
                        child: Text(
                          'Event Calendar',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w900,
                              fontSize: fontsize/60,
                              color: Colors.green.shade900),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                 EdgeInsets.only(left: fontsize/80, bottom: height/42),
                            child: Column(
                              children: [
                                Expanded(child: AddHolidayState()),
                                Expanded(child: ShowHolidates()),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: fontsize/80),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:  EdgeInsets.only(
                                bottom: height/42.0, right: fontsize/80, top: height/42),
                            child: Calendar(containerHeight: containerHeight),
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
      ),
    );
  }
}

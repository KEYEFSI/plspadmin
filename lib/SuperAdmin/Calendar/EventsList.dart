import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarController.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

class ShowHolidates extends StatelessWidget {
  const ShowHolidates({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, height / 42, 0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      'assets/Calendar.json',
                      width: fontsize / 24,
                      height: height / 24,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Expanded(
                            child: Text(
                              'List of Holiday Dates',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                color: Color(0xFF006400),
                                fontSize: fontsize / 106,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(14, 0, 8, 8),
                          child: Text(
                            'No Transactions During This Time',
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: fontsize / 160,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:  EdgeInsetsDirectional.fromSTEB(fontsize/160, 0, fontsize/160, 0),
                  child: Divider(
                    height: 2,
                    thickness: 1,
                    color: Colors.greenAccent.shade700,
                  ),
                ),
                Expanded(
                  child: Consumer2<HolidayDateController,
                      HolidayDateDeleteController>(
                    builder: (context, holidayDateController,
                        holidayDateDeleteController, child) {
                      final holidayDates = List<HolidayDate>.from(
                          holidayDateController.holidayDates);
                      holidayDates.sort((a, b) => b.date.compareTo(a.date));

                      if (holidayDates.isEmpty) {
                        return Center(
                          child: Lottie.asset(
                            'assets/Empty.json',
                            fit: BoxFit.cover,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsetsDirectional.fromSTEB(fontsize/80, 12, fontsize/80, 0),
                        itemCount: holidayDates.length,
                        itemBuilder: (context, index) {
                          final holidayDate = holidayDates[index];
                          final isFutureDate =
                              holidayDate.date.isAfter(DateTime.now());

                          return Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio: 0.30,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, height/85, 0, height/85),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(244, 67, 54, 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      try {
                                        await holidayDateDeleteController
                                            .deleteHolidayDate(
                                          holidayDate.eventName,
                                          holidayDate.date.toLocal(),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Holiday date deleted successfully')),
                                        );
                                        holidayDateController.refreshCalendar();
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to delete holiday date')),
                                        );
                                      }
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Lottie.asset(
                                            'assets/Delete.json',
                                            fit: BoxFit.contain,
                                            width: fontsize / 125,
                                            height: fontsize / 125,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: fontsize / 210,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isFutureDate
                                    ? Colors.greenAccent.shade700
                                    : Colors.greenAccent.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEE, MMM dd, yyyy')
                                        .format(holidayDate.date.toLocal()),
                                    style: GoogleFonts.poppins(
                                      color: isFutureDate
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: fontsize / 160,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    holidayDate.eventName,
                                    style: GoogleFonts.poppins(
                                      color: isFutureDate
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: fontsize / 160,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarController.dart';

class AddHolidayState extends StatefulWidget {
  @override
  _AddHolidayState createState() => _AddHolidayState();
}

class _AddHolidayState extends State<AddHolidayState> {
  DateTime? _selectedDate;
  final _eventNameController = TextEditingController();
  final HolidayInsert _holidayInsert = HolidayInsert('$kUrl');

  @override
  Widget build(BuildContext context) {
    final holidayDateController = Provider.of<HolidayDateController>(context);

    final height = MediaQuery.of(context).size.height;

    final fontsize = MediaQuery.of(context).size.width;

    if (!holidayDateController.isLoading &&
        holidayDateController.holidayDates.isEmpty) {
      holidayDateController.fetchHolidayDates();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Lottie.asset(
                  'assets/Calendar.json',
                  width: fontsize / 30,
                  height: height/24,
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'Set Holiday Date',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          color: Color(0xFF006400),
                          fontSize: fontsize / 106,
                          fontWeight: FontWeight.w900,
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
                          fontSize: fontsize / 192,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
                height: 2, thickness: 1, color: Colors.greenAccent.shade700),
            Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding:  EdgeInsetsDirectional.fromSTEB(
                          fontsize/200, height/85, 0, 0),
                      child: Text(
                        'Select Date:',
                        style: GoogleFonts.poppins(
                          color: Colors.green.shade900,
                          fontSize: fontsize / 120,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12, 0, 24, 0),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('MMM d, yyyy')
                                .format(_selectedDate!)
                            : 'MMM, dd ,yyyy',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 120,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(left: fontsize / 80.0),
                          child: IconButton(
                            icon: Icon(Foundation.calendar,
                                size: fontsize / 70,
                                color: Color(0xFF006400)),
                            onPressed: () async {
                              print("Calendar button pressed");
                              final datePicked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365 * 10)),
                                lastDate: DateTime.now()
                                    .add(Duration(days: 365 * 10)),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      primaryColor: Color(0xFF006400),
                                      buttonTheme: ButtonThemeData(
                                          textTheme:
                                              ButtonTextTheme.primary),
                                      dialogBackgroundColor: Colors.white,
                                      datePickerTheme: DatePickerThemeData(
                                        dayStyle: TextStyle(
                                            color: Colors.green.shade100),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                selectableDayPredicate: (date) {
                                  if (date.weekday == DateTime.saturday ||
                                      date.weekday == DateTime.sunday ||
                                      holidayDateController.holidayDates
                                          .any((holiday) =>
                                              date.isAtSameMomentAs(
                                                  holiday.date))) {
                                    return false;
                                  }
                                  return true;
                                },
                              );
                                    
                              if (datePicked != null) {
                                setState(() {
                                  _selectedDate = datePicked;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: fontsize / 185),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: Text(
                    'Event Name:',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF006400),
                      fontSize: fontsize / 120,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Gap(height/101),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      fontsize / 80, 0, fontsize/80, 0),
                  child: TextFormField(
                    cursorHeight: height/80,
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 120,
                        color: Theme.of(context).hoverColor,
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).hintColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).cardColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColorLight,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: false,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Entypo.pin,
                          color: Theme.of(context).primaryColor),
                    ),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: fontsize / 120,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        fontsize / 80, height / 42, fontsize/80, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedDate != null &&
                            _eventNameController.text.isNotEmpty) {
                          try {
                            await _holidayInsert.insertHolidayDate(
                              _eventNameController.text,
                              _selectedDate!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Holiday date saved successfully.'),
                              ),
                            );
                            holidayDateController.refreshCalendar();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Failed to save holiday date.'),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Please select a date and enter an event name.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006400), // Dark green
                        padding: EdgeInsets.symmetric(
                            vertical: fontsize / 80,
                            horizontal: height / 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontsize / 120,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:plsp/SuperAdmin/Calendar/CalendarModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:plsp/SuperAdmin/Calendar/CalendarController.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.containerHeight,
  }) : super(key: key);

  final double containerHeight;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HolidayDateController>(context, listen: false)
          .fetchHolidayDates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final now = DateTime.now();
    final holidayController = Provider.of<HolidayDateController>(context);
    final height = MediaQuery.of(context).size.height;
    final fontsize = (MediaQuery.of(context).size.width);
    return Expanded(
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
            fontsize / 80, 0, fontsize / 80, height / 42),
        decoration: BoxDecoration(
          color: Color(0xFFfaf9f6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Calendar',
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                color: Theme.of(context).primaryColor,
                fontSize: fontsize / 60,
                fontWeight: FontWeight.w900,
              ),
            ),
            Divider(
              height: 2,
              thickness: 1,
              color: Color(0xFFE5E7EB),
            ),
            Expanded(
              flex: 9,
              child: holidayController.isLoading
                  ? Center(
                      child: Lottie.asset('assets/Loading.json',
                          fit: BoxFit.cover))
                  : Expanded(
                      child: TableCalendar(
                        daysOfWeekStyle: DaysOfWeekStyle(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          weekendStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: fontsize / 120),
                          weekdayStyle: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                              fontSize: fontsize / 120),
                        ),
                        daysOfWeekHeight: height / 35,
                        locale: 'en_US',
                        rowHeight: height / 9,
                        firstDay: DateTime.utc(1000, 10, 16).toLocal(),
                        lastDay: DateTime.utc(5000, 3, 14).toLocal(),
                        focusedDay: now,
                        calendarFormat: CalendarFormat.month,
                        eventLoader: (day) => _getEventsForDay(
                            day, holidayController.holidayDates),
                        enabledDayPredicate: (day) =>
                            day.weekday != DateTime.saturday &&
                            day.weekday != DateTime.sunday,
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleTextStyle: GoogleFonts.poppins(
                            fontSize: fontsize / 80,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: primaryColor),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: primaryColor),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          markerDecoration:
                              BoxDecoration(color: Colors.transparent),
                          disabledTextStyle: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          outsideDaysVisible: false,
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          print('Selected day: $selectedDay');
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final isPast = day.isBefore(DateTime.now());
                            final events = _getEventsForDay(
                                day, holidayController.holidayDates);
                            final backgroundColor = events.isNotEmpty
                                ? (isPast
                                    ? Colors.redAccent
                                    : Colors.redAccent.shade700)
                                : Colors.white;
                            return _buildDayCell(
                              day,
                              events.isNotEmpty
                                  ? Colors.white
                                  : (isPast
                                      ? Colors.green.shade300
                                      : Colors.green.shade900),
                              events.isNotEmpty ? events.join(', ') : "",
                              isPast ? FontWeight.w500 : FontWeight.w700,
                              backgroundColor: backgroundColor,
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(
                                day, holidayController.holidayDates);
                            final hasEvents = events.isNotEmpty;
                            return _buildDayCell(
                              day,
                              Colors.white,
                              hasEvents ? events.join(', ') : "Today",
                              FontWeight.w600,
                              backgroundColor: hasEvents
                                  ? null 
                                  : Colors.green.shade900,
                              showIcon:
                                 hasEvents? true : false, 
                              isGradient: hasEvents,
                            );
                          },
                          disabledBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(
                                day, holidayController.holidayDates);
                            final backgroundColor = events.isNotEmpty
                                ? Colors.red.shade100
                                : Colors.white;
                            return _buildDayCell(
                              day,
                              Colors.red.shade100,
                              events.isNotEmpty ? events.join(', ') : "",
                              FontWeight.bold,
                              backgroundColor: backgroundColor,
                            );
                          },
                          outsideBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(
                                day, holidayController.holidayDates);
                            return _buildDayCell(
                              day,
                              Colors.grey,
                              events.isNotEmpty ? events.join(', ') : "",
                              FontWeight.normal,
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day, List<HolidayDate> holidays) {
    final localDay = day.toLocal();
    return holidays
        .where((holiday) =>
            holiday.date.toLocal().day == localDay.day &&
            holiday.date.toLocal().month == localDay.month &&
            holiday.date.toLocal().year == localDay.year)
        .map((holiday) => holiday.eventName)
        .toList();
  }

  Widget _buildDayCell(
      DateTime day, Color textColor, String event, FontWeight fontWeight,
      {Color? backgroundColor, bool showIcon = true, bool isGradient = false}) {
    final isPast = day.isBefore(DateTime.now());

    final gradient = isGradient
        ? LinearGradient(
            colors: [Colors.redAccent.shade100, Colors.greenAccent.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

    List<Color> rainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

Color getRandomRainbowColor() {
  Random random = Random();
  return rainbowColors[random.nextInt(rainbowColors.length)];
}

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: fontsize / 960.0, vertical: height / 500),
              child: Container(
                margin: EdgeInsets.all(
                    4.0), // Margin around each cell to ensure spacing
                width: double.infinity, // Ensure width to make cells square
                height: double.infinity, // Ensure height to make cells square
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.teal.shade50,
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${day.day}',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize:
                                fontsize / 80, // Adjust font size for the date
                            fontWeight: fontWeight,
                          ),
                        ),
                      ),
                    ),
                    if (event.isNotEmpty)
                      Positioned(
                        top: height/160,
                        left: fontsize/160,
                        child: Text(
                          event,
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: fontsize /
                                80, // Adjust font size for event text
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (event.isNotEmpty && showIcon)
              Positioned(
                top: -0,
                right: fontsize/320,
                child: Icon(
                  Entypo.pin,
                  color: getRandomRainbowColor(),
                  size: fontsize / 60,
                  shadows: [
                    Shadow(
                      color: Colors.black
                          .withOpacity(0.8), 
                      blurRadius: 4, 
                      offset: Offset(2, 2), 
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

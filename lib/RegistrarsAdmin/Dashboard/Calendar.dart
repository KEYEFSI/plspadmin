import 'dart:math';
import 'package:plsp/SuperAdmin/Dashboard/Model.dart';
import 'package:plsp/SuperAdmin/Dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:math';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.fontsize,
  });

  final double fontsize;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late HolidayDatesController _holidayDatesController;
  Map<DateTime, List<String>> _events = {};
  Map<DateTime, RequestData> _requestCountsByDateMap = {};
  late List<String> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _holidayDatesController = HolidayDatesController();
    _selectedEvents = [];

    _holidayDatesController.combinedDataStream.listen((combinedData) {
      setState(() {
        _events = _formatEvents(combinedData.holidayDates);
        _requestCountsByDateMap = _formatRequestCounts(combinedData);
      });
    });
  }

  Map<DateTime, List<String>> _formatEvents(List<HolidayDate> holidayDates) {
    final Map<DateTime, List<String>> data = {};
    for (var event in holidayDates) {
      final date = DateTime(event.date.toLocal().year,
          event.date.toLocal().month, event.date.toLocal().day);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date]!.add(event.eventName);
    }
    return data;
  }

  Map<DateTime, RequestData> _formatRequestCounts(CombinedData combinedData) {
    final Map<DateTime, RequestData> aggregatedData = {};

    void addToAggregatedData(List<RequestData> requestList) {
      for (var request in requestList) {
        final dateKey = DateTime(request.date.toLocal().year,
            request.date.toLocal().month, request.date.toLocal().day);
        print('Processing date: $dateKey'); // Debug print

        if (aggregatedData.containsKey(dateKey)) {
          final existing = aggregatedData[dateKey]!;
          aggregatedData[dateKey] = RequestData(
            date: request.date,
            paidRequests: existing.paidRequests + request.paidRequests,
            unpaidRequests: existing.unpaidRequests + request.unpaidRequests,
            claimedDocuments:
                existing.claimedDocuments + request.claimedDocuments,
            unclaimedDocuments:
                existing.unclaimedDocuments + request.unclaimedDocuments,
          );
        } else {
          aggregatedData[dateKey] = request;
        }
      }
    }

    // Check if requestsByDate contains data
    print('Requests by date: ${combinedData.requestsByDate}'); // Debug print

    // Process requests by date
    addToAggregatedData(combinedData.requestsByDate);

    // Print aggregated results
    print('Aggregated data: $aggregatedData'); // Debug print

    return aggregatedData;
  }

  // Method to get events for a specific day
  List<String> _getEventsForDay(DateTime day) {
    final localDay = DateTime(day.year, day.month, day.day);
    return _events[localDay] ?? [];
  }

  // Method to get request counts for a specific day
  RequestData? _getRequestCountsForDay(DateTime day) {
    final localDay = DateTime(day.year, day.month, day.day);
    return _requestCountsByDateMap[localDay];
  }

  @override
  void dispose() {
    _holidayDatesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    final now = DateTime.now();

    return Expanded(
      flex: 7,
      child: Padding(
        padding: EdgeInsets.only(left: fontsize / 100.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Center(
                  child: Text(
                'Calendar',
                style: GoogleFonts.poppins(
                  color: Colors.green.shade900,
                  fontSize: fontsize / 80,
                  fontWeight: FontWeight.bold,
                ),
              )),
            

              
              Expanded(
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
                  daysOfWeekHeight: height / 40,
                  locale: 'en_US',
                  rowHeight: height / 9.5,
                  firstDay: DateTime.utc(1000, 10, 16).toLocal(),
                  lastDay: DateTime.utc(5000, 3, 14).toLocal(),
                  focusedDay: now,
                  calendarFormat: CalendarFormat.month,
                  eventLoader: _getEventsForDay,
                  enabledDayPredicate: (day) =>
                      day.weekday != DateTime.saturday &&
                      day.weekday != DateTime.sunday,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade900,
                    ),
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Colors.green.shade900),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Colors.green.shade900),
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
                    markerDecoration: BoxDecoration(color: Colors.transparent),
                    disabledTextStyle: GoogleFonts.poppins(
                      fontSize: fontsize / 120,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedEvents = _getEventsForDay(selectedDay);
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final isPast = day.isBefore(DateTime.now());
                      final events = _getEventsForDay(day);
                      final backgroundColor = events.isNotEmpty
                          ? (isPast
                              ? Colors.redAccent
                              : Colors.redAccent.shade700)
                          : Colors.white;
                      final requestCounts = _getRequestCountsForDay(day);

                      return _buildDayCell(
                        day,
                        events.isNotEmpty
                            ? Colors.white
                            : (isPast
                                ? Colors.green.shade300
                                : Colors.green.shade900),
                        events.isNotEmpty ? events.join(', ') : "",
                        isPast ? FontWeight.w500 : FontWeight.w700,
                        requestCounts,
                        backgroundColor: backgroundColor,
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final events = _getEventsForDay(day);
                      final hasEvents = events.isNotEmpty;
                      final requestCounts = _getRequestCountsForDay(day);
                      return _buildDayCell(
                        day,
                        Colors.white,
                        hasEvents ? events.join(', ') : "Today",
                        FontWeight.w600,
                        requestCounts,
                        backgroundColor:
                            hasEvents ? null : Colors.green.shade900,
                        showIcon: hasEvents ? true : false,
                        isGradient: hasEvents,
                      );
                    },
                    disabledBuilder: (context, day, focusedDay) {
                      final events = _getEventsForDay(day);
                      final backgroundColor = events.isNotEmpty
                          ? Colors.red.shade100
                          : Colors.white;

                      final requestCounts = _getRequestCountsForDay(day);
                      return _buildDayCell(
                        day,
                        Colors.red.shade100,
                        events.isNotEmpty ? events.join(', ') : "",
                        FontWeight.bold,
                        requestCounts,
                        backgroundColor: backgroundColor,
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      final events = _events[day] ?? [];
                      final requestCounts = _getRequestCountsForDay(day);

                      return _buildDayCell(
                        day,
                        Colors.grey,
                        events.isNotEmpty ? events.join(', ') : "",
                        FontWeight.normal,
                        requestCounts,
                        backgroundColor: Colors.white,
                      );
                    },
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day,
    Color textColor,
    String event,
    FontWeight fontWeight,
    RequestData? requestCounts, // This is now a nullable parameter
    {
    Color? backgroundColor,
    bool showIcon = true,
    bool isGradient = false,
  }) {
    final fontsize = MediaQuery.of(context).size.width;

    // Define the gradient
    final gradient = isGradient
        ? LinearGradient(
            colors: [Colors.redAccent.shade100, Colors.greenAccent.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : null;

    // List of rainbow colors
    List<Color> rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    // Function to get a random rainbow color
    Color getRandomRainbowColor() {
      Random random = Random();
      return rainbowColors[random.nextInt(rainbowColors.length)];
    }

    final correspondingData = requestCounts;
    final maxRequests = 150;

    final unpaidPercentage =
        (correspondingData?.unpaidRequests ?? 0 / maxRequests);
    final paidPercentage = (correspondingData?.paidRequests ?? 0 / maxRequests);
    final unclaimed =
        (correspondingData?.unclaimedDocuments ?? 0 / maxRequests);
    final claimed = (correspondingData?.unclaimedDocuments ?? 0 / maxRequests);

    final percentage = paidPercentage + unpaidPercentage + unclaimed + claimed;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: double.infinity,
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
            // Day Number Text
            Positioned(
              bottom: 5,
              left: 5,
              child: Text(
                '${day.day}',
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: fontsize / 100,
                  fontWeight: fontWeight,
                ),
              ),
            ),

            // Display Event or Corresponding Data if Event is Empty
            if (event.isNotEmpty)
              Positioned(
                bottom: 30,
                left: 5,
                child: Container(
                  width: fontsize / 4,
                  child: Text(
                    event,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            else if (correspondingData != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          height: fontsize / 20,
                          width: double.infinity,
                          child: SfRadialGauge(
                            axes: [
                              RadialAxis(
                                maximum: 100,
                                labelOffset: 0,
                                pointers: [
                                  RangePointer(
                                    value: unpaidPercentage.toDouble() +
                                        paidPercentage.toDouble() +
                                        unclaimed.toDouble() +
                                        claimed.toDouble(),
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Color(0XFFFD4C3D),
                                    width: fontsize / 96,
                                  )
                                ],
                                axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 96,
                                    cornerStyle: CornerStyle.bothFlat),
                                startAngle: 180,
                                endAngle:
                                    360, // Adjust angles to span the whole gauge
                                showLabels: false,
                                showTicks: false,
                                annotations: [
                                  GaugeAnnotation(
                                    widget: Center(
                                      child: Text(
                                        '${percentage.toStringAsFixed(0)}%',
                                        style: GoogleFonts.poppins(
                                          color: Colors
                                              .green, // Adjust color as needed
                                          fontSize: fontsize / 200,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    positionFactor: 0.2,
                                  ),
                                ],
                              ),
                              RadialAxis(
                                pointers: [
                                  RangePointer(
                                    value: paidPercentage.toDouble() +
                                        unclaimed.toDouble() +
                                        claimed.toDouble(),
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Color(0XFFFE7946),
                                    width: fontsize / 96,
                                  )
                                ],
                                startAngle: 180,
                                endAngle: 360,
                                showLabels: false,
                                showTicks: false,
                                showAxisLine: false,
                              ),
                              RadialAxis(
                                pointers: [
                                  RangePointer(
                                    value: unclaimed.toDouble() +
                                        claimed.toDouble(),
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Color(0XFFA0B245),
                                    width: fontsize / 96,
                                  )
                                ],
                                startAngle: 180,
                                endAngle: 360,
                                showLabels: false,
                                showTicks: false,
                                showAxisLine: false,
                              ),
                              RadialAxis(
                                pointers: [
                                  RangePointer(
                                    value: claimed.toDouble(),
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Color(0XFF419131),
                                    width: fontsize / 96,
                                  )
                                ],
                                startAngle: 180,
                                endAngle: 360,
                                showLabels: false,
                                showTicks: false,
                                showAxisLine: false,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('Status',
                                style: GoogleFonts.poppins(
                                  color: Colors.green
                                      .shade900, // Adjust color as needed
                                  fontSize: fontsize / 120,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Display Icon (if events and showIcon is true)
            if (event.isNotEmpty && showIcon)
              Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Entypo.pin,
                  color: getRandomRainbowColor(),
                  size: fontsize / 60,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
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

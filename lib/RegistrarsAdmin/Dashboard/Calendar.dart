import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Model.dart';
import 'controller.dart';

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

  @override
  void initState() {
    super.initState();
    _holidayDatesController = HolidayDatesController();

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
      final date = DateTime.utc(event.date.year, event.date.month, event.date.day);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date]!.add(event.eventName);
    }
    return data;
  }

 Map<DateTime, RequestData> _formatRequestCounts(CombinedData combinedData) {
    final Map<DateTime, RequestData> aggregatedData = {};

    for (var request in combinedData.requestsByDate) {
      final dateKey = DateTime.utc(request.date.year, request.date.month, request.date.day);

      if (aggregatedData.containsKey(dateKey)) {
        final existing = aggregatedData[dateKey]!;
        aggregatedData[dateKey] = RequestData(
          date: dateKey,
          pending: existing.pending + request.pending,
          approved: existing.approved + request.approved,
          paid: existing.paid + request.paid,
          completed: existing.completed + request.completed,
          obtained: existing.obtained + request.obtained,
        );
      } else {
        aggregatedData[dateKey] = request;
      }
    }

    print("Formatted request counts: $aggregatedData"); // Debugging
    return aggregatedData;
  }
 List<String> _getEventsForDay(DateTime day) {
    final localDay = DateTime.utc(day.year, day.month, day.day);
    print("Checking events for day: $localDay -> ${_events[localDay]}"); // Debugging
    return _events[localDay] ?? [];
  }

  RequestData? _getRequestCountsForDay(DateTime day) {
    final localDay = DateTime.utc(day.year, day.month, day.day);
    print("Checking data for day: $localDay -> ${_requestCountsByDateMap[localDay]}"); // Debugging
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
                child: SingleChildScrollView(
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
                    rowHeight: height / 10.1,
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
                      leftChevronIcon: Icon(Icons.chevron_left,
                          color: Colors.green.shade900),
                      rightChevronIcon: Icon(Icons.chevron_right,
                          color: Colors.green.shade900),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      markerDecoration:
                          const BoxDecoration(color: Colors.transparent),
                      disabledTextStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 120,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {});
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
    RequestData? requestCounts, 
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
    const maxRequests = 150;

    final pending =
        (correspondingData?.pending ?? 0 / maxRequests);
    final approved =
        (correspondingData?.approved ?? 0 / maxRequests);
    final paidPercentage = (correspondingData?.paid ?? 0 / maxRequests);
    final completedPercentage = (correspondingData?.completed ?? 0 / maxRequests);
    final obtainedPercentage = (correspondingData?.obtained ?? 0 / maxRequests);

    final percentage = pending + approved + paidPercentage + completedPercentage + obtainedPercentage;

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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    event,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: fontsize / 120,
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
                  child: Stack(
                    children: [
                      SizedBox(
                        height: fontsize / 20,
                        width: double.infinity,
                        child: SfRadialGauge(
                          axes: [
                            RadialAxis(
                              maximum: 100,
                              labelOffset: 0,
                              pointers: [
                                RangePointer(
                                  value: pending.toDouble() +
                                      approved.toDouble() +
                                      paidPercentage.toDouble() +
                                      completedPercentage.toDouble() +
                                      obtainedPercentage.toDouble(),
                                     
                                  cornerStyle: CornerStyle.bothCurve,
                                    color: Color(0XFF205072),
                                  width: fontsize / 96,
                                )
                              ],
                              axisLineStyle: AxisLineStyle(
                                  thickness: fontsize / 96,
                                  cornerStyle: CornerStyle.bothFlat),
                              startAngle: 180,
                              endAngle:
                                  360, 
                              showLabels: false,
                              showTicks: false,
                              annotations: [
                                GaugeAnnotation(
                                  widget: Center(
                                    child: Text(
                                      '${percentage.toStringAsFixed(0)}%',
                                      style: GoogleFonts.poppins(
                                        color: Colors
                                            .green,
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
                                  value: pending.toDouble() +
                                      approved.toDouble() +
                                      paidPercentage.toDouble() +
                                      completedPercentage.toDouble(),
                                     
                                  cornerStyle: CornerStyle.bothCurve,
                              color: Color(0XFF329d9c),
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
                                  value: pending.toDouble() +
                                      approved.toDouble() +
                                      paidPercentage.toDouble(),
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: Color(0XFF56c5296),
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
                                   value: pending.toDouble() +
                                      approved.toDouble(),
                                  cornerStyle: CornerStyle.bothCurve,
                                   color: Color(0XFF7be495),
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
                                  value: pending.toDouble(),
                                  cornerStyle: CornerStyle.bothCurve,
                            color: Color(0XFFcff4d2),
                                  width: fontsize / 96,
                                )
                              ],
                              startAngle: 180,
                              endAngle: 360,
                              showLabels: false,
                              showTicks: false,
                              showAxisLine: false,
                            )
                          ],
                        ),
                      ),
                      Center(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Status',
                              style: GoogleFonts.poppins(
                                color: Colors
                                    .green.shade900, // Adjust color as needed
                                fontSize: fontsize / 120,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                    ],
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

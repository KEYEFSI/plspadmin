import 'dart:math';

import 'package:plsp/RegistrarsAdmin/Programs/AddProgram.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Listing extends StatefulWidget {
  final double fontsize;


  const Listing({
    super.key,
    required this.fontsize,
      required Stream<List<CourseWithStudentCount>> stream,
   
  }): _stream = stream;


   final Stream<List<CourseWithStudentCount>> _stream;



  @override
  State<Listing> createState() => _ListingState();
}

class _ListingState extends State<Listing> {
  List<Color> colors = []; // Store colors for each program


  final List<Color> vibrantGraphColors = [
    Color(0xFFFF5252), // Vibrant red
    Color(0xFFFFC107), // Vibrant yellow
    Color(0xFF4CAF50), // Vibrant green
    Color(0xFF448AFF), // Vibrant blue
    Color(0xFFFF5722), // Vibrant orange
    Color(0xFF9C27B0), // Vibrant purple
    Color(0xFFFFEB3B), // Bright yellow
    Color(0xFF03A9F4), // Vibrant sky blue
    Color(0xFF00E676), // Vibrant lime green
    Color(0xFFFF4081), // Vibrant pink
  ];

  Color getRandomRainbowColor() {
    Random random = Random();
    return vibrantGraphColors[random.nextInt(vibrantGraphColors.length)];
  }

  // Function to generate and store random colors for the chart and labels
  void generateColors(int count) {
    colors = List.generate(count, (index) => getRandomRainbowColor());
  }

 

  
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double fontsize = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: widget.fontsize / 100.0,
            left: widget.fontsize / 100,
            right: widget.fontsize / 100),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24)),
          child:  StreamBuilder<List<CourseWithStudentCount>>(
              stream: widget._stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/Loading.json',
                    fit: BoxFit.contain,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Lottie.asset(
                    'assets/Error.json',
                    fit: BoxFit.contain,
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Lottie.asset(
                    'assets/Empty.json',
                    fit: BoxFit.contain,
                  ),
                );
              }

              final courses = snapshot.data!;


                          // Generate random colors for each program
                          generateColors(courses.length);

                          final maxY = courses.fold<int>(0, (sum, course) {
                            return sum + course.studentCount;
                          });
                          return Column(children: [
                            Text(
                              'All Programs',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontsize / 60,
                                  color: Colors.green.shade900),
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.green.shade900,
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: fontsize / 150.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // First Column
                                      Expanded(
                                        child: Column(
                                          children: List.generate(
                                            (courses.length + 1) ~/
                                                2, // Number of items in the first column
                                            (index) {
                                              if (index >= courses.length)
                                                return SizedBox
                                                    .shrink(); // Avoid index out of bounds
                                              final course = courses[index];
                                              final color = colors[index];

                                              return Row(
                                                children: [
                                                  Container(
                                                    width: fontsize / 71.11,
                                                    height: fontsize / 150,
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  Gap(fontsize / 150),
                                                  Text(
                                                    '(${course.acronym}) ${course.program} ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontsize / 150,
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      // Second Column
                                      Expanded(
                                        child: Column(
                                          children: List.generate(
                                            courses.length -
                                                (courses.length + 1) ~/
                                                    2, // Number of items in the second column
                                            (index) {
                                              final course = courses[
                                                  (courses.length + 1) ~/ 2 +
                                                      index];
                                              final color = colors[
                                                  (courses.length + 1) ~/ 2 +
                                                      index];

                                              return Row(
                                                children: [
                                                  Container(
                                                    width: fontsize / 71.11,
                                                    height: fontsize / 150,
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  Gap(fontsize / 150),
                                                  Text(
                                                    '(${course.acronym}) ${course.program} ',
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: fontsize / 150,
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SfCartesianChart(
                                plotAreaBackgroundColor: Colors.transparent,
                                margin: EdgeInsets.all(0),
                                borderColor: Colors.transparent,
                                plotAreaBorderWidth: 0,
                                enableSideBySideSeriesPlacement: false,
                                primaryXAxis: CategoryAxis(
                                  axisLine: AxisLine(width: 0.5),
                                  majorGridLines: MajorGridLines(width: 0),
                                  majorTickLines: MajorTickLines(width: 0),
                                  crossesAt: 0,
                                  labelRotation: 0,
                                  labelStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontsize / 100,
                                      color: Colors.green.shade900,
                                      height: fontsize/500),
                                ),
                                primaryYAxis: NumericAxis(
                                  isVisible: false,
                                  minimum: 0,
                                  maximum: maxY.toDouble(),
                                  interval: 1,
                                ),
                                series: <CartesianSeries>[
                                  ColumnSeries<CourseWithStudentCount, String>(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    dataSource: courses,
                                    xValueMapper:
                                        (CourseWithStudentCount data, _) =>
                                            data.acronym,
                                    yValueMapper:
                                        (CourseWithStudentCount data, _) =>
                                            data.studentCount,
                                    name: 'Students',
                                    // Use the same color for each course in the chart
                                    pointColorMapper: (_, index) =>
                                        colors[index!],
                                    dataLabelSettings: DataLabelSettings(
                                      isVisible: true,
                                      alignment: ChartAlignment.center,
                                      labelAlignment:
                                          ChartDataLabelAlignment.top,
                                      useSeriesColor: true,
                                      color: Colors.transparent,
                                      textStyle: TextStyle(
                                        fontSize: fontsize / 100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Program Labels with Same Colors
                          ]);
                        },
                      ),
                    ),
      ),
    );            
    
    
          
  }
}

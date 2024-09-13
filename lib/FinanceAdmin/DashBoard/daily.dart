
import 'package:plsp/FinanceAdmin/DashBoard/Controllers.dart';
import 'package:plsp/FinanceAdmin/DashBoard/Model.dart';
import 'package:plsp/FinanceAdmin/DashBoard/ORno.dart';
import 'package:plsp/SuperAdmin/College/CollegeCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class Daily extends StatefulWidget {
  const Daily({
    super.key,
    required this.widget,
  });

  final OrNUmber widget;

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  late RequestCountsTodayController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RequestCountsTodayController(); // Initialize controller
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(fontsize/80),
  color: Colors.white,

          ),
          
            margin: EdgeInsets.only(top: fontsize/100, left: fontsize/100, bottom: fontsize/100),
            child: StreamBuilder<RequestCountsToday>(
                stream: _controller.requestCountsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    // Data has been fetched successfully
                    final requestCounts = snapshot.data!;

                    final maxRequests = 150;

                    final ISReq = (requestCounts.isRequests.unpaidRequests ??
                        0 / maxRequests);
                    final ISPaid = (requestCounts.isRequests.paidRequests ??
                        0 / maxRequests);
                    final GradReq =
                        (requestCounts.graduatesRequests.unpaidRequests ??
                            0 / maxRequests);
                    final GradPaid =
                        (requestCounts.graduatesRequests.paidRequests ??
                            0 / maxRequests);

                    final CollegeReq =
                        (requestCounts.collegeRequests.unpaidRequests ??
                            0 / maxRequests);
                    final CollegePaid =
                        (requestCounts.collegeRequests.paidRequests ??
                            0 / maxRequests);


                            final requests = ISReq.toDouble() + GradReq.toDouble() + CollegeReq.toDouble();
  final paid = ISPaid.toDouble() + GradPaid.toDouble() + CollegePaid.toDouble();

                        final percentage = ( paid /(paid + requests ) ?? 0 ) *100 ;
print(' paid : $paid');
print(requests);

                    return Column(
                      children: [
                        Padding(
                           padding:  EdgeInsets.all(fontsize/100.0),
                          child: Text("Today's Total Data",
                            style: GoogleFonts.poppins(
                                            color: Colors
                                                .green.shade900, // Adjust color as needed
                                            fontSize: fontsize / 80,
                                            fontWeight: FontWeight.bold,
                                          ),),
                        ),
                        
                        Expanded(
                          flex: 2,
                          child: Padding(
                             padding:  EdgeInsets.all(fontsize/100.0),
                            child: SfRadialGauge(
                              axes: [
                                RadialAxis(
                                  maximum: 100,
                                  labelOffset: 0,
                                  pointers: [
                                    RangePointer(
                                      value: (CollegeReq.toDouble() +
                                          GradReq.toDouble() +
                                          ISReq.toDouble() +
                                          CollegePaid.toDouble() +
                                          GradPaid.toDouble() +
                                          ISPaid.toDouble()),
                                      color: Color(0XFFFD4C3D),
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: fontsize / 80,
                                    )
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
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
                                            fontSize: fontsize / 80,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      positionFactor: 0,
                                    )
                                  ],
                                ),
                                RadialAxis(
                                  pointers: [
                                    RangePointer(
                                      value: (GradReq.toDouble() +
                                          ISReq.toDouble() +
                                          CollegePaid.toDouble() +
                                          GradPaid.toDouble() +
                                          ISPaid.toDouble()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color(0XFFFE7946),
                                      width: fontsize / 80,
                                    )
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
                                  showLabels: false,
                                  showTicks: false,
                                  showAxisLine: false,
                                ),
                                RadialAxis(
                                  pointers: [
                                    RangePointer(
                                      value: (ISReq.toDouble() +
                                          CollegePaid.toDouble() +
                                          GradPaid.toDouble() +
                                          ISPaid.toDouble()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color(0XFFFEA650),
                                      width: fontsize / 80,
                                    ),
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
                                  showLabels: false,
                                  showTicks: false,
                                  showAxisLine: false,
                                ),
                                RadialAxis(
                                  pointers: [
                                    RangePointer(
                                      value: (CollegePaid.toDouble() +
                                          GradPaid.toDouble() +
                                          ISPaid.toDouble()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color(0XFFFFD359),
                                      width: fontsize / 80,
                                    )
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
                                  showLabels: false,
                                  showTicks: false,
                                  showAxisLine: false,
                                ),
                                RadialAxis(
                                  pointers: [
                                    RangePointer(
                                      value: (GradPaid.toDouble() +
                                          ISPaid.toDouble()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color(0XFFA0B245),
                                      width: fontsize / 80,
                                    )
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
                                  showLabels: false,
                                  showTicks: false,
                                  showAxisLine: false,
                                ),
                                RadialAxis(
                                  pointers: [
                                    RangePointer(
                                      value: (ISPaid.toDouble()),
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: Color(0XFF419131),
                                      width: fontsize / 80,
                                    )
                                  ],
                                  axisLineStyle: AxisLineStyle(
                                    thickness: fontsize / 80,
                                    cornerStyle: CornerStyle.bothCurve,
                                  ),
                                  startAngle: 90,
                                  endAngle: 89,
                                  showLabels: false,
                                  showTicks: false,
                                  showAxisLine: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.all(fontsize/100.0),
                            child: Row(
                              children: [
                                Expanded(child: Column(
                                  children: [
                          
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(' Total Requests',
                                           style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontsize/120
                                            ),),
                                        ),
                                      ],
                                    ),
                                    
                                    Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFFFD4C3D),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('College',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                     Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFFFE7946),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('Graduates',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                      Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFFFEA650),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('Integrated',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                  ],
                                )),
                                 Expanded(child: Column(
                                  children: [
                          
                                    Row(
                                      children: [
                                        Center(child: Text('Total Accomodated',
                                         style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/120
                                        ),)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFFFFD359),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('College',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                     Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFFA0B245),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('Graduates',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                      Row(
                                      children: [
                                        Container( 
                                                          height: height/70,
                                                          width: fontsize/50,
                                                          decoration: BoxDecoration(
                                                          color: Color(0xFF419131),
                                                          borderRadius: BorderRadius.circular(14),
                                                        ),
                                        ),
                                         Gap(fontsize/200),
                                    Expanded(
                                      child: Text('Integrated',
                                       style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                            fontSize: fontsize/130
                                        ),),
                                    ),
                                      
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                })));
  }
}

import 'package:plsp/SuperAdmin/Dashboard/Model.dart';
import 'package:plsp/SuperAdmin/Dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Daily extends StatefulWidget {
  const Daily({
    super.key,
    required this.fontsize,
  });

  final double fontsize;

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  late RequestStatsController _requestStatsController;

  @override
  void initState() {
    super.initState();
    _requestStatsController = RequestStatsController();
  }

  @override
  void dispose() {
    _requestStatsController
        .dispose(); // Dispose controller when screen is disposed
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
            borderRadius: BorderRadius.circular(widget.fontsize / 80),
            color: Colors.white),
        child: StreamBuilder<RequestStats>(
          stream: _requestStatsController.requestStatsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while the data is being fetched
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Display an error message if something went wrong
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final stat = snapshot.data!;

              final maxRequests = 150;

              final Un = (stat.unpaidRequests ?? 0 / maxRequests);
              final Paid = (stat.paidRequests ?? 0 / maxRequests);
              final unc = (stat.unclaimedDocuments ?? 0 / maxRequests);
              final claimed = (stat.claimedDocuments ?? 0 / maxRequests);

              final percent = ((Un + Paid + unc + claimed) ?? 0) / 150 * 100;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(fontsize / 100.0),
                    child: Text(
                      "Today's Total Data",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade900, // Adjust color as needed
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(fontsize / 100.0),
                      child: SfRadialGauge(
                        axes: [
                          RadialAxis(
                            maximum: 100,
                            labelOffset: 0,
                            pointers: [
                              RangePointer(
                                value: (Un.toDouble() +
                                    Paid.toDouble() +
                                    unc.toDouble() +
                                    claimed.toDouble()),
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
                                    '${percent.toStringAsFixed(0)}%',
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
                                value: (Un.toDouble() +
                                    Paid.toDouble() +
                                    unc.toDouble()),
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
                                value: (Un.toDouble() + Paid.toDouble()),
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
                                value: (Un.toDouble()),
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
                    padding: EdgeInsets.all(fontsize / 80.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            children: [
                              Center(
                                  child: Text(
                                'ALl Requests',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 120),
                              )),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            children: [
                              Container(
                                height: height / 70,
                                width: fontsize / 50,
                                decoration: BoxDecoration(
                                  color: Color(0XFFFD4C3D),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              Gap(fontsize / 200),
                              Text(
                                'Unsettled Requests',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 130),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: height / 70,
                              width: fontsize / 50,
                              decoration: BoxDecoration(
                                color: Color(0XFFFE7946),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            Gap(fontsize / 200),
                            Expanded(
                              child: Text(
                                'Paid Requests',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 130),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: height / 70,
                              width: fontsize / 50,
                              decoration: BoxDecoration(
                                color: Color(0XFFA0B245),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            Gap(fontsize / 200),
                            Expanded(
                              child: Text(
                                'Unclaimed Requests',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 130),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: height / 70,
                              width: fontsize / 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF419131),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            Gap(fontsize / 200),
                            Expanded(
                              child: Text(
                                'Claimed Requests',
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontsize / 130),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              );
            } else {
              // If no data is available, display a message
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

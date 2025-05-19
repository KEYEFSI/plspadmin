import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'Model.dart';
import 'controller.dart';

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
    _requestStatsController.dispose();
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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final stat = snapshot.data!;

              final maxRequests = 150;

              final pending = (stat.pending ?? 0 / maxRequests);
              final approved = (stat.approved ?? 0 / maxRequests);
              final paid = (stat.paid ?? 0 / maxRequests);
              final completed = (stat.completed ?? 0 / maxRequests);
              final obtained = (stat.obtained ?? 0 / maxRequests);

              final percent =
                  ((pending + approved + paid + completed + obtained) ?? 0) /
                      150 *
                      100;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(fontsize / 100.0),
                    child: Text(
                      "Today's Total Data",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade900,
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
                                value: (pending.toDouble() +
                                    approved.toDouble() +
                                    paid.toDouble() +
                                    completed.toDouble() +
                                    obtained.toDouble()),
                                color: Color(0XFF205072),
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
                                      color: Colors.green,
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
                                value: (pending.toDouble() +
                                    approved.toDouble() +
                                    paid.toDouble() +
                                    completed.toDouble()),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Color(0XFF329d9c),
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
                                value: (pending.toDouble() +
                                    approved.toDouble() +
                                    paid.toDouble()),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Color(0XFF56c5296),
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
                                value:
                                    (pending.toDouble() + approved.toDouble()),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Color(0XFF7be495),
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
                                value: (pending.toDouble()),
                                cornerStyle: CornerStyle.bothCurve,
                                color: Color(0XFFcff4d2),
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
                          )
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
                                  color: Color(0XFF205072),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              Gap(fontsize / 200),
                              Text(
                                'Pending Requests',
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
                                color: Color(0XFF329d9c),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            Gap(fontsize / 200),
                            Expanded(
                              child: Text(
                                'Approved Requests',
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
                                color: Color(0XFF56c596),
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
                                color: Color(0xFF7be495),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            Gap(fontsize / 200),
                            Expanded(
                              child: Text(
                                'Completed Requests',
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
                                color: Color(0xFFcff4d2),
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
                        )
                      ],
                    ),
                  )),
                ],
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

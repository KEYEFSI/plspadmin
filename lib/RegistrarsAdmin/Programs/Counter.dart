import 'package:plsp/RegistrarsAdmin/Programs/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Counter extends StatefulWidget {
  const Counter({
     required Stream<CounterData> stream,
    super.key,
  }) : _stream = stream;

  final Stream<CounterData> _stream;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    return Expanded(
      child: StreamBuilder<CounterData?>(
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
              return Lottie.asset('assets/Error.json', fit: BoxFit.contain);
            } else if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Lottie.asset('assets/Empty.json', fit: BoxFit.contain);
              }

              // Data is available, so extract and display it
              final counts = snapshot.data!;
              return Expanded(
                  child: Row(children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(fontsize / 100.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(fontsize / 300.0),
                          child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(fontsize / 300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color(0xFFD3FFE7).withOpacity(0.5),
                                      ),
                                      child: Lottie.asset(
                                        'assets/Student.json',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Student',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          counts.collegeUserCount
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: fontsize / 300),
                                          child: Expanded(
                                            child: Text(
                                              'Overall Number of  Students',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade900,
                                                fontSize: fontsize / 160,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(fontsize / 300.0),
                          child: Container(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(fontsize / 300),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            Color(0xFFD3FFE7).withOpacity(0.5),
                                      ),
                                      child: Lottie.network('https://lottie.host/c1dc38a5-4e83-4294-9fca-3f98aeeb9a2e/pgZQQyx349.json',
                                         fit: BoxFit.contain),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Programs',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            fontSize: fontsize / 120,
                                          ),
                                        ),
                                        Text(
                                          counts.totalCourseCount
                                              .toString()
                                              .padLeft(3, '0'),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 80,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: fontsize / 300),
                                          child: Expanded(
                                            child: Text(
                                              'Overall Number of  Programs',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade900,
                                                fontSize: fontsize / 160,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ))
              ]));
            } else {
              return Center(child: Text('No data available'));
            }
          }),
    );
  }
}

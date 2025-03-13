import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/CollegeCounterController.dart';
import 'package:plsp/SuperAdminRegistrar/Students/PendingAccts/CollegeCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ISPendingAccounts extends StatefulWidget {
  const ISPendingAccounts({
    super.key,
  });

  @override
  State<ISPendingAccounts> createState() => _ISPendingAccountsState();
}

class _ISPendingAccountsState extends State<ISPendingAccounts> {
  late ISStudentController _controller;
  final DeleteStudentController controller = DeleteStudentController();
  int? hoveredIndex;

void _approveStudent(String username) async {
  final response = await controller.deleteStudent(username);

  if (response['success'] == true) {
    // Show success message
 _showSuccessMessage('Student "$username" approved successfully!');
  } else {
    // Show error message
   _showErrorMessage('Failed to approve student "$username": ${response['message']}');
  }
}


void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    player.play(AssetSource('success.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 7,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade700,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/success.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Awesome!,',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showErrorMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    // Play sound
    player.play(AssetSource('Error.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/error.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Oh snap!',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
  @override
  void initState() {
    super.initState();
    _controller = ISStudentController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(fontsize / 100.0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(fontsize / 80),
                  Expanded(
                    child: Text('Fullname',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),  
                  Expanded(
                    child: Text('Student No.',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.black87
                        )),
                  ),
                  Expanded(
                    child: Text('Email',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                           color: Colors.black87
                        )),
                  ),
                  Container(
                    width: fontsize / 10,
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: StreamBuilder<List<ISStudent>>(
                stream: _controller.studentsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                 } else if (snapshot.hasData && snapshot.data!.isEmpty) {
      return Lottie.asset('assets/error.json', fit: BoxFit.contain);
                  } else if (snapshot.hasData) {
                    final students = snapshot.data!;
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final isHovered = hoveredIndex == index;

                        return Container(
                          decoration: BoxDecoration(
                              color: isHovered
                                  ? Colors.green.shade100
                                  : Colors.white),
                          child: Column(
                            children: [
                              Gap(height / 100),
                              Row(children: [
                                Gap(fontsize / 80),
                                Expanded(
                                  child: Text(student.fullname ?? '',
                                      style: GoogleFonts.poppins(
                                          fontSize: fontsize / 90,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  child: Text(student.username ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: fontsize / 90,
                                        color: Colors.black,
                                      )),
                                ),
                                Expanded(
                                  child: Text(student.email ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: fontsize / 90,
                                        color: Colors.black,
                                      )),
                                ),
                                MouseRegion(
                                  onEnter: (_) {
                                    setState(() {
                                      hoveredIndex = index;
                                    });
                                  },
                                  onExit: (_) {
                                    setState(() {
                                      hoveredIndex = null;
                                    });
                                  },
                                  child: Transform(
                                      transform: isHovered
                                          ? (Matrix4.identity()
                                            ..scale(1.01)) // Scale up on hover
                                          : Matrix4.identity(),
                                      alignment: Alignment.center,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: isHovered
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 3,
                                                    blurRadius: 5,
                                                  )
                                                ]
                                              : [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 1,
                                                    blurRadius: 2,
                                                  )
                                                ],
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            _approveStudent(
                                                student.username ?? '');
                                          },
                                          child: Container(
                                            width: fontsize / 10,
                                            decoration: BoxDecoration(
                                                color: Colors.green.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesome.check_circle,
                                                  color: isHovered
                                                      ? Colors.green.shade100
                                                      : Colors.white,
                                                ),
                                                Text(
                                                  "Approve",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              ]),
                              Gap(height / 100),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No data found"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

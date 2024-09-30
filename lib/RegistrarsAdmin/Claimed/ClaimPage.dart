import 'package:plsp/RegistrarsAdmin/Claimed/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/Counter.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/List.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/Model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CalimedTab extends StatefulWidget {
  final String username;
  final String fullname;

  const CalimedTab({super.key, required this.username, required this.fullname});

  @override
  State<CalimedTab> createState() => _ClaimedTab();
}

class _ClaimedTab extends State<CalimedTab> {
  late AccomplishedDocumentsController _controller;
  late Future<AccomplishedDocumentsCount> _studentCount;

  List<Course> _Course = [];
  late CourseController _courseController;

  @override
  void initState() {
    super.initState();

    _controller = AccomplishedDocumentsController();

    _courseController = CourseController();
    _fetchCourses();
    _studentCount = _fetchStudentCount();
  }

  void _fetchCourses() async {
    try {
      final _courses = await _courseController.fetchCourses();
      setState(() {
        _Course = _courses;
      });
    } catch (e) {
      print('Error updating course state: $e');
    }
  }

  Future<AccomplishedDocumentsCount> _fetchStudentCount() async {
    try {
      final studentCount = await _controller.fetchDocumentCounts();
      return studentCount; // Return the fetched data
    } catch (e) {
      print('Error updating student count: $e');
      return AccomplishedDocumentsCount(
          totalCount: 0,
          unclaimedCount: 0,
          claimedCount: 0,
          dailyTotalCount: 0,
          dailyUnclaimedCount: 0,
          dailyClaimedCount: 0,
          dailyClaimedPercent: 0,
          dailyUnclaimedPercent: 0); // Default value in case of error
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    'Hello,',
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Text(
                    ' ${widget.fullname}! ',
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  Container(
                      height: height / 20,
                      child:
                          Lottie.asset('assets/hi.json', fit: BoxFit.cover)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: fontsize / 80),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    formatted,
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(fontsize / 100.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: AssetImage('assets/dashboardbg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Counter(
                        studentCount: _studentCount,
                      ),
                      Listing(
                        fontsize: fontsize,
                        courses: _Course,
                        admin: widget.username,
                        onCallback: _fetchStudentCount,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

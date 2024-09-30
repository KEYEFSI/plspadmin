import 'package:plsp/RegistrarsAdmin/Programs/AddProgram.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Counter.dart';
import 'package:plsp/RegistrarsAdmin/Programs/List.dart';
import 'package:plsp/RegistrarsAdmin/Programs/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Program extends StatefulWidget {
  final String username;
  final String fullname;

  const Program({super.key, required this.username, required this.fullname});

  @override
  State<Program> createState() => _ProgramTab();
}

class _ProgramTab extends State<Program> {

  late CounterController _counterController;
  late Future<CounterData> _counterDataFuture;

  late Future<List<CourseWithStudentCount>> coursesFuture;
  late CourseService courseService = CourseService();

  @override
  void initState() {
    super.initState();

    _counterController = CounterController(apiUrl: '$kUrl/FMSR_GetCounter');
    _counterController.fetchCounterData();

    courseService = CourseService();
    coursesFuture = _fetchCourseData();

  
  }

Future<List<CourseWithStudentCount>> _fetchCourseData() async {
    try {
      courseService.refreshCourseData();
      return await courseService.courseStream.first;
    } catch (e) {
      print('Error fetching course data: $e');
      return [];
    }
  }

  
 
void _refreshCounter() async {
  try {
    // Refresh counter data
    _counterController.refreshCounterData();
  } catch (e) {
    print('Error refreshing counter data: $e');
    // Optionally, show an error message to the user
  }

  try {
    // Refresh course data
    courseService.refreshCourseData();
    
    // Await the next snapshot of course data from the stream
    final updatedCourses = await courseService.courseStream.first;
    
    // You might want to handle or use the updatedCourses here
    print('Updated courses: $updatedCourses');
  } catch (e) {
    print('Error fetching course data: $e');
    // Optionally, show an error message to the user
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
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(fontsize / 100.0),
                    child: AddProgram(
                      onCallback: _refreshCounter,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Counter(
                        stream: _counterController.stream,
                      ),
                      Listing(
                        fontsize: fontsize,
                        stream:  courseService.courseStream,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

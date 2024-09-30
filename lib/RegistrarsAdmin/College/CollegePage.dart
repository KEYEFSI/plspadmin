import 'package:plsp/RegistrarsAdmin/College/CollegeCounterController.dart';
import 'package:plsp/RegistrarsAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/RegistrarsAdmin/College/Counter.dart';
import 'package:plsp/RegistrarsAdmin/College/ListView.dart';
import 'package:plsp/RegistrarsAdmin/College/ViewPage.dart';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CollegePage extends StatefulWidget {
  final String username;
    final String fullname;

  const CollegePage({super.key, required this.username, required this.fullname});

  @override
  State<CollegePage> createState() => _CollegePageState();
}

class _CollegePageState extends State<CollegePage> {
  late FMSRCollegeStudentCountController _controllers;
  late Future<FMSRCollegeStudentCount> _studentCount;


  late FMSRCollegePendingCountController _controllert;
  late Future<PendingCount> _transactionCount;

  
  late AccomplishedCountController _acccontroller;
  late Future<AccomplishedCount> _accomplishCount;

  List<Course> _Course = [];
  late CourseController _courseController;

  late Future<List<CollegeDocumentRequest>> _documentsFuture;
  late AdminShowCollegeDocumentsController _adminController;
  CollegeDocumentRequest? _selectedStudent;
  late Future<List<Document>> _studentDetailsFuture;
  DocumentController documentController = DocumentController();
  late Future<List<DocumentList>> _futureDocuments;

  @override
  void initState() {
    super.initState();

    _controllers = FMSRCollegeStudentCountController(apiUrl: '$kUrl');
    _studentCount = _controllers.fetchStudentCount();
    _controllert = FMSRCollegePendingCountController(apiUrl: '$kUrl');
    _transactionCount = _controllert.fetchTransactionCount();

    _acccontroller = AccomplishedCountController();
    _accomplishCount = _acccontroller.fetchAccomplishedCount();

    _courseController = CourseController();
    _fetchCourses();

    _adminController = AdminShowCollegeDocumentsController();
    _documentsFuture = _fetchAdminProfile(); 

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

 Future<List<CollegeDocumentRequest>> _fetchAdminProfile() async {
    try {
      final _adminController = AdminShowCollegeDocumentsController();
      return await _adminController.fetchCollegeDocuments();
    } catch (e) {
      throw Exception('Error fetching college documents: $e');
    }
  }

  void _showStudentDetails(CollegeDocumentRequest student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  void _saved() {
    setState(() {
      // Reassign the Future to trigger a rebuild
      _documentsFuture = _fetchAdminProfile();
      _selectedStudent = null;
    });

    
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize =
        MediaQuery.of(context).size.width;

        final height = MediaQuery.of(context).size.height ;
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
                        transactionCount: _transactionCount,
                         requestsCount: _accomplishCount,
                      ),
                      DocumentsListView(
                        courses: _Course,
                        selectedStudent: _showStudentDetails,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ViewPage(
              fontsize: fontsize,
              height: height,
              selectedStudent: _selectedStudent,
              user: widget.username,
              onCallback: _saved, admin: widget.username,
            ),
          ],
        ),
      ),
    );
  }
}


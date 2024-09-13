import 'package:plsp/SuperAdmin/Graduates/Counter.dart';
import 'package:plsp/SuperAdmin/Graduates/GraduatesCounterController.dart';
import 'package:plsp/SuperAdmin/Graduates/GraduatesCounterModel.dart';
import 'package:plsp/SuperAdmin/Graduates/ViewProfile.dart';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';


class GraduatesPage extends StatefulWidget {
   final String username;
  final String fullname;

 const GraduatesPage(
      {super.key, required this.username, required this.fullname});

  @override
  State<GraduatesPage> createState() => _GraduatesPageState();
}

class _GraduatesPageState extends State<GraduatesPage> {
  late FMSRGraduatesRequestsCountController _controller;
  late Future<FMSRGraduatesRequestsCount> _requestsCount;
  late FMSRGraduatesStudentCountController _controllers;
  late Future<FMSRGraduatesStudentCount> _studentCount;
  late FMSR_GetGraduatesStudentTransactionCount _controllert;
  late Future<FMSRGraduatesTransactionCounter> _transactionCount;
  late TextEditingController _SearchController;
  late FocusNode _SearchFocusNode;
 
  List<dynamic> _allStudents = [];
  late Future<List<dynamic>> _students = Future.value([]);
  late final GetGraduates _getIS;
  StudentGrad? _selectedStudent;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = FMSRGraduatesRequestsCountController(apiUrl: '$kUrl');
    _requestsCount = _controller.fetchRequestsCount();
    _controllers = FMSRGraduatesStudentCountController(apiUrl: '$kUrl');
    _studentCount = _controllers.fetchStudentCount();
        _controllert = FMSR_GetGraduatesStudentTransactionCount(apiUrl: '$kUrl');
    _transactionCount = _controllert.fetchTransactionCount();

    _SearchController = TextEditingController();
    _SearchFocusNode = FocusNode();

    _getIS = GetGraduates('$kUrl');
    _fetchStudents();

    _SearchController.addListener(() {
      setState(() {
        _students = Future.value(_filterStudents(_SearchController.text));
      });
    });
  }

  void _fetchStudents() async {
    try {
      final fetchedStudents = await _getIS.fetchStudentData();
      setState(() {
        _allStudents = fetchedStudents.cast<dynamic>(); // Ensure correct type
        _students = Future.value(_allStudents);
      });
    } catch (e) {
      print('Error fetching students: $e'); // Debugging
    }
  }

  List<dynamic> _filterStudents(String query) {
    if (query.isEmpty) {
      return _allStudents;
    } else {
      final searchQuery = query.toLowerCase();
      return _allStudents.where((student) {
        final username = student.username?.toLowerCase() ?? '';
        final fullname = student.fullname?.toLowerCase() ?? '';
        return username.contains(searchQuery) || fullname.contains(searchQuery);
      }).toList();
    }
  }

  @override
  void dispose() {
    _SearchController.dispose();
    _SearchFocusNode.dispose();
    super.dispose();
  }

  void _showStudentDetails(StudentGrad student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  void _refreshStudentData() {
    // Call _fetchStudents to refresh the student data
    _fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize =
        MediaQuery.of(context).size.width;

        final height = MediaQuery.of(context).size.height ;
       final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MM dd, yyyy');
    final String formatted = formatter.format(now);

    return Scaffold(
       appBar: AppBar(
        title: Expanded(
          child: Row(
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(fontsize/80, height/84, fontsize/80, height/42),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, height/42, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/dashboardbg.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white60,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          color: Color(0x33000000),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Counter(
                          studentCount: _studentCount,
                          requestsCount: _requestsCount,
                          transactionCount: _transactionCount,
                          
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding:  EdgeInsetsDirectional.fromSTEB(
                                fontsize/80, 0,    fontsize/80, height /42),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16.0, left: 16),
                                          child: Text(
                                            'All Integrated School Students',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 80,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade900,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                               top: height/64, right: fontsize/120),
                                          child: TextField(
                                            
                                            controller: _SearchController,
                                            focusNode: _SearchFocusNode,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Search',
                                              labelStyle: GoogleFonts.poppins(
                                                fontSize: fontsize / 120,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40.0),
                                              ),
                                              filled: false,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              prefixIcon: Icon(
                                                FontAwesome.search,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                    size: fontsize/80,
                                              ),
                                            ),
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 120,
                                              color:
                                                  Theme.of(context).hoverColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/64),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: fontsize / 80, right: fontsize / 80),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  fontsize/80, 0, fontsize/80, 0),
                                          child: Text(
                                            'Image',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Student ID',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Fullname',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'BirthDate',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Phone   Number',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Address',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Outstanding Balance',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 100,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                              
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: fontsize/80.0, right: fontsize/80.0),
                                    child: Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: FutureBuilder<List<dynamic>>(
                                        future: _students,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Lottie.asset(
                                                'assets/Loading.json');
                                          } else if (snapshot.hasError) {
                                            return Lottie.asset(
                                                'assets/Loading.json');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Lottie.asset(
                                                'assets/Loading.json');
                                          } else {
                                            return ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                final student =
                                                    snapshot.data![index];
                                                final profileImageUrl = student
                                                            .profile_image !=
                                                        null
                                                    ? '$Purl${student.profile_image}'
                                                    : null;
                                                final birthday = student
                                                    .birthday; 
                                               final _birthday= birthday != null ? DateFormat('MMM dd yyyy').format(birthday) : 'Unknown';

                                                bool isSelected =
                                                    _selectedIndex == index;

                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedIndex = index;
                                                    });
                                                    _showStudentDetails(
                                                        student);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24.0,
                                                            right: 24,
                                                            top: 12),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient: isSelected
                                                ? LinearGradient(
                                                    colors: [
                                                      Colors.white,
                                                      Colors.greenAccent.shade700
                                                      
                                                    ],
                                                    stops: [0, 1],
                                                    begin: AlignmentDirectional(
                                                        1, 0),
                                                    end: AlignmentDirectional(
                                                        -1, 0),
                                                  )
                                                : null,
                                            color: isSelected
                                                ? null
                                                : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            offset:
                                                                Offset(0, 2),
                                                            blurRadius: 4,
                                                          ),
                                                        ],
                                                      ),
                                                      height: isSelected
                                              ? height / 12
                                              : height / 14,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                 padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                fontsize/80,
                                                                0,
                                                                fontsize / 80,
                                                                0),
                                                                child:
                                                                    Container(
                                                                   width: fontsize / 32,
                                                      height: height / 16.95,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .greenAccent,
                                                                        Colors
                                                                            .white
                                                                      ],
                                                                      stops: [
                                                                        0,
                                                                        1
                                                                      ],
                                                                      begin:
                                                                          AlignmentDirectional(
                                                                              0,
                                                                              -1),
                                                                      end: AlignmentDirectional(
                                                                          0, 1),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            3.0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      child: profileImageUrl !=
                                                                              null
                                                                          ? Image
                                                                              .network(
                                                                              profileImageUrl,
                                                                              width: 60,
                                                                              height: 60,
                                                                              fit: BoxFit.cover,
                                                                              headers: kHeader,
                                                                            )
                                                                          : Icon(
                                                                              Icons.person,
                                                                              size: 50,
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  student.username ??
                                                                      'Student Id',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            106,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  student.fullname ??
                                                                      'Fullname',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                        letterSpacing: 0,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  _birthday ??
                                                                      'MMM DD, YYYY',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  student.number ??
                                                                      'Phone Number',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  student.address ??
                                                                      'Address',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'Php ${student.balance?.toStringAsFixed(2) ?? '00.00'}',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            106,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                         
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ViewProfile(
                selectedStudent: _selectedStudent,
                onPaymentSaved: _refreshStudentData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

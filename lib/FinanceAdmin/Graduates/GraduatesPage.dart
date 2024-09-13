import 'package:plsp/FinanceAdmin/Graduates/Counter.dart';
import 'package:plsp/FinanceAdmin/Graduates/GraduatesCounterController.dart';
import 'package:plsp/FinanceAdmin/Graduates/GraduatesCounterModel.dart';
import 'package:plsp/FinanceAdmin/Graduates/ViewProfile.dart';
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
  late FMSRGraduatesRequestCountController _controller;
  late Future<FMSRGraduatesRequestCount> _requestsCount;
  late FMSRGraduatesStudentCountController _controllers;
  late Future<FMSRGraduatesStudentCount> _studentCount;
  late FMSRGraduatesTransactionCountController _controllert;
  late Future<FMSRGraduatesTransactionCount> _transactionCount;

  late TextEditingController _SearchController;
  late FocusNode _SearchFocusNode;
  List<dynamic> _allStudents = [];
  late Future<List<dynamic>> _students = Future.value([]);
  late GetGraduates _getGraduates;
  GraduatesStudent? _selectedStudent;
  int? _selectedIndex;
  bool _showEditablePage = false;

  @override
  void initState() {
    super.initState();
    _controller = FMSRGraduatesRequestCountController(apiUrl: '$kUrl');
    _requestsCount = _controller.fetchRequestsCount();
    _controllers = FMSRGraduatesStudentCountController(apiUrl: '$kUrl');
    _studentCount = _controllers.fetchStudentCount();
    _controllert = FMSRGraduatesTransactionCountController(apiUrl: '$kUrl');
    _transactionCount = _controllert.fetchTransactionCount();
    _SearchController = TextEditingController();
    _SearchFocusNode = FocusNode();
    _getGraduates = GetGraduates('$kUrl');

    _fetchStudents();
    _SearchController.addListener(() {
      setState(() {
        _students = Future.value(_filterStudents(_SearchController.text));
      });
    });
  }

  void _fetchStudents() async {
    try {
      final fetchedStudents = await _getGraduates.fetchStudentRequests();
      fetchedStudents.sort((a, b) => a.date.compareTo(b.date));
      setState(() {
        _allStudents = fetchedStudents.cast<dynamic>();
        _students = Future.value(_allStudents);
      });
    } catch (e) {
      print('Error fetching students: $e');
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

  void _showStudentDetails(GraduatesStudent student) {
    setState(() {
      _selectedStudent = student;
      _showEditablePage = true;
    });
  }

  void unselect() {
    setState(() {
      _selectedIndex = null;
    });
  }

  void refresh() {
    _requestsCount = _controller.fetchRequestsCount();
  }

  void refresh1() {
    _transactionCount = _controllert.fetchTransactionCount();
  }

  void _refreshStudentData() {
    setState(() {
      print('Updating UI state...');
      _showEditablePage = false;
      _selectedIndex = null;
    });

    print('Fetching students...');
    _fetchStudents();

    print('Unselecting...');
    unselect();

    print('Refreshing...');
    refresh();

    print('Refreshing 1...');
    refresh1();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

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
                      'Good Day,',
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
          padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 24, 0),
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
                        ViewProfile(
                          showEditablePage: _showEditablePage,
                          selectedStudent: _selectedStudent,
                          onPaymentSaved: _refreshStudentData,
                          username: widget.username,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, left: 16),
                              child: Text(
                                'All Graduates Students Requests',
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize / 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: fontsize / 120,
                            top: height / 63,
                            right: fontsize / 120),
                        child: TextField(
                          controller: _SearchController,
                          focusNode: _SearchFocusNode,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Search',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: fontsize / 106.6,
                              color: Theme.of(context).primaryColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).cardColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColorLight,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            filled: false,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            prefixIcon: Icon(
                              FontAwesome.search,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 106,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: height / 42),
                      Padding(
                        padding: EdgeInsets.only(
                            left: fontsize / 80.0, right: fontsize / 80.0),
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
                                return Lottie.asset('assets/Loading.json');
                              } else if (snapshot.hasError) {
                                return Lottie.asset('assets/Loading.json');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Lottie.asset('assets/Empty.json');
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final student = snapshot.data![index];
                                    final profileImageUrl =
                                        student.profile_image != null
                                            ? '$Purl${student.profile_image}'
                                            : null;

                                    bool isSelected = _selectedIndex == index;
                                    String formattedDate =
                                        DateFormat('EEE, MMM dd, yyyy')
                                            .format(student.date.toLocal());

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = index;
                                        });
                                        _showStudentDetails(student);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24.0, right: 24, top: 12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? LinearGradient(
                                                    colors: [
                                                      Colors.greenAccent,
                                                      Colors.white
                                                    ],
                                                    stops: [0, 1],
                                                    begin: AlignmentDirectional(
                                                        0, -1),
                                                    end: AlignmentDirectional(
                                                        0, 1),
                                                  )
                                                : null,
                                            color: isSelected
                                                ? null
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                offset: Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          height: isSelected
                                              ? height / 12
                                              : height / 16,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12,
                                                                0,
                                                                fontsize / 300,
                                                                0),
                                                    child: Container(
                                                      width: fontsize / 32,
                                                      height: height / 16.95,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Colors.greenAccent,
                                                            Colors.white
                                                          ],
                                                          stops: [0, 1],
                                                          begin:
                                                              AlignmentDirectional(
                                                                  0, -1),
                                                          end:
                                                              AlignmentDirectional(
                                                                  0, 1),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child:
                                                              profileImageUrl !=
                                                                      null
                                                                  ? Image
                                                                      .network(
                                                                      profileImageUrl,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      headers:
                                                                          kHeader,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 50,
                                                                    ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          student.username ??
                                                              'Student Id',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize / 120,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          student.fullname ??
                                                              'Fullname',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize / 120,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          formattedDate,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize / 137,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Php ${student.balance?.toStringAsFixed(2) ?? '00.00'}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize / 137,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}

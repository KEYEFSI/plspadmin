

import 'package:plsp/SuperAdmin/College/CollegeCounterController.dart';
import 'package:plsp/SuperAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/SuperAdmin/College/Counter.dart';
import 'package:plsp/SuperAdmin/College/ViewProfile.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';


class CollegePage extends StatefulWidget {
   final String username;
  final String fullname;

  
 const CollegePage(
      {super.key, required this.username, required this.fullname});

  @override
  State<CollegePage> createState() => _CollegePageState();
}

class _CollegePageState extends State<CollegePage> {
  late FMSRCollegeRequestsCountController _controller;
  late Future<FMSRCollegeRequestCount> _requestsCount;
  late FMSRCollegeStudentCountController _controllers;
  late Future<FMSRCollegeStudentCount> _studentCount;
  late FMSRCollegeTransactionCountController _controllert;
  late Future<FMSRCollegeTransactionCount> _transactionCount;


  late TextEditingController _searchController;
  late FocusNode _SearchFocusNode;
  late GetCollege getCollege;
   late FocusNode _searchFocusNode;
  int? _selectedIndex;
  String? _selectedCourse;
  StudentCollege? _selectedStudent;



  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 5;
  int hoveredIndex = -1;
  int hoveredIndexes = -1;
 
  
  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      currentPage = 1; // Reset to the first page on a new search
    });
  }
  
   List<StudentCollege> _paginate(List<StudentCollege> students) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return students.sublist(
      startIndex,
      endIndex > students.length ? students.length : endIndex,
    );
  }

  int _calculateTotalPages(int totalItems) {
    return (totalItems / itemsPerPage).ceil();
  }

  void _showStudentDetails(StudentCollege student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  void _clearSelectedStudent() {
    setState(() {
      _selectedStudent = null;
    });
  }




  @override
  void initState() {
    super.initState();
    _controller = FMSRCollegeRequestsCountController(apiUrl: '$kUrl');
    _requestsCount = _controller.fetchRequestsCount();
    _controllers = FMSRCollegeStudentCountController(apiUrl: '$kUrl');
    _studentCount = _controllers.fetchStudentCount();
 _controllert = FMSRCollegeTransactionCountController(apiUrl: '$kUrl');
    _transactionCount = _controllert.fetchTransactionCount();


    _searchController = TextEditingController();
    _SearchFocusNode = FocusNode();

  getCollege = GetCollege();
    getCollege.startFetching(); 
   

    
  }



  @override
  void dispose() {
    _searchController.dispose();
    _SearchFocusNode.dispose();
    getCollege.dispose();
    super.dispose();
  }

 

 void _refreshStudentData() {
     setState(() {
      _selectedStudent = null;
    });
 
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
          padding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 24),
          child: Row(
            children: [
              Expanded(
                flex: 3,
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
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                24, 0, 24, 24),
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
                                            'All Documents Requests',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize/80,
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
                                             onChanged: _updateSearchQuery,
                                            controller: _searchController,
                                            focusNode: _SearchFocusNode,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              labelText: 'Search',
                                              labelStyle: GoogleFonts.poppins(
                                                fontSize: 14.0,
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
                                              
                                 
                                 
                                  
                                  Expanded(
                                    child: Container(
                                      child: StreamBuilder<List<StudentCollege>>(
          stream: getCollege.studentStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for data
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show error message if something goes wrong
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Show message if no data is available
              return Center(child: Text('No data available'));
            } else {
              
                            final student = snapshot.data!;
                            final filteredDocuments = _filterDocuments(
                              student,
                              _searchController.text,
                              _selectedCourse,
                            );

                          final totalPages =
                        _calculateTotalPages(filteredDocuments.length);
                    final paginatedStudents = _paginate(filteredDocuments);


                            if (filteredDocuments.isEmpty) {
                              return Center(
                                child: Lottie.asset(
                                  'assets/Empty.json', // Replace with the path to your Lottie asset
                                  width: 200,
                                  height: 200,
                                ),
                              );
                            }
              return Expanded(child: 
              Column(
                children: [
                  Row(
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
                                            'Student Details',
                                            style: GoogleFonts.poppins(
                                               fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                       
                                         
                                        
                                        
              
              if (totalPages > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left Arrow
                      if (currentPage > 1)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentPage--;
                            });
                          },
                          child: Icon(Icons.arrow_left, color: Colors.black),
                        ),
                      // Page Numbers
                      ...List.generate(
                        totalPages > 5 ? 5 : totalPages,
                        (index) {
                          int pageNumber = currentPage <= 3
                              ? index + 1
                              : currentPage > totalPages - 3
                                  ? totalPages - 4 + index
                                  : currentPage - 2 + index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentPage = pageNumber;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: currentPage == pageNumber
                                    ? Colors.green.shade900
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '$pageNumber',
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize / 140,
                                  fontWeight: currentPage == pageNumber
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color: currentPage == pageNumber
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (currentPage < totalPages)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentPage++;
                            });
                          },
                          child: Icon(Icons.arrow_right, color: Colors.black),
                        ),
                    ],
                  ),
                ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
            height: 1,
          ),

Expanded(
       child: Column(
          children: paginatedStudents.map((student) {
            final index = paginatedStudents.indexOf(student);
            final isHovered = hoveredIndex == index;
            
            final isSelected = _selectedIndex == index;
       
           
       
            final profileImageUrl = student.profile_image != null
                ? '$Purl${student.profile_image}'
                : null;
       
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                      _selectedStudent = student; // Set the selected index on tap
                });
                 _showStudentDetails(student);
              },
              child: Container(
                decoration: BoxDecoration(
                 gradient: isSelected
                       ? LinearGradient(
                                                          colors: [
                                                            Colors.green.shade300,
                                                            Colors.white
                                                          ],
                                                          stops: [0, 1],
                                                          begin: Alignment
                                                              .centerLeft, 
                                                          end: Alignment.centerRight,
                                                        )
                                                      : null,
                                                  color: isSelected
                                                      ? null
                                                      : Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     Padding(
                                                      padding: EdgeInsetsDirectional
                                                          .fromSTEB(
                                                              fontsize / 160,
                                                              height / 160,
                                                              fontsize / 64,
                                                              height / 160),
                                                      child: Container(
                                                        width: fontsize / 20,
                                                        height: height / 12,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Colors.green.shade900,
                                                              Colors.white
                                                            ],
                                                            stops: [0, 1],
                                                            begin: Alignment
                                                                .centerLeft, // Start at the top
                                                            end: Alignment.centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(12),
                                                          shape: BoxShape.rectangle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(3.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    12),
                                                            child: profileImageUrl !=
                                                                    null
                                                                ? Image.network(
                                                                    profileImageUrl,
                                                                    width: 32,
                                                                    height:
                                                                        height / 16.95,
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
                                                      flex: 2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            student.username.toString(),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: fontsize / 120,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Colors.green.shade900,
                                                            ),
                                                          ),
                                                          Text(
                                                            student.fullname.toString(),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: fontsize / 120,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          Text(
                                                            student.program.toString(),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: fontsize / 120,
                                                              fontWeight:
                                                                  FontWeight.normal,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                     VerticalDivider(
                                                      thickness: 1,
                                                      indent: height / 100,
                                                      endIndent: height / 80,
                                                      color: Colors.green.shade900,
                                                    ),
                                                   
                      ],
                    ),
                    Gap(height / 200),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
     ),

                ],
              )
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
  
  List<StudentCollege> _filterDocuments(
    List<StudentCollege> documents,
    String searchQuery,
    String? selectedCourse,
  ) {
    var filteredDocuments = documents;

    if (searchQuery.isNotEmpty) {
      filteredDocuments = filteredDocuments.where((student) {
        final username = student.username?.toLowerCase();
        final fullname = student.fullname?.toLowerCase();
        return username!.contains(searchQuery.toLowerCase()) ||
            fullname!.contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (selectedCourse != null) {
      filteredDocuments = filteredDocuments
          .where((student) => student.program == selectedCourse)
          .toList();
    }

    return filteredDocuments;
  }
}

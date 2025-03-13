import 'package:gap/gap.dart';
import 'package:plsp/SuperAdmin/TCP/Counter.dart';
import 'package:plsp/SuperAdmin/TCP/GraduatesCounterController.dart';
import 'package:plsp/SuperAdmin/TCP/GraduatesCounterModel.dart';

import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plsp/SuperAdmin/TCP/ViewProfile.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';


class TCPPage extends StatefulWidget {
   final String username;
  final String fullname;

 const TCPPage(
      {super.key, required this.username, required this.fullname});

  @override
  State<TCPPage> createState() => _TCPPageState();
}

class _TCPPageState extends State<TCPPage> {

 



  late TextEditingController _searchController;
  late FocusNode _SearchFocusNode;
  late GetGraduates getCollege;
   late FocusNode _searchFocusNode;
  int? _selectedIndex;
  String? _selectedCourse;
  Student? _selectedStudent;
   List<Student> studentsList = [];
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
  
   List<Student> _paginate(List<Student> students) {
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

  void _showStudentDetails(Student student) {
    setState(() {
      _selectedStudent = student;
    });
  }

  void _clearSelectedStudent() {
    setState(() {
      _selectedStudent = null;
    });
  }
  void _refreshStudentData() {
     setState(() {
      _selectedStudent = null;
    });
    
  }

   @override
  void initState() {
    super.initState();
    

    _searchController = TextEditingController();
    _SearchFocusNode = FocusNode();


   _searchController = TextEditingController();
    _SearchFocusNode = FocusNode();

  getCollege = GetGraduates();
    getCollege.fetchStudentData(); 
   

    getCollege.studentStream.listen((newStudentsList) {
      setState(() {
        studentsList = newStudentsList;  // Update data when stream emits
      });
    }, onError: (error) {
      print("Error while fetching student data: $error");
    });

   
  }

  Future<void> _exportToExcel() async {
    if (studentsList.isNotEmpty) {
      // Proceed with export if there is data
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['TCP_Students'];
      excel.setDefaultSheet(sheetObject.sheetName);

      List<String> headers = [
        'Student ID',
        'Fullname',
        'Birthday',
        'Phone Number',
        'Address',
        'Balance'
      ];

      // Add headers
      for (int i = 0; i < headers.length; i++) {
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = headers[i];
      }

      // Sort and add student data to sheet
      studentsList.sort((a, b) => (a.fullname ?? '').compareTo(b.fullname ?? ''));
      for (int rowIndex = 0; rowIndex < studentsList.length; rowIndex++) {
        var student = studentsList[rowIndex];
        final birthday = student.birthday != null
            ? DateFormat('MMM dd yyyy').format(student.birthday!)
            : 'Unknown';

        List<dynamic> row = [
          student.username ?? 'Student Id',
          student.fullname ?? 'Fullname',
          birthday,
          student.number ?? 'Phone Number',
          student.address ?? 'Address',
          student.balance?.toStringAsFixed(2) ?? '00.00',
        ];

        for (int colIndex = 0; colIndex < row.length; colIndex++) {
          sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex + 1)).value = row[colIndex];
        }
      }

      // Get application document directory and save the Excel file
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'TCP_Students.xlsx';
      final sanitizedFileName = fileName.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
      final filePath = path.join(directory.path, sanitizedFileName);

      try {
        var fileBytes = excel.save();
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export successful! File saved at: $filePath')),
        );
      } catch (e) {
        // Show error message if something fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save file: $e')),
        );
      }
    } else {
      // Show message if no data is available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No student data available to export')),
      );
    }
  }

 


  @override
  void dispose() {
    _searchController.dispose();
    _SearchFocusNode.dispose();

    getCollege.dispose();
        super.dispose();
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
                                            'All College Payees Students',
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
                                            
                                            controller: _searchController,
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
                                 
                               
                                  Expanded(
                                    child: Container(
                                      child: StreamBuilder<List<Student>>(
          stream: getCollege.studentStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());  // Loading indicator
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));  // Error handling
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));  // No data available
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
                                          flex: 2,
                                          child: Text(
                                            'Student Details',
                                            style: GoogleFonts.poppins(
                                               fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                        flex: 2,
                                          child: Text(
                                            'Student Data',
                                            style: GoogleFonts.poppins(
                                               fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                         Expanded(
                                          child: Text(
                                            'Balance',
                                            style: GoogleFonts.poppins(
                                               fontSize: fontsize / 96,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade900,
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
                     int pageNumber;

                                                if (totalPages <= 5) {
                                                  pageNumber = index + 1;
                                                } else if (currentPage <= 3) {
                                                  pageNumber = index + 1;
                                                } else if (currentPage >=
                                                    totalPages - 2) {
                                                  pageNumber =
                                                      totalPages - 4 + index;
                                                } else {
                                                  pageNumber =
                                                      currentPage - 2 + index;
                                                }
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
         final reqdate = student.birthday;
            final birthday = reqdate != null
                ? DateFormat('MMM dd, yyyy').format(reqdate.toLocal())
                : 'Unknown';
           
       
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
                                                          
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                     VerticalDivider(
                                                      thickness: 1,
                                                      indent: height / 100,
                                                      endIndent: height / 80,
                                                      color: Colors.green.shade900,
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
                                                            student.number.toString(),
                                                            style: GoogleFonts.poppins(
                                                              fontSize: fontsize / 120,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color:
                                                                  Colors.green.shade900,
                                                            ),
                                                          ),
                                                          FittedBox(
                                                            fit: BoxFit.contain,
                                                            child: Text(
                                                              student.address.toString(),
                                                              style: GoogleFonts.poppins(
                                                                fontSize: fontsize / 120,
                                                                fontWeight:
                                                                    FontWeight.bold,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                           Text(
                                                            birthday,
                                                            style: GoogleFonts.poppins(
                                                              fontSize: fontsize / 120,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ])
                                                   ), 
                                                   Gap(fontsize/80),
                                                   Expanded(
                                                    flex: 2,
                                                    child:  Expanded(
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
                                                                      .green.shade900,
                                                                ),
                                                              ),
                                                            ))
                                                   
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
                                    Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: fontsize / 100,
                                          right: fontsize / 100),
                                      child: ElevatedButton(
                                        onPressed: () async {
 // Fetch the students data from the Future
    _exportToExcel();
                                          },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color(0xFF006400), // Dark green
                                          padding: EdgeInsets.symmetric(
                                              vertical: fontsize / 80,
                                              horizontal: height / 42),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Export All Students',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: fontsize / 120,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
   List<Student> _filterDocuments(
    List<Student> documents,
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

    

    return filteredDocuments;
  }
}

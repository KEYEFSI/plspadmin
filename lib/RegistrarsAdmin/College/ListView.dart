import 'package:plsp/RegistrarsAdmin/College/CollegeCounterController.dart';
import 'package:plsp/RegistrarsAdmin/College/CollegeCounterModel.dart';


import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:gap/gap.dart';

class DocumentsListView extends StatefulWidget {
  final void Function(CollegeDocumentRequest) selectedStudent;
  const DocumentsListView({
    super.key,
    required List<Course> courses,
    required this.selectedStudent,
  }) : _courses = courses;

  final List<Course> _courses;

  @override
  _DocumentsListViewState createState() => _DocumentsListViewState();
}

class _DocumentsListViewState extends State<DocumentsListView> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  Course? _selectedCourse;
 late Future<List<CollegeDocumentRequest>> _documentsFuture;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

     _documentsFuture = _fetchAdminProfile(); 

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<List<CollegeDocumentRequest>> _fetchAdminProfile() async {
    try {
      final _adminController = AdminShowCollegeDocumentsController();
      return await _adminController.fetchCollegeDocuments();
    } catch (e) {
      throw Exception('Error fetching college documents: $e');
    }
  }

    
  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.width);
    final height = (MediaQuery.of(context).size.height);

    return Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.only(left: fontsize / 100.0, right: fontsize / 100.0, bottom: fontsize / 100.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              _buildSearchAndDropdown(fontsize, height),
              Gap(height / 100),
              Padding(
                padding: EdgeInsets.only(left: fontsize / 100.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Image',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Student Details',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Request Details',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
              ),
              Expanded(
                flex: 9,
                child: FutureBuilder<List<CollegeDocumentRequest>>(
                  future: _documentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Lottie.asset(
                                        'assets/Loading.json',
                                                  fit: BoxFit.contain,
                                                ),);
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No documents available.'));
                    }
                    final student = snapshot.data!;
                    final filteredDocuments = _filterDocuments(
                      student,
                      _searchController.text,
                      _selectedCourse,
                    );

                    if (filteredDocuments.isEmpty) {
                      return Center(
                        child: Lottie.asset(
                          'assets/Empty.json', // Replace with the path to your Lottie asset
                          width: 200,
                          height: 200,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final student = filteredDocuments[index];
                          final reqdate = student.requestDate;
                          final _reqdate = reqdate != null
                              ? DateFormat('EEE, MMM dd, yyyy')
                                  .format(reqdate.toLocal())
                              : 'Unknown';

                          final profileImageUrl = student.profileImage != null
                              ? '$Purl${student.profileImage}'
                              : null;

                          final documentNames = student.documents
                              .map((document) => document.documentName)
                              .join(', ');
                          bool isSelected = _selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                              widget.selectedStudent(student);
                            },
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  fontsize / 100,
                                  height / 100,
                                  fontsize / 100,
                                  0),
                              child: Container(
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(
                                            colors: [
                                              Colors.greenAccent,
                                              Colors.white
                                            ],
                                            stops: [0, 1],
                                            begin: AlignmentDirectional(0, -1),
                                            end: AlignmentDirectional(0, 1),
                                          )
                                        : null,
                                    color: isSelected ? null : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  height:
                                      isSelected ? height / 10 : height / 12,
                                  child: Row(children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          fontsize / 160, 0, fontsize / 64, 0),
                                      child: Container(
                                        width: fontsize / 19.2,
                                        height: height / 10.17,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.greenAccent,
                                              Colors.white
                                            ],
                                            stops: [0, 1],
                                            begin: AlignmentDirectional(0, -1),
                                            end: AlignmentDirectional(0, 1),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: profileImageUrl != null
                                                ? Image.network(
                                                    profileImageUrl,
                                                    width: 32,
                                                    height: height / 16.95,
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
                                            student.username,
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 120,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade900,
                                            ),
                                          ),
                                          Text(
                                            student.fullname,
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 120,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            student.program,
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 120,
                                              fontWeight: FontWeight.normal,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(_reqdate.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 120,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade900,
                                              )),
                                          Gap(height / 200),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: fontsize / 200.0,
                                                right: fontsize / 200),
                                            child: Text(documentNames,
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontsize / 140,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  List<CollegeDocumentRequest> _filterDocuments(
    List<CollegeDocumentRequest> documents,
    String searchQuery,
    Course? selectedCourse,
  ) {
    var filteredDocuments = documents;

    if (searchQuery.isNotEmpty) {
      filteredDocuments = filteredDocuments.where((student) {
        final username = student.username.toLowerCase();
        final fullname = student.fullname.toLowerCase();
        return username.contains(searchQuery.toLowerCase()) ||
            fullname.contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (selectedCourse != null) {
      filteredDocuments = filteredDocuments
          .where((student) => student.program == selectedCourse.program)
          .toList();
    }

    return filteredDocuments;
  }

  // Widget for search bar and dropdown
  Widget _buildSearchAndDropdown(double fontsize, double height) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(
            left: fontsize / 100.0,
            top: height / 85,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  'All Students',
                  style: GoogleFonts.poppins(
                    fontSize: fontsize / 60,
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: height / 85.0),
                  child: TextFormField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 100,
                        color: Theme.of(context).primaryColor,
                      ),
                      hintText: 'Student Name/ ID',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: fontsize / 100,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).hintColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      prefixIcon: Icon(
                        FontAwesome.search,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: fontsize / 80,
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: height / 85.0,
                    left: fontsize / 160,
                    right: fontsize / 80,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Course>(
                        value: _selectedCourse,
                        hint: Text(
                          'Courses',
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 100,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (Course? newValue) {
                          setState(() {
                            _selectedCourse = newValue;
                          });
                        },
                        dropdownColor: Colors.white,
                        items: widget._courses
                            .map<DropdownMenuItem<Course>>((Course course) {
                          return DropdownMenuItem<Course>(
                            value: course,
                            child: Text(
                              '${course.acronym}',
                              style: GoogleFonts.poppins(
                                fontSize: fontsize / 80,
                                color: Colors.green.shade900,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
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

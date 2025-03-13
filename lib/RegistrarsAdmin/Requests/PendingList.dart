import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/RegistrarsAdmin/Requests/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Requests/Model.dart';
import 'package:plsp/RegistrarsAdmin/Requests/ViewRequestPage.dart';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PendingList extends StatefulWidget {
  final String username;

  const PendingList({
    super.key,
    required this.fontsize,
    required this.username,
  });

  final double fontsize;

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {
  final ProgramWindowController controller = ProgramWindowController();
  late PendingDocumentRequestsController _controller;

  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  int? _selectedIndex;
  String? _selectedCourse;
  PendingDocumentRequest? _selectedStudent;

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

  List<PendingDocumentRequest> _paginate(
      List<PendingDocumentRequest> students) {
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

  @override
  void initState() {
    super.initState();
    controller.startFetching(widget.username);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _controller = PendingDocumentRequestsController();
    _controller.startFetching(widget.username);
  }

  @override
  void dispose() {
    controller.stopFetching();
    _controller.dispose();
    super.dispose();
  }

  void _showStudentDetails(PendingDocumentRequest student) {
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
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.width);
    final height = (MediaQuery.of(context).size.height);

    return Padding(
      padding: EdgeInsets.only(right: widget.fontsize / 120.0),
      child: StreamBuilder<ProgramWindowModel?>(
          stream: controller.programStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widget.fontsize / 120),
                  ),
                  child: Text("No data available"));
            }

            final programWindowModel = snapshot.data!;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.fontsize / 120),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: fontsize / 100.0,
                            top: height / 85,
                          ),
                          child: Row(children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Paid Requests',
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize / 80,
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
                                  onChanged: _updateSearchQuery,
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
                                    fontSize: fontsize / 100,
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: height / 85.0,
                                  left: fontsize / 400,
                                ),
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value: _selectedCourse,
                                        hint: Text(
                                          'Program',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontsize / 100,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCourse = newValue;
                                          });
                                        },
                                        icon: Icon(
                                          Ionicons.funnel,
                                          color: Colors.green.shade900,
                                        ),
                                        focusColor: Colors.white,
                                        dropdownColor: Colors.white,
                                        items: programWindowModel.programs
                                            .map((program) {
                                          return DropdownMenuItem<String>(
                                            value: program,
                                            child: Text(
                                              program,
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 120,
                                                color: Colors.green.shade900,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    )),
                              ),
                            ),
                          ]),
                        ),
                        Expanded(
                            child: StreamBuilder<List<PendingDocumentRequest>>(
                                stream: _controller.pendingRequestsStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Lottie.asset('assets/Empty.json',
                                        fit: BoxFit.contain);
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Lottie.asset('assets/Empty.json',
                                        fit: BoxFit.contain);
                                  }

                                  final student = snapshot.data!;
                                  final filteredDocuments = _filterDocuments(
                                    student,
                                    _searchController.text,
                                    _selectedCourse,
                                  );

                                  final totalPages = _calculateTotalPages(
                                      filteredDocuments.length);
                                  final paginatedStudents =
                                      _paginate(filteredDocuments);

                                  if (filteredDocuments.isEmpty) {
                                    return Center(
                                      child: Lottie.asset(
                                        'assets/Empty.json', // Replace with the path to your Lottie asset
                                        width: 200,
                                        height: 200,
                                      ),
                                    );
                                  }
                                  return Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Gap(fontsize / 10),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Student Details',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontsize / 80,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Document Details',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontsize / 80,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Pages:',
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 120,
                                                color: Colors.green.shade900,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (totalPages > 1)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Left Arrow
                                                    if (currentPage > 1)
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            currentPage--;
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.arrow_left,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    // Page Numbers
                                                    ...List.generate(
                                                      totalPages > 5
                                                          ? 5
                                                          : totalPages,
                                                      (index) {
                                                        int pageNumber;

                                                        if (totalPages <= 5) {
                                                          pageNumber =
                                                              index + 1;
                                                        } else if (currentPage <=
                                                            3) {
                                                          pageNumber =
                                                              index + 1;
                                                        } else if (currentPage >=
                                                            totalPages - 2) {
                                                          pageNumber =
                                                              totalPages -
                                                                  4 +
                                                                  index;
                                                        } else {
                                                          pageNumber =
                                                              currentPage -
                                                                  2 +
                                                                  index;
                                                        }

                                                        return GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              currentPage =
                                                                  pageNumber;
                                                            });
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        4.0),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: currentPage ==
                                                                      pageNumber
                                                                  ? Colors.green
                                                                      .shade900
                                                                  : Colors.grey
                                                                      .shade300,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Text(
                                                              '$pageNumber',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        140,
                                                                fontWeight: currentPage ==
                                                                        pageNumber
                                                                    ? FontWeight
                                                                        .normal
                                                                    : FontWeight
                                                                        .bold,
                                                                color: currentPage ==
                                                                        pageNumber
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    if (currentPage <
                                                        totalPages)
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            currentPage++;
                                                          });
                                                        },
                                                        child: Icon(
                                                            Icons.arrow_right,
                                                            color:
                                                                Colors.black),
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
                                            children: paginatedStudents
                                                .map((student) {
                                              final index = paginatedStudents
                                                  .indexOf(student);
                                              final isHovered =
                                                  hoveredIndex == index;

                                              final isSelected =
                                                  _selectedIndex == index;

                                              final reqdate = student.date;
                                              final _reqdate = reqdate != null
                                                  ? DateFormat(
                                                          'EEE, MMM dd, yyyy')
                                                      .format(reqdate.toLocal())
                                                  : 'Unknown';

                                              final profileImageUrl = student
                                                          .profileImage !=
                                                      null
                                                  ? '$Purl${student.profileImage}'
                                                  : null;

                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedIndex = index;
                                                    _selectedStudent =
                                                        student; // Set the selected index on tap
                                                  });
                                                  _showStudentDetails(student);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: isSelected
                                                        ? LinearGradient(
                                                            colors: [
                                                              Colors.green
                                                                  .shade300,
                                                              Colors.white
                                                            ],
                                                            stops: [0, 1],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          )
                                                        : null,
                                                    color: isSelected
                                                        ? null
                                                        : Colors.white,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    fontsize /
                                                                        160,
                                                                    height /
                                                                        160,
                                                                    fontsize /
                                                                        64,
                                                                    height /
                                                                        160),
                                                            child: Container(
                                                              width:
                                                                  fontsize / 20,
                                                              height:
                                                                  height / 12,
                                                              decoration:
                                                                  BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors.green
                                                                        .shade900,
                                                                    Colors.white
                                                                  ],
                                                                  stops: [0, 1],
                                                                  begin: Alignment
                                                                      .centerLeft, // Start at the top
                                                                  end: Alignment
                                                                      .centerRight,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        3.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: profileImageUrl !=
                                                                          null
                                                                      ? Image
                                                                          .network(
                                                                          profileImageUrl,
                                                                          width:
                                                                              32,
                                                                          height:
                                                                              height / 16.95,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          headers:
                                                                              kHeader,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .person,
                                                                          size:
                                                                              50,
                                                                        ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  student
                                                                      .username
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  student
                                                                      .fullname
                                                                      .toString(),
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
                                                                  ),
                                                                ),
                                                                Text(
                                                                  student
                                                                      .program
                                                                      .toString(),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          VerticalDivider(
                                                            thickness: 1,
                                                            indent:
                                                                height / 100,
                                                            endIndent:
                                                                height / 80,
                                                            color: Colors
                                                                .green.shade900,
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
                                                                Gap(height /
                                                                    200),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: fontsize /
                                                                          200.0,
                                                                      right: fontsize /
                                                                          200),
                                                                  child: Text(
                                                                      student
                                                                          .documentName,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            fontsize /
                                                                                120,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: fontsize /
                                                                          200.0,
                                                                      right: fontsize /
                                                                          200),
                                                                  child: Text(
                                                                      student
                                                                          .stampCode,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            fontsize /
                                                                                120,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: fontsize /
                                                                          200.0,
                                                                      right: fontsize /
                                                                          200),
                                                                  child: Text(
                                                                      _reqdate
                                                                          .toString(),
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        fontSize:
                                                                            fontsize /
                                                                                130,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
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
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                  _selectedStudent != null
                      ? Expanded(
                          child: ViewRequestPage(
                            selectedStudent: _selectedStudent,
                            fontsize: fontsize,
                            height: height,
                            widget: widget,
                            onClearSelection: _clearSelectedStudent,
                            window: programWindowModel.windowName,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          }),
    );
  }

  List<PendingDocumentRequest> _filterDocuments(
    List<PendingDocumentRequest> documents,
    String searchQuery,
    String? selectedCourse,
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
          .where((student) => student.program == selectedCourse)
          .toList();
    }

    return filteredDocuments;
  }
}

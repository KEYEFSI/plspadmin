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
  
 
     final DeleteStudentController controller = DeleteStudentController();
     late ISStudentController _controller = ISStudentController();
 

  final _Rejcontroller = RejectStudentController();
  final _reasonController = TextEditingController();

  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10;
  int hoveredIndex = -1;
  int hoveredIndexes = -1;
 

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      currentPage = 1; // Reset to the first page on a new search
    });
  }

  List<ISStudent> _paginate(List<ISStudent> students) {
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
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(fontsize / 100.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ISStudent>>(
                stream: _controller.studentsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final allStudents = snapshot.data!;
                    final filteredStudents = allStudents.where((student) {
                      final fullname = student.fullname?.toLowerCase() ?? '';
                      final username = student.username?.toLowerCase() ?? '';
                      final email = student.email?.toLowerCase() ?? '';
                      return fullname.contains(searchQuery) ||
                          username.contains(searchQuery) ||
                          email.contains(searchQuery);
                    }).toList();

                    final totalPages =
                        _calculateTotalPages(filteredStudents.length);
                    final paginatedStudents = _paginate(filteredStudents);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: _updateSearchQuery,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search by name, username, or email',
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
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    filled: false,
                                    fillColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    prefixIcon: Icon(
                                      FontAwesome.search,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 137,
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                        child: Icon(Icons.arrow_left,
                                            color: Colors.black),
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
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.0),
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: currentPage == pageNumber
                                                  ? Colors.green.shade900
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '$pageNumber',
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 140,
                                                fontWeight:
                                                    currentPage == pageNumber
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

                                    // Right Arrow
                                    if (currentPage < totalPages)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            currentPage++;
                                          });
                                        },
                                        child: Icon(Icons.arrow_right,
                                            color: Colors.black),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                          height: 8,
                          color: Colors.green.shade900,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text('Fullname',
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 140,
                                    color: Colors.grey,
                                  )),
                            ),
                            Gap(fontsize / 120),
                            Expanded(
                              child: Text(
                                'Student No.',
                                style: GoogleFonts.poppins(
                                  fontSize: fontsize / 140,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Gap(fontsize / 120),
                            Expanded(
                              flex: 2,
                              child: Text('Email',
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 140,
                                    color: Colors.grey,
                                  )),
                            ),
                            Gap(fontsize / 120),
                            Expanded(
                              flex: 2,
                              child: Text('Program',
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 140,
                                    color: Colors.grey,
                                  )),
                            ),
                            Gap(fontsize / 120),
                            Expanded(
                              flex: 2,
                              child: Text('Address',
                                  style: GoogleFonts.poppins(
                                    fontSize: fontsize / 140,
                                    color: Colors.grey,
                                  )),
                            ),
                            Expanded(child: Text(''))
                          ],
                        ),
                        Column(
                          children: paginatedStudents.map((student) {
                            final index = paginatedStudents.indexOf(student);
                            final isHovered = hoveredIndex == index;

                            final isHover = hoveredIndexes == index;
                            return Container(
                              decoration: BoxDecoration(
                                color: isHover
                                    ? Colors.red.shade100
                                    : isHovered
                                        ? Colors.green.shade100
                                        : Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(student.fullname ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: fontsize / 140,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Gap(fontsize / 120),
                                      Expanded(
                                        child: Text(student.username ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 140,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Gap(fontsize / 120),
                                      Expanded(
                                        flex: 2,
                                        child: Text(student.email ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 140,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Gap(fontsize / 120),
                                      Expanded(
                                        flex: 2,
                                        child: Text(student.program ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 140,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Gap(fontsize / 120),
                                      Expanded(
                                        flex: 2,
                                        child: Text(student.address ?? '',
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 140,
                                              color: Colors.black,
                                            )),
                                      ),
                                      Gap(fontsize / 120),
                                      MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            hoveredIndex = index;
                                            hoveredIndexes = -1;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            hoveredIndex = -1;
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            _approveStudent(
                                                student.username ?? '');
                                            print(
                                                'Approve ${student.username}');
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: fontsize / 160,
                                                  vertical: height / 180),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Icon(
                                                      FontAwesome.check_square,
                                                      color: Colors.white,
                                                      size: fontsize / 60,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "APPROVE",
                                                    style: TextStyle(
                                                      fontSize: fontsize / 160,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Gap(height / 160),
                                      MouseRegion(
                                        onEnter: (_) {
                                          setState(() {
                                            hoveredIndexes = index;
                                            hoveredIndex = -1;
                                          });
                                        },
                                        onExit: (_) {
                                          setState(() {
                                            hoveredIndexes = -1;
                                          });
                                        },
                                        child: GestureDetector(
                                          onTap: () {
                                            _showReasonDialog(
                                                student.username!);
                                            print(
                                                'fontsiz ${student.username}');
                                          },
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: fontsize / 160,
                                                  vertical: height / 180),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade900,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.contain,
                                                    child: Icon(
                                                      FontAwesome.window_close,
                                                      color: Colors.white,
                                                      size: fontsize / 60,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: fontsize / 200),
                                                  Text(
                                                    "REJECT",
                                                    style: TextStyle(
                                                      fontSize: fontsize / 160,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Gap(height / 200),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No data found"));
                  }
                },
              ),
            ),
            Gap(height / 20)
          ],
        ),
      ),
    );
  }

  void _approveStudent(String username) async {
    final response = await controller.deleteStudent(username);

    if (response['success'] == true) {
      // Show success message
      _showSuccessMessage('Student "$username" approved successfully!');
    } else {
      // Show error message
      _showErrorMessage(
          'Failed to approve student "$username": ${response['message']}');
    }
  }

  void _rejectStudent(
      BuildContext context, String username, String reason) async {
    final request = RejectStudentRequest(
      username: username,
      reason: reason,
    );

    final response = await _Rejcontroller.rejectStudent(request);
    _showSuccessMessage(response.message);
  }

  void _showReasonDialog(String username) {
    final reasonController = TextEditingController();
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Entypo.squared_cross, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Confirm Request Rejection',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize / 60,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Would you provide various reason to reject the request.',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: fontsize / 100,
                    color: Colors.black,
                  )),
              Gap(height / 40),
              TextFormField(
                maxLines: 5,
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: fontsize / 80,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.w500,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  isDense: true,
                ),
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize / 106),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid reasons';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(reasonController.text);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((reason) {
      if (reason != null && reason.isNotEmpty) {
        _rejectStudent(context, username, reason);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reason is required to reject the document.')),
        );
      }
    });
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
                Lottie.asset('assets/success.json', fit: BoxFit.contain),
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
}

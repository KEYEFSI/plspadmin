import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/WindowandPrograms/Controller.dart';
import 'package:plsp/SuperAdminRegistrar/WindowandPrograms/Model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProgramState extends StatefulWidget {
  const ProgramState({
    super.key,
  });

  @override
  State<ProgramState> createState() => _ProgramStateState();
}

class _ProgramStateState extends State<ProgramState> {
  late final CourseController _controller;
  late TextEditingController programController;
  late TextEditingController acronymController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int? hoveredIndex;
  @override
  void initState() {
    super.initState();
    _controller = CourseController();
  }

  @override
  void dispose() {
    _controller.dispose();
    programController.dispose();
    acronymController.dispose();
    super.dispose();
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
                Lottie.asset('assets/error.json', fit: BoxFit.contain),
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


  Future<void> _submitCourse() async {
   
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      final course = CourseModel(
        acronym: acronymController.text,
        program: programController.text,
      );

      final success = await _controller.addCourse(course);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _showSuccessMessage("Program added successfully!");
        Navigator.pop(context); // Go back to the previous screen
      } else {
      _showErrorMessage("Failed to add Program");
      }
    }
  }

  void _addprogram() {
    programController = TextEditingController();
    acronymController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final fontsize = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return AlertDialog(
          content: Container(
            width: fontsize / 2,
            child: Form(
              key: _formKey, // Use the form key here
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Add Program",
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 60,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                      )),
                  Divider(
                      thickness: 1, height: 1, color: Colors.green.shade900),
                  Gap(height / 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: programController,
                      decoration: InputDecoration(
                        labelText: 'Program Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize / 106,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize / 106),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a program name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(height / 60),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: acronymController,
                      decoration: InputDecoration(
                        labelText: 'Acronym',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize / 106,
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).hintColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize / 106),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an acronym';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: fontsize / 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              _submitCourse();
                            
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 20,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade900,
                                    Colors.greenAccent.shade700,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MaterialIcons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Program',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontsize / 106,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
        );
      },
    );
  }

  void _confirmDelete(String acronym) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
          final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
      
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Row(
            children: [
              Icon(Icons.exit_to_app, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Confirm Delete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize/60,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this program?',
            style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fontsize/120,
                  color: Colors.black,)
          ),
           actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Cancel',
               style: GoogleFonts.poppins(
                                    fontSize: fontsize / 80,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),),
            ),
            TextButton(
              onPressed: () {
                 Navigator.of(context).pop(); 
                _deleteCourse(acronym); 
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Delete',
               style: GoogleFonts.poppins(
                                    fontSize: fontsize / 80,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),),
            ),
          ],
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop(); // Close the dialog
            //     _deleteCourse(acronym); // Proceed with deletion
            //   },
            //   child: Text("Delete", style: TextStyle(color: Colors.red)),
            // ),
        );
      }
          
    );
    
      
    
  }

  void _deleteCourse(String acronym) async {
    try {
      final success = await _controller.deleteCourse(acronym);
      if (success) {
       _showSuccessMessage('Program deleted successfully');
      } else {
       _showErrorMessage('Failed to delete program');
      }
    } catch (e) {
    _showErrorMessage('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
            right: fontsize / 100.0,
            top: fontsize / 100.0,
            bottom: fontsize / 100.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(height / 101),
              Text(
                'Programs',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 60,
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0,
                ),
              ),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.green.shade900,
              ),
              Expanded(
                child: StreamBuilder<List<CourseModel>>(
                    stream: _controller.coursesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Lottie.asset('assets/error.json', fit: BoxFit.contain);
                      } else {
                        final courses = snapshot.data!;
                        return ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            final isHovered = hoveredIndex == index;
                            return MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    hoveredIndex = index;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    hoveredIndex = null;
                                  });
                                },
                                child: Transform(
                                    transform: isHovered
                                        ? (Matrix4.identity()
                                          ..scale(1.01)) // Scale up on hover
                                        : Matrix4.identity(),
                                    alignment: Alignment.center,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: fontsize / 100.0,
                                            right: fontsize / 100.0,
                                            top: height / 100),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.green.shade300,
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Gap(fontsize / 60),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        course.acronym,
                                                        style: GoogleFonts
                                                            .poppins(
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Text(
                                                        course.program,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Tooltip(
                                                    message: 'Remove Program',
                                                    textStyle:
                                                        GoogleFonts.poppins(
                                                            color: Colors.white,
                                                            fontSize:
                                                                fontsize / 100,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.red.shade900,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14)),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _confirmDelete(
                                                              course.acronym),
                                                      child: Icon(
                                                        AntDesign.minuscircle,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    )));
                          },
                        );
                      }
                    }),
              ),
              Align(
                alignment: const Alignment(1, 0),
                child: Tooltip(
                  message: 'Add New Program ',
                  textStyle: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: fontsize / 100,
                      fontWeight: FontWeight.bold),
                  decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(14)),
                  child: Container(
                    width: fontsize / 20,
                    height: fontsize / 20,
                    child: GestureDetector(
                      onTap: () => _addprogram(),
                      child: Lottie.asset(
                        'assets/add_doc.json',
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/WindowandPrograms/Controller.dart';
import 'package:plsp/SuperAdminRegistrar/WindowandPrograms/Model.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Windows extends StatefulWidget {
  const Windows({
    super.key,
    required this.fontsize,
  });

  final double fontsize;

  @override
  State<Windows> createState() => _WindowsState();
}

class _WindowsState extends State<Windows> {
  int? hoveredIndex;

  final WindowController _controller = WindowController();
  WindowCreate? _newWindow;

  final WindowsController controller = WindowsController();

  final UnselectedProgramController _programcontroller =
      UnselectedProgramController();
  ProgramController programController = ProgramController();

  final DeleteProgramController deleteProgramController =
      DeleteProgramController();

  @override
  void initState() {
    super.initState();
    controller.startAutoRefresh(); // Start auto-refresh
  }

  @override
  void dispose() {
    controller.stopAutoRefresh(); // Stop auto-refresh
    controller.dispose();

    super.dispose();
  }

  void _createWindow() async {
    final createdWindow = await _controller.createWindow();
    if (createdWindow != null) {
      setState(() {
        _newWindow = createdWindow;
      });
      _showSuccessMessage(
          "Window ${createdWindow.windowName} created successfully!");
    } else {
      _showSuccessMessage("Failed to create window.");
    }
  }

  void _showAddProgramDialog(
      BuildContext context,
      String windowName,
      UnselectedProgramController controller,
      ProgramController programController) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            child: Column(
              children: [
                Text(
                  'Add Program to Window $windowName',
                  style: GoogleFonts.poppins(
                      color: Colors.green,
                      fontSize: fontsize / 80,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  thickness: 1,
                )
              ],
            ),
          ),
          content: SizedBox(
            height: 300,
            width: fontsize / 2, // Constrain height to avoid layout issues
            child: StreamBuilder<List<UnselectedProgram>>(
              stream: controller
                  .getUnselectedProgramsStream(), // Use the controller's stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Lottie.asset('assets/error.json', fit: BoxFit.contain);
                }

                final programs = snapshot.data!;
                return ListView.builder(
                  itemCount: programs.length,
                  itemBuilder: (context, index) {
                    final program = programs[index];

                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Gap(fontsize / 80),
                          Expanded(
                            child: Text(
                              (program.program ?? 'Unnamed Program'),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: fontsize / 100,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                              message: 'Add Program',
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: fontsize / 100,
                                  fontWeight: FontWeight.bold),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade900,
                                  borderRadius: BorderRadius.circular(14)),
                              child: GestureDetector(
                                onTap: () async {
                                  int windowNameAsInt = int.parse(windowName);
                                  bool success = await programController
                                      .addProgram(AddProgramRequest(
                                    windowName: windowNameAsInt,
                                    program: program.program ?? '',
                                  ));

                                  if (success) {
                                    _showSuccessMessage(
                                        'Program added successfully to Window ${windowNameAsInt}');
                                  } else {
                                    _showErrorMessage('Failed to add program.');
                                  }
                                  ;
                                },
                                child: Icon(
                                  MaterialCommunityIcons.plus,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteDialog(int Window, String Program) {
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
                  fontSize: fontsize / 60,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text('Are you sure you want to delete this document?',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontsize / 120,
                color: Colors.black,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
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
                _deleteProgram(Window, Program);
                Navigator.of(context).pop();
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
    );
  }

  Future<void> _deleteProgram(int Window, String Program) async {
    final windowName = Window.toString();
    final program = Program;

    if (windowName.isEmpty || program.isEmpty) {
      _showErrorMessage('Error deleting Program');
      return;
    }

    try {
      // Call the delete API
      final response =
          await deleteProgramController.deleteProgram(windowName, program);

      // Show success message in SnackBar
      _showSuccessMessage(response.message);
    } catch (error) {
      // Show error message in SnackBar
      _showErrorMessage('$error');
    } finally {
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;

    return Expanded(
        flex: 2,
        child: Padding(
          padding: EdgeInsets.all(fontsize / 100.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap(height / 101),
                Text(
                  'Windows',
                  style: GoogleFonts.poppins(
                    fontSize: fontsize / 60,
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
                Divider(thickness: 1, height: 1, color: Colors.green.shade900),
                Expanded(
                  child: StreamBuilder<List<Window>>(
                      stream: controller.windowsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final windows = snapshot.data!;

                          if (windows.isEmpty) {
                            return Center(child: Text('No data available'));
                          }
                          return Padding(
                            padding: EdgeInsets.only(
                                left: fontsize / 100.0,
                                right: fontsize / 100.0,
                                bottom: fontsize / 100.0,
                                top: fontsize / 100),
                            child: Builder(builder: (context) {
                              return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: height / 2.2,
                                    maxCrossAxisExtent: fontsize / 4,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: windows.length,
                                  itemBuilder: (context, index) {
                                    final window = windows[index];
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
                                        child: Stack(children: [
                                          Transform(
                                              transform: isHovered
                                                  ? (Matrix4.identity()
                                                    ..scale(
                                                        1.01)) // Scale up on hover
                                                  : Matrix4.identity(),
                                              alignment: Alignment.center,
                                              child: Card(
                                                elevation: 5,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: fontsize /
                                                                    100.0,
                                                                right:
                                                                    fontsize /
                                                                        100.0,
                                                                bottom:
                                                                    fontsize /
                                                                        100.0,
                                                                top: fontsize /
                                                                    100),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                'Window ${window.windowName}',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize:
                                                                      fontsize /
                                                                          80,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            Tooltip(
                                                              message:
                                                                  'Remove Window',
                                                              textStyle: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      fontsize /
                                                                          100,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .red
                                                                      .shade900,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              14)),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  final confirm =
                                                                      await showDialog<
                                                                          bool>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(15.0),
                                                                        ),
                                                                        title:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.exit_to_app,
                                                                                color: Colors.red),
                                                                            SizedBox(width: 10),
                                                                            Text(
                                                                              'Confirm Delete',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: fontsize / 60,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        content: Text(
                                                                            'Are you sure you want to delete "${window.windowName}"?',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: fontsize / 120,
                                                                              color: Colors.black,
                                                                            )),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(false),
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              foregroundColor: Colors.grey,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Cancel',
                                                                              style: GoogleFonts.poppins(
                                                                                fontSize: fontsize / 80,
                                                                                color: Colors.black87,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          TextButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(true),
                                                                            style:
                                                                                TextButton.styleFrom(
                                                                              foregroundColor: Colors.red,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                Text(
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
                                                                  );

                                                                  if (confirm ==
                                                                      true) {
                                                                    // Proceed with deletion
                                                                    try {
                                                                      await controller
                                                                          .deleteWindow(
                                                                              '${window.windowName}');
                                                                      _showSuccessMessage(
                                                                          'Window ${window.windowName} deleted successfully');
                                                                    } catch (e) {
                                                                      _showErrorMessage(
                                                                          'Failed to delete window: $e');
                                                                    }
                                                                  }
                                                                },
                                                                child: Icon(
                                                                  MaterialCommunityIcons
                                                                      .delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 1,
                                                        height: 1,
                                                        color: Colors
                                                            .green.shade900,
                                                      ),
                                                      Gap(height / 80),
                                                      Expanded(
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: window
                                                                      .programs
                                                                      ?.length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          programIndex) {
                                                                    final program =
                                                                        window.programs?[
                                                                            programIndex];
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left: fontsize /
                                                                              100.0,
                                                                          right: fontsize /
                                                                              100.0,
                                                                          top: height /
                                                                              100),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius: BorderRadius.circular(14)),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Gap(fontsize /
                                                                                160),
                                                                            Expanded(
                                                                              child: Text(
                                                                                program!,
                                                                                style: GoogleFonts.poppins(color: Colors.black, fontSize: fontsize / 120, fontWeight: FontWeight.w500, letterSpacing: 0),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Tooltip(
                                                                                message: 'Remove Program to Window ${window.windowName}',
                                                                                textStyle: GoogleFonts.poppins(color: Colors.white, fontSize: fontsize / 100, fontWeight: FontWeight.bold),
                                                                                decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(14)),
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    showDeleteDialog(window.windowName, program);
                                                                                  },
                                                                                  child: Icon(
                                                                                    AntDesign.minuscircle,
                                                                                    color: Colors.red,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  })),
                                                      Align(
                                                        alignment:
                                                            const Alignment(
                                                                1, 0),
                                                        child: Tooltip(
                                                          message:
                                                              'Add Program to Window ${window.windowName}',
                                                          textStyle: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      fontsize /
                                                                          100,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14)),
                                                          child: Container(
                                                            width:
                                                                fontsize / 30,
                                                            height:
                                                                fontsize / 30,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                _showAddProgramDialog(
                                                                    context,
                                                                    '${window.windowName}',
                                                                    _programcontroller,
                                                                    programController);
                                                              },
                                                              child:
                                                                  Lottie.asset(
                                                                'assets/add_doc.json',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                              ))
                                        ]));
                                  });
                            }),
                          );
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      }),
                ),
                Align(
                  alignment: const Alignment(1, 0),
                  child: Tooltip(
                    message: 'Add Window',
                    textStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold),
                    decoration: BoxDecoration(
                        color: Colors.green.shade900,
                        borderRadius: BorderRadius.circular(14)),
                    child: Container(
                      width: fontsize / 20,
                      height: fontsize / 20,
                      child: GestureDetector(
                        onTap: _createWindow,
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
        ));
  }
}

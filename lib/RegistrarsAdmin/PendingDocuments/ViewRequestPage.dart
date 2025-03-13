import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Controller.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/Model.dart';
import 'package:plsp/RegistrarsAdmin/PendingDocuments/PendingList.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ViewRequestPage extends StatefulWidget {
  const ViewRequestPage({
    super.key,
    required PendingDocumentRequest? selectedStudent,
    required this.fontsize,
    required this.height,
    required this.widget,
    required this.onClearSelection,
  }) : _selectedStudent = selectedStudent;

  final PendingDocumentRequest? _selectedStudent;
  final double fontsize;
  final double height;
  final PendingList widget;

  final VoidCallback onClearSelection;

  @override
  State<ViewRequestPage> createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  late TextEditingController _priceController;
  late TextEditingController _requirements1Controller;
  late TextEditingController _requirements2Controller;
  final TextEditingController _documentaryprice = TextEditingController();

  final TextEditingController _documentaryCode = TextEditingController();

  final StampController _stampController = StampController();

  late DocumentController _controller;
  final _formKey = GlobalKey<FormState>();
  final controller = DocumentRequestController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _controller = DocumentController();

    _controller.fetchDocument(widget._selectedStudent!.documentName);

    _stampController.fetchStamps();
  }

  @override
  void didUpdateWidget(ViewRequestPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._selectedStudent!.username !=
        widget._selectedStudent!.username) {
      _controller.fetchDocument(widget._selectedStudent!.documentName);
    }

    _initializeControllers();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _initializeControllers() {
    _requirements1Controller =
        TextEditingController(text: widget._selectedStudent!.requirements1);
    _requirements2Controller =
        TextEditingController(text: widget._selectedStudent!.requirements2);
    _priceController = TextEditingController(
        text: widget._selectedStudent!.price.toStringAsFixed(2));
  }

  void _updateRequest() async {
    if (_formKey.currentState!.validate()) {
      final request = DocumentRequest(
        username: widget._selectedStudent!.username,
        documentName: widget._selectedStudent!.documentName,
        date: widget._selectedStudent!.date,
        fullname: widget._selectedStudent!.fullname,
        program: widget._selectedStudent!.program,
        price: _priceController.text.isEmpty
            ? null
            : double.tryParse(_priceController.text),
        requirements1: _requirements1Controller.text.isEmpty
            ? null
            : _requirements1Controller.text,
        requirements2: _requirements2Controller.text.isEmpty
            ? null
            : _requirements2Controller.text,
        email: widget._selectedStudent!.email,
        stampcode:
            widget._selectedStudent!.stamp == 0 ? null : _documentaryCode.text,
      );

      final success = await controller.updateDocumentRequest(request);

      if (success) {
        _showSuccessMessage(
            "Document request has been approved and updated successfully!");
        widget.onClearSelection();
      } else {
        _showErrorMessage("Failed to update document request.");
      }
    }
  }

  void _showReasonDialog() {
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
        _submit(reason);
      } else {
        _showErrorMessage(
            'Please atleast give a reson to reject their request');
      }
    });
  }

  void _showConfirmation() {
    final reasonController = TextEditingController();
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Entypo.squared_cross, color: Colors.green),
              SizedBox(width: 10),
              Text(
                'Confirm Approve and Update',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize / 60,
                  color: Colors.green.shade900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to approve the data?',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: fontsize / 100,
                    color: Colors.black,
                  )),
              Gap(height / 40),
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
                _updateRequest();
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Approve',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _submit(String reason) async {
    if (_formKey.currentState!.validate()) {
      final controller = RejectDocumentController();
      final request = RejectDocumentRequest(
        username: widget._selectedStudent!.username,
        documentName: widget._selectedStudent!.documentName,
        date: widget._selectedStudent!.date,
        email: widget._selectedStudent!.email,
        reason: reason,
      );

      print(jsonEncode(request.toJson()));
      final success = await controller.rejectDocument(request);

      if (success) {
        _showSuccessMessage('Document rejected successfully!');
        widget.onClearSelection();
      } else {
        _showErrorMessage('Failed to reject the document.');
      }
    } else {
      _showErrorMessage('Please complete all fields and select a date.');
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
    return Builder(builder: (context) {
      final fontsize = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

      final profileImageUrl = widget._selectedStudent!.profileImage != null
          ? '$Purl${widget._selectedStudent!.profileImage}'
          : null;

      return Form(
        key: _formKey,
        child: StreamBuilder<Document?>(
            stream: _controller.documentStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching document details.'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No document details available.'));
              } else {
                final document = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.all(widget.fontsize / 80.0),
                  child: Card(
                    elevation: 11,
                    shadowColor: Colors.green,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(widget.fontsize / 100)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.fontsize / 80.0,
                            vertical: widget.height / 60),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'Request Details',
                                  style: GoogleFonts.poppins(
                                    color: Colors.green.shade900,
                                    fontSize: widget.widget.fontsize / 80,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.green.shade900,
                                height: 1,
                              ),
                              // Text(
                              //   'Student Details: ',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: widget.fontsize / 100,
                              //     color: Colors.grey.shade500,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),

                              // Row(
                              //   children: [
                              //     // Container(
                              //     //   width: widget.fontsize /
                              //     //       20, // Adjusted size for the outer container
                              //     //   height: widget.fontsize /
                              //     //       20, // Ensure it is a square
                              //     //   decoration: BoxDecoration(
                              //     //     gradient: LinearGradient(
                              //     //       colors: [
                              //     //         Colors.green.shade900,
                              //     //         Colors.greenAccent,
                              //     //       ],
                              //     //       stops: [0, 1],
                              //     //       begin: Alignment.centerLeft,
                              //     //       end: Alignment.centerRight,
                              //     //     ),
                              //     //     shape: BoxShape.circle,
                              //     //   ),
                              //     //   child: Padding(
                              //     //     padding: const EdgeInsets.all(
                              //     //         5.0), // Adjusted padding for better scaling
                              //     //     child: Container(
                              //     //       width: widget.fontsize /
                              //     //           20, // Adjusted size for the inner container
                              //     //       height: widget.fontsize /
                              //     //           20, // Ensure it is a square
                              //     //       decoration: BoxDecoration(
                              //     //         shape: BoxShape.circle,
                              //     //         image: profileImageUrl != null &&
                              //     //                 profileImageUrl.isNotEmpty
                              //     //             ? DecorationImage(
                              //     //                 image: NetworkImage(
                              //     //                   profileImageUrl,
                              //     //                   headers: kHeader,
                              //     //                 ),
                              //     //                 fit: BoxFit
                              //     //                     .cover, // Ensures the image covers the entire circle
                              //     //               )
                              //     //             : null, // If no image URL, decoration will have a fallback
                              //     //         color: Colors.grey[
                              //     //             300], // Placeholder background color
                              //     //       ),
                              //     //       child: profileImageUrl == null ||
                              //     //               profileImageUrl.isEmpty
                              //     //           ? Icon(
                              //     //               Icons.person,
                              //     //               size: widget.fontsize /
                              //     //                   15, // Adjusted icon size to match scaling
                              //     //               color: Colors.grey[
                              //     //                   700], // Icon color for the placeholder
                              //     //             )
                              //     //           : null, // If image exists, child is null
                              //     //     ),
                              //     //   ),
                              //     // ),
                              //     // Gap(widget.fontsize / 120),
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           FittedBox(
                              //             fit: BoxFit.contain,
                              //             child: Text(
                              //               widget._selectedStudent!.username,
                              //               style: GoogleFonts.poppins(
                              //                 fontSize: widget.fontsize / 90,
                              //                 color: Colors.green.shade900,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //             ),
                              //           ),
                              //           FittedBox(
                              //             fit: BoxFit.contain,
                              //             child: Text(
                              //               widget._selectedStudent!.fullname,
                              //               style: GoogleFonts.poppins(
                              //                 fontSize: widget.fontsize / 90,
                              //                 color: Colors.green.shade900,
                              //                 fontWeight: FontWeight.bold,
                              //               ),
                              //               maxLines: 2,
                              //             ),
                              //           ),
                              //           FittedBox(
                              //             fit: BoxFit.contain,
                              //             child: Text(
                              //               widget._selectedStudent!.program,
                              //               style: GoogleFonts.poppins(
                              //                 fontSize: widget.fontsize / 120,
                              //                 color: Colors.green.shade900,
                              //                 fontWeight: FontWeight.normal,
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Colors.grey,
                              //   height: 4,
                              // ),
                              // Gap(widget.fontsize / 200),
                              // Text(
                              //   'Documents Request Details: ',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: widget.fontsize / 110,
                              //     color: Colors.grey.shade500,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.fontsize / 80.0),
                                child: Text(
                                  widget._selectedStudent!.documentName,
                                  style: GoogleFonts.poppins(
                                    fontSize: widget.fontsize / 90,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Gap(height / 120),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: fontsize / 60.0,
                                    right: fontsize / 60),
                                child: TextFormField(
                                  controller: _priceController,
                                  decoration: InputDecoration(
                                    labelText: 'Price',
                                    labelStyle: 
                                    GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
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
                                    isDense: true,
                                  ),
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontsize / 106),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a price';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Gap(height / 80),
                              document.requirements1 != null
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 60.0,
                                          right: fontsize / 60),
                                      child: TextFormField(
                                        controller: _requirements1Controller,
                                        decoration: InputDecoration(
                                          labelText: document.requirements1,
                                          labelStyle: 
                                           GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          isDense: true,
                                          hintText: document.hint1,
                                          hintStyle: GoogleFonts.poppins(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontsize / 106),
                                        ),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontsize / 106),
                                        keyboardType: TextInputType.text,
                                      ),
                                    )
                                  : Container(),
                              Gap(height / 80),
                              document.requirements2 != null
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 60.0,
                                          right: fontsize / 60),
                                      child: TextFormField(
                                        controller: _requirements2Controller,
                                        decoration: InputDecoration(
                                          labelText: document.requirements2,
                                          labelStyle:
                                            GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  Theme.of(context).hintColor,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          isDense: true,
                                          hintText: document.hint2,
                                          hintStyle: GoogleFonts.poppins(
                                              color: Colors.grey.shade400,
                                              fontWeight: FontWeight.bold,
                                              fontSize: fontsize / 106),
                                        ),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontsize / 106),
                                        keyboardType: TextInputType.text,
                                      ),
                                    )
                                  : Gap(0),
                              widget._selectedStudent!.stamp == 0
                                  ? SizedBox()
                                  : FutureBuilder<List<Stamp>>(
                                      future: _stampController.fetchStamps(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  "Error: ${snapshot.error}"));
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                              child: Text("No stamps found"));
                                        }

                                        final stamp = snapshot.data!
                                            .first; // Assuming only one stamp
                                        _documentaryprice.text =
                                            stamp.price.toStringAsFixed(2);

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Documentary Stamp ',
                                              style: GoogleFonts.poppins(
                                                fontSize: widget.fontsize / 110,
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Gap(height / 80),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: fontsize / 60.0,
                                                  right: fontsize / 60),
                                              child: TextFormField(
                                                controller: _documentaryprice,
                                                decoration: InputDecoration(
                                                  labelText: 'Documentary Price',
                                                  labelStyle:
                                                      GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  isDense: true,
                                                ),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 106),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter a price';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            Gap(height / 80),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: fontsize / 60.0,
                                                  right: fontsize / 60),
                                              child: TextFormField(
                                                controller: _documentaryCode,
                                                decoration: InputDecoration(
                                                  labelText: 'Documentary Code',
                                                  labelStyle:
                                                       GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                  ),
                                                  isDense: true,
                                                ),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: fontsize / 106),
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter a price';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      }),

                              Gap(height / 50),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: fontsize / 60.0,
                                    right: fontsize / 60),
                                child: ElevatedButton(
                                  onPressed: _showConfirmation,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesome.check_square,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Approve and Update',
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
                              Gap(height / 50),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: fontsize / 60.0,
                                    right: fontsize / 60),
                                child: ElevatedButton(
                                  onPressed: _showReasonDialog,
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height / 20,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.red.shade900,
                                          Colors.redAccent.shade700,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Entypo.squared_cross,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Reject Request',
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
                    ),
                  ),
                );
              }
            }),
      );
    });
  }
}

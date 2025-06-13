import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:plsp/common/common.dart';
import 'Controller.dart';
import 'Model.dart';
import 'PendingList.dart';

class ViewRequestPage extends StatefulWidget {
  const ViewRequestPage({
    super.key,
    required ApprovedRequest? selectedStudent,
    required this.fontsize,
    required this.height,
    required this.widget,
    required this.onClearSelection,
    required this.admin,
  }) : _selectedStudent = selectedStudent;

  final ApprovedRequest? _selectedStudent;
  final double fontsize;
  final double height;
  final PendingList widget;
  final VoidCallback onClearSelection;
  final String admin;
  @override
  State<ViewRequestPage> createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  final _formKey = GlobalKey<FormState>();

  late ORNumberController _controller;
  final TransactionController controller = TransactionController();
  String? orNumber;
  final _updateController = UpdateController();
  @override
  void initState() {
    super.initState();
    _controller = ORNumberController();
    _controller.fetchCurrentORNumber();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ViewRequestPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget._selectedStudent!.username !=
        widget._selectedStudent!.username) {}
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
                _submitForm();
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

  Future<void> _submitForm() async {
    final List<Request> requests = widget._selectedStudent?.requests ?? [];

    if (_formKey.currentState!.validate()) {
      // Calculate the total price of all requests
      double totalPrice =
          requests.fold(0.0, (sum, request) => sum + (request.price ?? 0.0));

      // Convert documents to a list of Request objects (without email and number)
      List<Request> document = requests.map((request) {
        return Request(
          documentName: request.documentName,
          price: request.price,
          requirements1: request.requirements1,
          requirements2: request.requirements2,
          // Exclude email and number since they're not needed
        );
      }).toList();

      print("Requests: $document");
      print("Total Price: $totalPrice");

      final int invoice = (int.tryParse(orNumber ?? '0') ?? 0) + 1;

      final transaction = TransactionModel(
        username: widget._selectedStudent!.username ?? '',
        fullname: widget._selectedStudent!.fullname ?? '',
        date: DateTime.now(),
        price: totalPrice,
        documents: document
            .map((request) => request.toJson())
            .toList(), // Ensure you convert to JSON format
        admin: widget.admin,
        invoice: invoice,
        program: widget._selectedStudent!.program ?? '',
      );

      print("Transaction Data: $transaction");

      final success = await controller.submitTransaction(transaction);

      if (success) {
        _showSuccessMessage('Successful Payments');
        widget.onClearSelection;
        _controller = ORNumberController();
        _controller.fetchCurrentORNumber();
        await updateForm();
      } else {
        _showErrorMessage('Payment failed');
      }
    }
  }

  Future<void> updateForm() async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit if the form validation fails
    }

    final selectedStudent = widget._selectedStudent;
    if (selectedStudent == null) {
      _showErrorMessage("No student selected");
      return;
    }

    final List<Request> requests = selectedStudent.requests ?? [];
    if (requests.isEmpty) {
      _showErrorMessage("No requests found for the selected student");
      return;
    }
    final reqdate = DateTime.now();
    final _reqdate = reqdate != null
        ? DateFormat('MM-dd-yyyy').format(reqdate.toLocal())
        : 'Unknown';
    final print = requests.map((request) {
      return {
        'documentName': request.documentName,
        'date': selectedStudent.date?.toString() ?? '',
        'price': request.price
      };
    }).toList();

    double totalPrice =
        requests.fold(0.0, (sum, request) => sum + (request.price ?? 0.0));
    final documents = requests.map((request) {
      return {
        'documentName': request.documentName,
        'date': selectedStudent.date?.toString() ?? '',
        'email': request.email,
        'requirements1':
            request.requirements1 ?? '', // Include requirements1 if available
        'requirements2':
            request.requirements2 ?? '', // Include requirements2 if available
      };
    }).toList();

    try {
      final result = await _updateController.updateToPaidStatus(
        username: selectedStudent.username ?? '',
        documents: documents,
      );

      if (result['success']) {
        _showSuccessMessage(result['message']);

        generateTriplicateReceiptPdf(
          date: _reqdate,
          fullname: widget._selectedStudent!.fullname ?? '',
          documents: print,
          totalAmount: totalPrice,
          adminName: widget.admin,
        );
      } else {
        _showErrorMessage(result['message']);
      }
    } catch (e) {
      // Handle unexpected errors
      _showErrorMessage("An unexpected error occurred: $e");
    }
  }

  String convertNumberToWords(int number) {
    if (number == 0) return "zero";

    List<String> belowTwenty = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "ten",
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen"
    ];

    List<String> tens = [
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety"
    ];

    List<String> thousands = ["", "thousand", "million", "billion"];

    String words = "";

    int i = 0;
    while (number > 0) {
      if (number % 1000 != 0) {
        words = _helper(number % 1000) + thousands[i] + " " + words;
      }
      number ~/= 1000;
      i++;
    }

    return words.trim();
  }

  String _helper(int number) {
    if (number == 0) return "";

    List<String> belowTwenty = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "ten",
      "eleven",
      "twelve",
      "thirteen",
      "fourteen",
      "fifteen",
      "sixteen",
      "seventeen",
      "eighteen",
      "nineteen"
    ];

    List<String> tens = [
      "twenty",
      "thirty",
      "forty",
      "fifty",
      "sixty",
      "seventy",
      "eighty",
      "ninety"
    ];

    if (number < 20) {
      return belowTwenty[number - 1] + " ";
    } else if (number < 100) {
      return tens[number ~/ 10 - 2] + " " + _helper(number % 10);
    } else {
      return belowTwenty[number ~/ 100 - 1] +
          " hundred " +
          _helper(number % 100);
    }
  }

  String convertAmountToWords(double amount) {
    int wholeAmount = amount.toInt();
    String wholeAmountInWords = convertNumberToWords(wholeAmount);
    return "$wholeAmountInWords pesos";
  }

  Future<void> generateTriplicateReceiptPdf({
    required String date,
    required String fullname,
    required List<Map<String, dynamic>> documents,
    required double totalAmount,
    required String adminName,
  }) async {
    final pdf = pw.Document();

    final pageFormat = PdfPageFormat(
      3.93701 * PdfPageFormat.inch,
      7.87402 * PdfPageFormat.inch,
    );

    for (int i = 0; i < 3; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: buildReceipt(
                  date, fullname, documents, totalAmount, adminName),
            );
          },
        ),
      );
    }

    String? desktopPath;

    if (Platform.isWindows) {
      desktopPath = '${Platform.environment['USERPROFILE']}\\Desktop';
    } else if (Platform.isMacOS || Platform.isLinux) {
      desktopPath = '${Platform.environment['HOME']}/Desktop';
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    final directory = await getApplicationDocumentsDirectory();

    final fileName = 'Triplicate_Receipt.pdf';
    final sanitizedFileName = fileName.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
    final filePath = path.join(directory.path, sanitizedFileName);

    try {
      final fileBytes = await pdf.save();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export successful! File saved at: $filePath')),
      );

      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save file: $e')),
      );
    }
  }

  pw.Widget buildReceipt(
    String date,
    String fullname,
    List<Map<String, dynamic>> documents,
    double totalAmount,
    String adminName,
  ) {
    double cmToPt(double cm) {
      return cm * 28.35;
    }

    return pw.Stack(
      children: [
        pw.Positioned(
          left: cmToPt(5),
          right: 0,
          top: cmToPt(4),
          child: pw.Text(
            '$date',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Positioned(
          left: cmToPt(1.7),
          right: 0,
          top: cmToPt(5.5),
          child: pw.Text(
            '$fullname',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Positioned(
          left: cmToPt(0.5), // Adjust as needed
          right: cmToPt(1),
          top: cmToPt(6.5),
          child: pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(6.5), // First column wider
              1: pw.FlexColumnWidth(2.2), // Second column smaller
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(),
                children: [
                  pw.SizedBox(
                    height: cmToPt(1),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: cmToPt(1),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        '',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              ...documents.map((doc) {
                final documentName = doc['documentName'] ?? 'Unknown';
                final price = doc['price'];

                final formattedPrice = (price is double
                        ? price
                        : double.tryParse(price.toString()) ?? 0.0)
                    .toStringAsFixed(2);

                return pw.TableRow(
                  children: [
                    pw.SizedBox(
                      height: cmToPt(0.5),
                      child: pw.Text(
                        documentName,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    pw.SizedBox(
                      height: cmToPt(0.5),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          formattedPrice,
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        pw.Positioned(
          right: cmToPt(1),
          top: cmToPt(12),
          child: pw.Text(
            totalAmount.toStringAsFixed(2),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ),
        pw.Positioned(
          left: cmToPt(0.5),
          top: cmToPt(12.5),
          child: pw.Text(
              '                        ${convertAmountToWords(totalAmount)}',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.normal,
                color: PdfColors.black,
              ),
              maxLines: 2),
        ),
      ],
    );
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
      final List<Request> requests = widget._selectedStudent?.requests ?? [];
      final reqdate = widget._selectedStudent!.date;
      final _reqdate = reqdate != null
          ? DateFormat('MM.dd.yyyy').format(reqdate.toLocal())
          : 'Unknown';

      double totalPrice =
          requests.fold(0.0, (sum, request) => sum + (request.price ?? 0.0));
      return Form(
          key: _formKey,
          child: Padding(
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
                          Text(
                            'Student Details: ',
                            style: GoogleFonts.poppins(
                              fontSize: widget.fontsize / 100,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(height / 80),
                          Row(
                            children: [
                              Container(
                                width: widget.fontsize / 20,
                                height: widget.fontsize / 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade900,
                                      Colors.greenAccent,
                                    ],
                                    stops: [0, 1],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    width: widget.fontsize / 20,
                                    height: widget.fontsize / 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: profileImageUrl != null &&
                                              profileImageUrl.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                profileImageUrl,
                                                headers: kHeader,
                                              ),
                                              fit: BoxFit
                                                  .cover, // Ensures the image covers the entire circle
                                            )
                                          : null, // If no image URL, decoration will have a fallback
                                      color: Colors.grey[
                                          300], // Placeholder background color
                                    ),
                                    child: profileImageUrl == null ||
                                            profileImageUrl.isEmpty
                                        ? Icon(
                                            Icons.person,
                                            size: widget.fontsize /
                                                15, // Adjusted icon size to match scaling
                                            color: Colors.grey[
                                                700], // Icon color for the placeholder
                                          )
                                        : null, // If image exists, child is null
                                  ),
                                ),
                              ),
                              Gap(widget.fontsize / 120),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        widget._selectedStudent!.username ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.fontsize / 90,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        widget._selectedStudent!.fullname ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.fontsize / 90,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        widget._selectedStudent!.program ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.fontsize / 120,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 4,
                          ),
                          Gap(widget.fontsize / 200),
                          StreamBuilder<String?>(
                            stream: _controller.orNumberStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null) {
                                return Center(
                                    child: Text('No OR number found.'));
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  setState(() {
                                    orNumber = snapshot.data;
                                  });
                                });

                                final int or =
                                    (int.tryParse(orNumber ?? '0') ?? 0) + 1;

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'OR #: ${or}',
                                        style: GoogleFonts.poppins(
                                            fontSize: fontsize / 100,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        'Date: ${_reqdate}',
                                        style: GoogleFonts.poppins(
                                            fontSize: fontsize / 100,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: fontsize / 80.0,
                            ),
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          requests.isEmpty
                              ? Center(
                                  child: Text(
                                    'No requests available',
                                    style: TextStyle(
                                      fontSize: fontsize / 100,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: requests.length,
                                  itemBuilder: (context, index) {
                                    final request = requests[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: fontsize / 320.0,
                                          vertical: height / 80),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                request.documentName ?? '',
                                                style: TextStyle(
                                                  fontSize: fontsize / 90,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Gap(fontsize / 300),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              'Php ${request.price!.toStringAsFixed(2)} ',
                                              style: TextStyle(
                                                fontSize: fontsize / 90,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: fontsize / 80.0,
                            ),
                            child: Divider(
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: fontsize / 320.0,
                                vertical: height / 80),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Total Amount',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontsize / 85,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Php ${totalPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: fontsize / 85,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Gap(height / 50),
                          Padding(
                            padding: EdgeInsets.only(
                                left: fontsize / 60.0, right: fontsize / 60),
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
                                      MaterialIcons.payments,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Payment Success',
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
                        ],
                      ),
                    ),
                  ))));
    });
  }
}

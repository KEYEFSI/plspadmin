import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'Controller.dart';
import 'Model.dart';
import 'PendingList.dart';
import 'package:path_provider/path_provider.dart';

class ViewRequestPage extends StatefulWidget {
  const ViewRequestPage({
    super.key,
    required UnpaidRequest? selectedStudent,
    required this.fontsize,
    required this.height,
    required this.widget,
    required this.onClearSelection,
    required this.admin,
  }) : _selectedStudent = selectedStudent;

  final UnpaidRequest? _selectedStudent;
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
  late TextEditingController _priceController;
  late ORNumberController _controller;
  final TransactionController controller = TransactionController();
  String? orNumber;
  
  @override
  void initState() {
    super.initState();
    _controller = ORNumberController();
    _controller.fetchCurrentORNumber();
    _initializeControllers();
  }

  void _initializeControllers() {
    _priceController = TextEditingController(
        text: widget._selectedStudent!.price!.toStringAsFixed(2));
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

    _initializeControllers();
  }

  Future<void> _submitTransaction() async {
    final int invoice = (int.tryParse(orNumber ?? '0') ?? 0) + 1;
    final double newBal =
        widget._selectedStudent!.balance! - double.parse(_priceController.text);
    final double price = double.parse(_priceController.text);
    if (price <= 0) {
      _showErrorMessage('Please enter a valid transaction amount');
      return;
    }

    if (newBal <= -1) {
      _showErrorMessage('Please enter a valid transaction amount');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final transaction = TransactionModel(
        username: widget._selectedStudent!.username ?? '',
        fullname: widget._selectedStudent!.fullname ?? '',
        date: widget._selectedStudent!.date!.toLocal(),
        price: double.parse(_priceController.text),
        oldBalance: widget._selectedStudent!.balance ?? 0.0,
        newBalance: newBal,
        admin: widget.admin,
        invoice: invoice,
        feename: widget._selectedStudent!.feeName ?? '',
      );

      final success = await controller.submitTransaction(transaction);

      if (success) {
        _showSuccessMessage('Transaction submitted successfully!');
        widget.onClearSelection;
        _controller = ORNumberController();
        _controller.fetchCurrentORNumber();
        await updateForm();
      } else {
        _showErrorMessage('Failed to submit transaction');
      }
    }
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
                _submitTransaction();
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

  Future<void> updateForm() async {
    // Validate form input
    if (!_formKey.currentState!.validate()) {
      return; // Exit if form validation fails
    }

    // Ensure a student is selected
    final selectedStudent = widget._selectedStudent;
    if (selectedStudent == null) {
      _showErrorMessage("No student selected");
      return;
    }

    // Show a loading indicator (if you use a separate loading widget, implement it here)

    try {
      // Calculate invoice number and new balance
      final int invoice = (int.tryParse(orNumber ?? '0') ?? 0) + 1;
      final double newBal =
          selectedStudent.balance! - double.parse(_priceController.text);
      final reqdate = widget._selectedStudent!.date;
      final _reqdate = reqdate != null
          ? DateFormat('MM-dd-yyyy').format(reqdate.toLocal())
          : 'Unknown';
      // Initialize controller and make API call
      final updateController = UpdateController();
      final response = await updateController.updatePaymentRequest(
        username: selectedStudent.username!,
        feeName: selectedStudent.feeName!,
        price: double.parse(_priceController.text),
        oldBalance: selectedStudent.balance!,
        newBalance: newBal,
        invoiceNo: invoice,
        adminAssigned: widget.admin,
        date:
            selectedStudent.date!.toLocal(), // Use current date for the request
        email: selectedStudent.email!, // Add the email parameter here
      );

      // Handle API response
      if (response['success']) {
        _showSuccessMessage(response['message']);

        generateTriplicateReceiptPdf(
          date: _reqdate,
          fullname: selectedStudent.fullname ?? '',
          totalAmount: double.parse(_priceController.text),
          adminName: widget.admin,
          feeName: selectedStudent.feeName!,
          price: double.parse(_priceController.text),
        );
      } else {
        _showErrorMessage(response['message']);
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
    required String feeName, // Single fee name
    required double price, // Corresponding price
    required double totalAmount,
    required String adminName,
  }) async {
    final pdf = pw.Document();

    // Define the custom page size (3.93 x 8.27 inches for portrait)
    final pageFormat = PdfPageFormat(
      3.93701 * PdfPageFormat.inch, // Width in points
      7.87402 * PdfPageFormat.inch, // Height in points
    );

    for (int i = 0; i < 3; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: buildReceipt(
                date: date,
                fullname: fullname,
                feeName: feeName,
                price: price,
                totalAmount: totalAmount,
                adminName: adminName,
              ),
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

    // Get the application's document directory
    final directory = await getApplicationDocumentsDirectory();

    // Create a sanitized file name for the PDF file
    final fileName = 'Triplicate_Receipt.pdf';
    final sanitizedFileName = fileName.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
    final filePath = path.join(directory.path, sanitizedFileName);

    // Save the PDF file to the specified location
    try {
      final fileBytes = await pdf.save();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // Notify the user of successful export
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export successful! File saved at: $filePath')),
      );

      OpenFile.open(filePath);
    } catch (e) {
      // Handle any errors that occur during file operations
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save file: $e')),
      );
    }
  }

// Function to generate a single receipt layout
  pw.Widget buildReceipt({
    required String date,
    required String fullname,
    required String feeName, 
    required double price, 
    required double totalAmount,
    required String adminName,
  }) {

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
             

                 pw.TableRow(
                  children: [
                    pw.SizedBox(
                      height: cmToPt(0.5),
                      child: pw.Text(
                        feeName,
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
                          price.toStringAsFixed(2),
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ])
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
    // return pw.Column(
    //   crossAxisAlignment: pw.CrossAxisAlignment.start,
    //   children: [
    //     pw.SizedBox(height: 8),
    //     pw.Row(
    //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //       children: [
    //         pw.Text('Date: $date'),
    //       ],
    //     ),
    //     pw.SizedBox(height: 16),
    //     pw.Text('Full Name: $fullname'),
    //     pw.SizedBox(height: 8),
    //     pw.Divider(),
    //     pw.Text(
    //       'Fee Details:',
    //       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //     ),
    //     pw.SizedBox(height: 8),
    //     pw.Table(
    //       border: pw.TableBorder.all(),
    //       columnWidths: {
    //         0: pw.FlexColumnWidth(3),
    //         1: pw.FlexColumnWidth(1),
    //       },
    //       children: [
    //         pw.TableRow(
    //           decoration: const pw.BoxDecoration(
    //             color: PdfColors.grey300,
    //           ),
    //           children: [
    //             pw.Padding(
    //               padding: const pw.EdgeInsets.all(4),
    //               child: pw.Text('Fee Name'),
    //             ),
    //             pw.Padding(
    //               padding: const pw.EdgeInsets.all(4),
    //               child: pw.Text('Price'),
    //             ),
    //           ],
    //         ),
    //         pw.TableRow(
    //           children: [
    //             pw.Padding(
    //               padding: const pw.EdgeInsets.all(4),
    //               child: pw.Text(feeName),
    //             ),
    //             pw.Padding(
    //               padding: const pw.EdgeInsets.all(4),
    //               child: pw.Text(price.toStringAsFixed(2)),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     pw.SizedBox(height: 16),
    //     pw.Divider(),
    //     pw.Row(
    //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    //       children: [
    //         pw.Text(
    //           'Total Amount:',
    //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //         ),
    //         pw.Text(
    //           totalAmount.toStringAsFixed(
    //               2), // Format total amount as a string with 2 decimal places
    //           style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    //         ),
    //       ],
    //     ),
    //     pw.SizedBox(height: 8),
    //     // Add the total amount in words
    //     pw.Text(
    //       'In Words: ${convertAmountToWords(totalAmount)}',
    //       style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
    //     ),
    //     pw.Spacer(), // Pushes the admin info to the bottom
    //     // Add the admin information at the bottom
    //     pw.Text(
    //       'Admin: $adminName',
    //       style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
    //     ),
    //   ],
    // );
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

      final reqdate = widget._selectedStudent!.date;
      final _reqdate = reqdate != null
          ? DateFormat('MM.dd.yyyy').format(reqdate.toLocal())
          : 'Unknown';

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
                                width: widget.fontsize /
                                    20, // Adjusted size for the outer container
                                height: widget.fontsize /
                                    20, // Ensure it is a square
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
                                  padding: const EdgeInsets.all(
                                      5.0), // Adjusted padding for better scaling
                                  child: Container(
                                    width: widget.fontsize /
                                        20, // Adjusted size for the inner container
                                    height: widget.fontsize /
                                        20, // Ensure it is a square
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
                                                80, // Adjusted icon size to match scaling
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
                                        widget._selectedStudent!.usertype ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.fontsize / 120,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Php',
                                            style: GoogleFonts.poppins(
                                                fontSize: fontsize / 160,
                                                color: Colors.green.shade900,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0),
                                          ),
                                        ),
                                        Text(
                                          widget._selectedStudent!.balance!
                                              .toStringAsFixed(2),
                                          style: GoogleFonts.poppins(
                                              fontSize: fontsize / 40,
                                              color: Colors.green.shade900,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.green.shade900,
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
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Payment Name: ${widget._selectedStudent!.feeName}',
                              style: GoogleFonts.poppins(
                                  fontSize: fontsize / 100,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  letterSpacing: 0),
                            ),
                          ),
                          Gap(height / 80),
                          Padding(
                            padding: EdgeInsets.only(
                                left: fontsize / 60.0, right: fontsize / 60),
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: GoogleFonts.poppins(
                                  fontSize: fontsize / 80,
                                  color: Colors.green.shade900,
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
                                Expanded(
                                    child: Align(
                                  alignment: Alignment.topRight,
                                  child:
                                      ValueListenableBuilder<TextEditingValue>(
                                          valueListenable: _priceController,
                                          builder: (context, value, child) {
                                            return Text(
                                              _priceController.text.isEmpty
                                                  ? '0'
                                                  : _priceController.text,
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 106,
                                                color: Colors.grey.shade900,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                              ),
                                            );
                                          }),
                                ))
                              ],
                            ),
                          ),
                          Gap(height / 50),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
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
                          ),
                          Gap(height / 50),
                        ],
                      ),
                    ),
                  ))));
    });
  }
}

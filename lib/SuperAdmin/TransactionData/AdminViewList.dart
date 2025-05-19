import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'Controller.dart';
import 'Model.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:month_year_picker/month_year_picker.dart';

class AdminAccounts extends StatefulWidget {
  final String username;

  const AdminAccounts({super.key, required this.username});

  @override
  State<AdminAccounts> createState() => _AdminAccountsState();
}

class _AdminAccountsState extends State<AdminAccounts> {
  late final DeleteTransactionsController _deleteController;
  late final TransactionController _controller;
  List<TransactionModel> _selectedItems = [];
  List<TransactionModel> _allItems = [];
  bool _isSelectAll = false;
  final LoginController _loginController = LoginController();
  bool _isLoading = false;
  String _errorMessage = '';

  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10;

  List<TransactionModel> _paginate(List<TransactionModel> transactions) {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return transactions.sublist(
      startIndex,
      endIndex > transactions.length ? transactions.length : endIndex,
    );
  }

 Future<void> _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2, 1),
      lastDate: DateTime(DateTime.now().year + 2, 12),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              accentColor: Colors.greenAccent,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textTheme: GoogleFonts.poppinsTextTheme( 
              Theme.of(context).textTheme, 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _controller.fetchDataForMonthYear(picked.year, picked.month);
    }
  }

  int _calculateTotalPages(int totalItems) {
    return (totalItems / itemsPerPage).ceil();
  }

  void _toggleSelectAll(bool isChecked) {
    // Use addPostFrameCallback to call setState after the widget build phase is completed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isSelectAll = isChecked;
          if (_isSelectAll) {
            _selectedItems = List.from(_allItems);
          } else {
            _selectedItems.clear();
          }
        });
      }
    });
  }

  void _toggleItemSelection(TransactionModel transaction) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          if (_selectedItems.contains(transaction)) {
            _selectedItems.remove(transaction);
          } else {
            _selectedItems.add(transaction);
          }

          _isSelectAll = _selectedItems.length == _allItems.length;
        });
      }
    });
  }

  Future<void> exportToExcel() async {
    try {
      print("Exporting selected items to Excel...");

      print("Selected items: $_selectedItems");

      if (_selectedItems.isEmpty) {
        _showErrorMessage('No items selected for export.');
        return;
      }

      final selectedInvoiceIds = _selectedItems
          .map((transaction) => transaction.invoice)
          .where((invoice) => invoice != null)
          .cast<int>()
          .toList();

      final selectedTransactions =
          await _controller.getTransactionsByInvoices(selectedInvoiceIds);

      if (selectedTransactions.isEmpty) {
        _showErrorMessage('No transactions found for the selected items.');
        return;
      }

      selectedTransactions.sort((a, b) => a.invoice!.compareTo(b.invoice!));

      var excel = Excel.createExcel();
      Sheet sheet = excel['Transactions'];

      sheet.appendRow([
        'Invoice',
        'Full Name',
        'Username',
        'Payment Details',
        'Admin Name'
            'Price',
        'Date',
      ]);

      for (var transaction in selectedTransactions) {
        String documentNames = '';

        if (transaction.documents != null &&
            transaction.documents!.isNotEmpty) {
          documentNames = transaction.documents!
              .map((doc) => doc.documentName ?? '')
              .join(", ");
        } else {
          documentNames = transaction.feeName ?? '';
        }

        String formattedDate =
            DateFormat('MM-dd-yyyy').format(transaction.date ?? DateTime.now());

        sheet.appendRow([
          transaction.invoice,
          transaction.fullname,
          transaction.username,
          documentNames,
          transaction.admin,
          transaction.price?.toStringAsFixed(2),
          formattedDate,
        ]);
      }

      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'TransactionData_${DateTime.now().toIso8601String()}.xlsx';
      final sanitizedFileName =
          fileName.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
      final filePath = path.join(directory.path, sanitizedFileName);

      var fileBytes = excel.save();
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);
      OpenFile.open(filePath);
      print("File saved at: $filePath");
      _showSuccessMessage(
          'Selected transactions exported successfully to:\n$filePath');
    } catch (e) {
      print("Error during export: $e");
      _showErrorMessage('Failed to export selected items to Excel.');
    }
  }

  Future<void> deleteTransactions() async {
    try {
      print("Deleting selected items...");

      print("Selected items: $_selectedItems");

      if (_selectedItems.isEmpty) {
        _showErrorMessage('No items selected for deletion.');
        return;
      }

      final selectedInvoiceIds = _selectedItems
          .map((transaction) => transaction.invoice)
          .where((invoice) => invoice != null)
          .cast<int>()
          .toList();

      final success = await _deleteController
          .deleteSelectedTransactions(selectedInvoiceIds);

      if (success) {
        setState(() {
          _allItems
              .removeWhere((item) => selectedInvoiceIds.contains(item.invoice));

          _selectedItems.clear();

          _isSelectAll = false;
        });

        _showSuccessMessage('Selected transactions deleted successfully.');
      } else {
        _showErrorMessage('Failed to delete selected items.');
      }
    } catch (e) {
      print("Error during deletion: $e");
      _showErrorMessage('An error occurred while deleting selected items.');
    }
  }

  void showDeleteDialog() {
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
              onPressed: () async {
                await deleteTransactions();
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

  void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer();

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

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
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
  void initState() {
    super.initState();
    _controller = TransactionController();
    _deleteController = DeleteTransactionsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('EEE, MMM. dd, yyyy');
    final String formatted = formatter.format(now);
    return Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Gap(height / 80),
              Text('Transaction Data',
                  style: GoogleFonts.poppins(
                    fontSize: fontsize / 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  )),
              Divider(
                thickness: 1,
                height: 1,
                color: Colors.green.shade900,
              ),
              Gap(fontsize / 80),
              Row(
                children: [
                  Gap(fontsize / 80),
                  Gap(fontsize / 40),
                  Expanded(
                    child: Text('Invoice',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Gap(fontsize / 40),
                  Expanded(
                    child: Text('Student Details',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Gap(fontsize / 40),
                  Gap(fontsize / 40),
                  Expanded(
                    child: Text('Payments Details',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Gap(fontsize / 40),
                  Gap(fontsize / 40),
                  Expanded(
                    child: Text('Date ',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Gap(fontsize / 40),
                 
                  Expanded(
                    child: Text('Price',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  GestureDetector(
                    onTap: () => _showMonthYearPicker(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: fontsize / 80,
                          horizontal: fontsize / 80),
                      child: Icon(Foundation.calendar,
                          color: Colors.green.shade900, size: fontsize / 80),
                    ),
                  ),
                  Gap(fontsize / 40)
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: fontsize / 80),
                child: Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: StreamBuilder<List<TransactionModel>>(
                    stream: _controller.transactionStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Lottie.asset('assets/error.json',
                            fit: BoxFit.contain);
                      }

                      final transactions = snapshot.data!;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _allItems =
                                transactions; // Safe to call setState after build phase
                          });
                        }
                      });

                      final totalPages =
                          _calculateTotalPages(transactions.length);
                      final paginatedTransactions = _paginate(transactions);

                      if (transactions.isEmpty) {
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
                            Expanded(
                              child: Column(
                                children: paginatedTransactions
                                    .asMap()
                                    .map((index, transaction) {
                                      final isSelected =
                                          _selectedItems.contains(transaction);

                                      final documents =
                                          transaction.documents ?? [];
                                      final reqdate = transaction.date;
                                      final _reqdate = reqdate != null
                                          ? DateFormat('MMM dd, yyyy')
                                              .format(reqdate.toLocal())
                                          : 'Unknown';
                                      return MapEntry(
                                        index,
                                        GestureDetector(
                                          onDoubleTap: () {
                                            _showTransactionDetailsDialog(
                                                context, transaction);
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Gap(fontsize / 120),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _toggleItemSelection(
                                                          transaction);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors
                                                              .green.shade900),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Container(
                                                          width: fontsize /
                                                              80, // Size of the circle
                                                          height: fontsize /
                                                              80, // Size of the circle
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: isSelected
                                                                ? Colors.green
                                                                    .shade900
                                                                : Colors.white,
                                                          ),
                                                          child: isSelected
                                                              ? Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      fontsize /
                                                                          100,
                                                                )
                                                              : null,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(fontsize / 80),
                                                  Expanded(
                                                    child: Text(
                                                        transaction.invoice
                                                                .toString() ??
                                                            '',
                                                        style: GoogleFonts.poppins(
                                                            fontSize:
                                                                fontsize / 80,
                                                            color: Colors
                                                                .green.shade900,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            transaction
                                                                    .username ??
                                                                '',
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                              transaction
                                                                      .fullname ??
                                                                  '',
                                                              style: GoogleFonts.poppins(
                                                                  fontSize:
                                                                      fontsize /
                                                                          100,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(fontsize / 120),
                                                  Expanded(
                                                    child: Tooltip(
                                                      textAlign:
                                                          TextAlign.start,
                                                      verticalOffset: -20,
                                                      richMessage: TextSpan(
                                                        children: <InlineSpan>[
                                                          TextSpan(
                                                            text:
                                                                'Payment Name: ',
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '${documents.isNotEmpty ? documents.map((doc) => doc.documentName ?? '').join(', ') : transaction.feeName ?? 'No data available'} \n',
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                'Admin Name: ',
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                '${transaction.admin ?? 'No data available'} \n',
                                                            style: GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  ('${documents.isNotEmpty ? documents.map((doc) => doc.documentName ?? '').join(', ') : transaction.feeName ?? 'No data available'}'),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          fontsize /
                                                                              140,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Admin Name: ',
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            140,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Text(
                                                                (transaction
                                                                        .admin ??
                                                                    ''),
                                                                style: GoogleFonts.poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            120,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 3,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(fontsize / 80),
                                                  Expanded(
                                                    child: Text(_reqdate,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        120,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                  ),
                                                  Gap(fontsize / 80),
                                                  Expanded(
                                                    child: Text(
                                                        'Php ${transaction.price!.toStringAsFixed(2)}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        100,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                ],
                                              ),
                                              Gap(height / 80)
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                    .values
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height / 80.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Gap(fontsize / 80),
                                  InkWell(
                                    onTap: () =>
                                        _toggleSelectAll(!_isSelectAll),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green.shade900),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _isSelectAll
                                                    ? Colors.green.shade900
                                                    : Colors.white,
                                              ),
                                              width: fontsize / 40,
                                              height: fontsize / 40,
                                              child: _isSelectAll
                                                  ? Icon(Icons.check,
                                                      color: Colors.white,
                                                      size: fontsize / 60)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Select All",
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 120,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      if (totalPages > 1)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                                        currentPage =
                                                            pageNumber;
                                                      });
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.0),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      decoration: BoxDecoration(
                                                        color: currentPage ==
                                                                pageNumber
                                                            ? Colors
                                                                .green.shade900
                                                            : Colors
                                                                .grey.shade300,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        '$pageNumber',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              fontsize / 140,
                                                          fontWeight:
                                                              currentPage ==
                                                                      pageNumber
                                                                  ? FontWeight
                                                                      .normal
                                                                  : FontWeight
                                                                      .bold,
                                                          color: currentPage ==
                                                                  pageNumber
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
                                                  child: Icon(Icons.arrow_right,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 71, 68, 68)),
                                                ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: _selectedItems.isEmpty
                                        ? null // Disable button if no items are selected
                                        : () async {
                                            showDeleteDialog();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .redAccent.shade700, // Dark green
                                      padding: EdgeInsets.symmetric(
                                          vertical: fontsize / 80,
                                          horizontal: height / 42),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                        "Delete  ${_selectedItems.length} Items",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: fontsize / 120,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Gap(fontsize / 80),
                                  ElevatedButton(
                                    onPressed: _selectedItems.isEmpty
                                        ? null // Disable button if no items are selected
                                        : () async {
                                            exportToExcel();
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(0xFF006400), // Dark green
                                      padding: EdgeInsets.symmetric(
                                          vertical: fontsize / 80,
                                          horizontal: height / 42),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                        "Export  ${_selectedItems.length} Items",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: fontsize / 120,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Gap(fontsize / 80),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  void _showTransactionDetailsDialog(
      BuildContext context, TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) {
        final fontsize = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        final documents = transaction.documents ?? [];
        TextEditingController _price = TextEditingController();

        _price.text = '${transaction.price!.toStringAsFixed(2)}';
        return AlertDialog(
          content: Container(
            width: fontsize / 4,
            height: height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('Transaction Details',
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade900,
                        fontSize: fontsize / 80,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Center(
                  child: Text('The payment details are available for review.',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: fontsize / 120,
                        fontWeight: FontWeight.normal,
                      )),
                ),
                Gap(height / 80),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.green.shade900,
                ),
                Gap(height / 80),
                Center(
                  child: Text('Total Price',
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade900,
                        fontSize: fontsize / 100,
                        fontWeight: FontWeight.normal,
                      )),
                ),

                TextField(
                  controller: _price,
                  style: GoogleFonts.poppins(
                    color: Colors.green.shade900,
                    fontSize: fontsize / 60,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade900),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade900),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green.shade900),
                    ),
                    isDense: true,
                  ),
                ),

                Gap(height / 80),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Invoice Number',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green.shade900,
                                      fontSize: fontsize / 120,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Center(
                                    child: Text(
                                      '${transaction.invoice}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade900,
                                        fontSize: fontsize / 100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(fontsize / 80),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: ',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green.shade900,
                                      fontSize: fontsize / 120,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Center(
                                    child: Text(
                                      '${transaction.date != null ? DateFormat('MMMM dd, yyyy').format(transaction.date!.toLocal()) : 'Unknown'}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade900,
                                        fontSize: fontsize / 100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(height / 80),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Student ID',
                                    style: GoogleFonts.poppins(
                                      color: Colors.green.shade900,
                                      fontSize: fontsize / 120,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Center(
                                    child: Text(
                                      '${transaction.username}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade900,
                                        fontSize: fontsize / 100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(fontsize / 80),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  transaction.feeName != null
                                      ? Text(
                                          'Fee Name:',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 120,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                      : Text(
                                          'Doments Names:',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade900,
                                            fontSize: fontsize / 120,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                  transaction.feeName != null
                                      ? Center(
                                          child: Text(
                                            '${transaction.feeName}',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade900,
                                              fontSize: fontsize / 120,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Expanded(
                                          child: Text(
                                            (documents.isNotEmpty
                                                ? documents
                                                    .map((doc) =>
                                                        doc.documentName ?? '')
                                                    .join(', ')
                                                : transaction.feeName ??
                                                    'No data available'),
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey.shade900,
                                              fontSize: fontsize / 140,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Gap(height / 80),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _onAddNewDocument(context, transaction, _price.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: EdgeInsets.symmetric(
                              vertical: fontsize / 80, horizontal: height / 42),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Edit Price",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: fontsize / 120,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
                Gap(height / 80),
                //   Row(
                //    children: [
                //      Expanded(
                //        child: ElevatedButton(
                //                           onPressed: (){},
                //                           style: ElevatedButton.styleFrom(
                //                             backgroundColor: Colors
                //                                 .green.shade900, // Dark green
                //                             padding: EdgeInsets.symmetric(
                //                                 vertical: fontsize / 80,
                //                                 horizontal: height / 42),
                //                             shape: RoundedRectangleBorder(
                //                               borderRadius: BorderRadius.circular(12),
                //                             ),

                //                           ),
                //                           child: Text(
                //                               "Print Receipt",
                //                               style: GoogleFonts.poppins(
                //                                 color: Colors.white,
                //                                 fontSize: fontsize / 120,
                //                                 fontWeight: FontWeight.bold,
                //                               )),
                //                         ),
                //      ),
                //    ],
                //  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _onAddNewDocument(
      BuildContext context, TransactionModel transaction, String price) async {
    TextEditingController passwordController = TextEditingController();
    final FocusNode passwordFocusNode = FocusNode();
    bool passwordVisibility = false;

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final fontsize = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(
                MaterialCommunityIcons.shield_key,
                color: Colors.green.shade900,
                size: 24,
              ),
              Gap(fontsize / 120),
              Text('Account Verification',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontsize / 60,
                    color: Colors.green.shade900,
                  ))
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Please enter your password to edit the price of the Student.',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: fontsize / 120,
                    color: Colors.black,
                  )),
              Gap(fontsize / 80),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                autofillHints: const [AutofillHints.password],
                obscureText: !passwordVisibility,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: fontsize / 120,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.normal,
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
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).cardColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: false,
                    fillColor: Colors.green.shade900,
                    prefixIcon: Icon(
                      Icons.security_sharp,
                      color: Colors.green.shade900,
                      size: fontsize / 80,
                    ),
                    isDense: true),
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  color: Theme.of(context).hoverColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _login(passwordController.text, context, transaction, price);
                Navigator.of(context).pop(passwordController.text);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Submit',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void _login(String password, BuildContext context,
      TransactionModel transaction, String price) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final loginModel =
        LoginModel(username: widget.username, password: password);

    final response = await _loginController.login(loginModel);

    setState(() {
      _isLoading = false;
    });

    if (response['success']) {
      _showSuccessMessage('Admin verified Successfully');
      _updateTransaction(transaction, price);
      print(
        transaction.fullname,
      );
      print(price);

      Navigator.of(context).pop();
    } else {
      // Show error message if login fails
      setState(() {
        _errorMessage =
            response['error'] ?? 'An error occurred. Please try again.';
      });
      _showErrorMessage('An error occurred. Please try again. ');
    }
  }

  Future<void> _updateTransaction(
      TransactionModel transaction, String price) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    double? newPrice = double.tryParse(price);

    double newpaid =
        transaction.price != null ? (transaction.price! - newPrice!) : 0.0;

    double balance = transaction.newBalance != null
        ? (newpaid + transaction.newBalance!)
        : 0.0;

    final updatedTransaction = Transaction(
      invoice: transaction.invoice,
      studentId: transaction.username,
      price: newPrice,
      oldBalance: transaction.oldBalance,
      newBalance: balance,
      feeName: transaction.feeName,
    );

    final updateTransactionService = UpdateTransaction();
    final response =
        await updateTransactionService.updateTransaction(updatedTransaction);

    setState(() {
      _isLoading = false;
    });

    // Handle the API response
    if (response['success']) {
      // Success: Transaction updated
      _showSuccessMessage('Transaction and balance updated successfully');
      print("Transaction updated: ${updatedTransaction.invoice}");
      print("Price updated: $price");
      _controller.refreshData();
    } else {
      // Error: Failed to update transaction
      setState(() {
        _errorMessage = 'Failed to update transaction: ${response['message']}';
      });
      _showErrorMessage(_errorMessage);
    }
  }
  
}

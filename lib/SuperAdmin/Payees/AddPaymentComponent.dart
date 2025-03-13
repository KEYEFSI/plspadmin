import 'package:audioplayers/audioplayers.dart';


import 'package:plsp/SuperAdmin/Integrated/UpdateISModel.dart';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';

import 'AddfeeName.dart';
import 'GraduatesCounterController.dart';
import 'GraduatesCounterModel.dart';

class AddPaymentComponent extends StatefulWidget {
  const AddPaymentComponent({
    super.key,
    required Student? selectedStudent,
    required this.priceController,
    required this.priceFocusNode,
    required this.paymentnameController,
    required this.paymentnameFocusNode,
    required this.onPaymentSaved,
  }) : _selectedStudent = selectedStudent;

  final Student? _selectedStudent;
  final TextEditingController priceController;
  final FocusNode priceFocusNode;
  final TextEditingController paymentnameController;
  final FocusNode paymentnameFocusNode;
  final VoidCallback onPaymentSaved;

  @override
  State<AddPaymentComponent> createState() => _AddPaymentComponentState();
}

class _AddPaymentComponentState extends State<AddPaymentComponent> {
  final FeeController feeController = FeeController(baseUrl: kUrl);
  

  Fee? selectedFee; // To store the selected Fee object
  List<Fee> fees = []; // List of fees
  bool isLoading = true; // Track loading state
  String? selectedFeeName;
  // Initialize the FeeController
  final FeesController feesController = FeesController();

  @override
  void initState() {
    super.initState();

    fetchFees();
  }

  @override
  void didUpdateWidget(AddPaymentComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Compare oldWidget and widget to determine if any relevant data has changed
    // Example: if a new student or different configuration has been passed
    if (widget._selectedStudent != oldWidget._selectedStudent) {
      // If the selected student changes, update any relevant state or UI
      print('Selected student has been updated');
    }
  }

  Future<void> fetchFees() async {
    try {
      List<Fee> fetchedFees = await feesController.fetchFees();
      setState(() {
        fees = fetchedFees;
        isLoading = false; // Stop the loading state once data is fetched
      });
    } catch (e) {
      print('Error fetching fees: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _saveFeeDetails() async {
    if (widget._selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No student selected')),
      );
      return;
    }

    final String priceText = widget.priceController.text;
    final double price = double.tryParse(priceText) ??
        -1.0; // Use -1.0 to indicate invalid input

    if (price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid transaction amount')),
      );
      return;
    }

    final String username = widget._selectedStudent!.username!;
    final String fullname = widget._selectedStudent!.fullname!;
    String? fee = selectedFee?.feeName;

    final double oldBalance = widget._selectedStudent!.balance!;

    final double newBalance = oldBalance + price;

    final feeDetails = FeeDetails(
      username: username,
      fullname: fullname,
      feeName: fee!,
      price: price,
      oldBalance: oldBalance,
      newBalance: newBalance,
    );

    final success = await feeController.saveFeeDetails(feeDetails);

    if (success) {
      widget.onPaymentSaved();
      Navigator.of(context).pop();
      _showDialog('Success', 'Fee details saved successfully');
    } else {
      _showDialog('Error', 'Failed to save fee details');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(Duration(seconds: 2), () async {
                Navigator.of(context).pop();
              });
            });

            return AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(color: Colors.green.shade900),
                    ),
                    Lottie.asset(
                      'assets/success.json',
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              actions: [],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

    return AlertDialog(
      content: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.width / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add Outstanding Balance',
                  style: GoogleFonts.poppins(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: const Alignment(1, 0),
                    child: Tooltip(
                      message: 'Create New Payments',
                      textStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: fontsize / 80,
                          fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(14)),
                      child: Container(
                        width: fontsize / 30,
                        height: fontsize / 30,
                        child: GestureDetector(
                          onTap: () {
                            _showPaymentDialog(context);
                          },
                          child: Lottie.asset(
                            'assets/add_doc.json',
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 2,
              color: Colors.green.shade900,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0, height / 101, 0, 0),
                    child: Text(
                      'Php',
                      style: GoogleFonts.poppins(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize / 96),
                    ),
                  ),
                  Text(
                    widget._selectedStudent != null
                        ? ' ${NumberFormat('#,##0.00').format(widget._selectedStudent!.balance) ?? '00.00'}'
                        : ' 00.00',
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: fontsize / 40,
                    ),
                  ),
                ]),
            Divider(
              thickness: 1,
              color: Colors.green,
              indent: fontsize / 16,
              endIndent: fontsize / 16,
            ),
            Text(
              'Outstanding Balance',
              style: GoogleFonts.poppins(
                color: Colors.green.shade900,
                fontWeight: FontWeight.bold,
                fontSize: fontsize / 160,
              ),
            ),
            SizedBox(
              height: height / 50,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsets.only(
                    left: fontsize / 80.0, right: fontsize / 80.0),
                child: Text(
                  'Transaction Amount',
                  style: GoogleFonts.poppins(
                      fontSize: fontsize / 96,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: fontsize / 80.0,
                  right: fontsize / 80.0,
                  bottom: height / 101),
              child: TextField(
                controller: widget.priceController,
                focusNode: widget.priceFocusNode,
                autofillHints: const [AutofillHints.transactionAmount],
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Transaction Amount',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: fontsize / 137,
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
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).cardColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: false,
                  fillColor: Theme.of(context).primaryColorLight,
                  prefixIcon: Icon(
                    FontAwesome.money,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 137,
                  color: Theme.of(context).hoverColor,
                  fontWeight: FontWeight.w500,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              height: height / 101,
            ),
            Align(
              alignment: AlignmentDirectional(-1, 0),
              child: Padding(
                padding: EdgeInsets.only(
                    left: fontsize / 80.0, right: fontsize / 80.0),
                child: Text(
                  'Education Cost Name',
                  style: GoogleFonts.poppins(
                      fontSize: fontsize / 96,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: fontsize / 80.0,
                  right: fontsize / 80.0,
                  bottom: fontsize / 80),
              child: DropdownButtonFormField<Fee>(
                decoration: InputDecoration(
                  labelText: 'Select Fee',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: fontsize / 96,
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
                  prefixIcon: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green.shade900,
                    size: 24.0,
                  ),
                ),
                dropdownColor: Colors.white,
                value: selectedFee, // The currently selected Fee object
                items: fees.map<DropdownMenuItem<Fee>>((Fee fee) {
                  return DropdownMenuItem<Fee>(
                    value: fee,
                    child: Text(
                      fee.feeName,
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 96,
                        color: Colors.green.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Fee? newValue) {
                  setState(() {
                    selectedFee = newValue; // Update the selected fee
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a fee';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: fontsize / 80.0, right: fontsize / 80),
              child: ElevatedButton(
                onPressed: _saveFeeDetails,
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
                        MaterialIcons.move_to_inbox,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 120,
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
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddFee();
      },
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

}



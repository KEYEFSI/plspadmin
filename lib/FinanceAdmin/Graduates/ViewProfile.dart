
import 'package:plsp/FinanceAdmin/Graduates/GraduatesCounterController.dart';
import 'package:plsp/FinanceAdmin/Graduates/GraduatesCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ViewProfile extends StatefulWidget {
  final String username;
    final bool showEditablePage;

  const ViewProfile({
    Key? key,
    required this.selectedStudent,
    required this.onPaymentSaved,
    required this.username, 
    required this.showEditablePage,
  }) : super(key: key);

  final GraduatesStudent? selectedStudent;
  final VoidCallback onPaymentSaved;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final StudentService _studentService = StudentService();
  late TextEditingController _amountController;
  final ORNumberController controller = ORNumberController();
  final TransactionController transactionController = TransactionController();
   final _controller = UpdatePaidStatusController();
  
  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  Future<SelectedStudent?> _fetchStudentData() async {
    try {
      final student =
          await _studentService.fetchStudent(widget.selectedStudent!.username);
      print('Fetched student: $student');
      
      return student;
    } catch (e) {
      print('Error fetching student data: $e');
      return null;
    }
  }

 Future<void> _update() async {
    final username = widget.selectedStudent!.username;
    final date = widget.selectedStudent!.date.toLocal();

    final request = UpdatePaidStatusRequest(username: username, date: date);

    try {
      await _controller.updatePaidStatus(request);
    
    } catch (e) {
     
    }
  }

  void _clear(){
    _amountController.clear();
    

  }
  
  Future<void> _transactionApproved() async {
    final String username = widget.selectedStudent!.username;
    final String fullname = widget.selectedStudent!.fullname;
    final String priceText = _amountController.text;
    final double price = double.tryParse(priceText) ?? -1.0;
    if (price <= 0) {
      _showerrorDialog('Error', 'Please enter a valid transaction amount');
      return;
    }
    final double oldBalance = widget.selectedStudent!.balance;
    final double newBalance = oldBalance - price;
    if (newBalance <= -1) {
      _showerrorDialog('Error', 'Please enter a valid transaction amount');
      return;
    }
    final String admin = widget.username;
    final String usertype = widget.selectedStudent!.usertype;
    final String oldOR = await controller.fetchCurrentORNumber();
    final int currentOR = (int.tryParse(oldOR) ?? 0) + 1;
    final DateTime date = widget.selectedStudent!.date.toLocal();
    final String address = widget.selectedStudent!.address;
    final String contact = widget.selectedStudent!.number;
    final DateTime? birthday = widget.selectedStudent!.birthday?.toLocal();

    final transaction = TransactionModel(
      username: username,
      fullname: fullname,
      date: date,
      price: price,
      oldBalance: oldBalance,
      newBalance: newBalance,
      admin: admin,
      usertype: usertype,
      invoice: currentOR,
      address: address,
      number: contact,
      birthday: birthday,
    );

    final success = await transactionController.saveTransaction(transaction);

    if (success) {
      await _update();

      _showDialog('Success', 'Fee details saved successfully');
      _clear;
      widget.onPaymentSaved();
    } else {
      _showerrorDialog('Error', 'Failed to save fee details');
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

  void _showerrorDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Show the dialog
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
                      'assets/error.json',
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
     final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    return Expanded(
      flex: 4,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        child: widget.showEditablePage
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                width: double.infinity,
                height: double.infinity,
                child: FutureBuilder<SelectedStudent?>(
                  future: _fetchStudentData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<SelectedStudent?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Lottie.asset('assets/Loading.json'));
                    } else if (snapshot.hasError) {
                      return Center(child: Lottie.asset('assets/Loading.json'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                          child: Lottie.asset('assets/viewprofile.json'));
                    } else {
                      final student = snapshot.data!;
                      String formattedDate = DateFormat('EEE, MMM dd, yyyy')
                          .format(widget.selectedStudent!.date.toLocal());
                       final date =
                                                  student.birthday != null
                                                      ? DateTime.parse(
                                                              student.birthday
                                                                  .toString())
                                                          .toLocal()
                                                      : null;

                                              final birthday = date != null
                                                  ? DateFormat('MMM dd, yyyy')
                                                      .format(date)
                                                  : 'N/A';

                   return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  fontsize / 200,
                                  height / 100,
                                  0,
                                  fontsize / 200),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24)),
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(24),
                                              topRight: Radius.circular(24)),
                                          image: DecorationImage(
                                            image: student.profile_image != null
                                                ? NetworkImage(
                                                    '$Purl${student.profile_image}',
                                                    headers: kHeader,
                                                  )
                                                : AssetImage(
                                                        'assets/backgroundlogin.jpg')
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(14),
                                              bottomRight: Radius.circular(14)),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 10,
                                              color: Color(0xFFF4F0F0),
                                              offset: Offset(0, 0),
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: fontsize / 120.0,
                                              horizontal: height / 64),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Fontisto.person,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 80,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 192,
                                                    ),
                                                    Text(
                                                      student.fullname
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      106,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesome.id_card,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 80,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 200,
                                                    ),
                                                    Text(
                                                      student.username
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      106,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(thickness: 1,),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesome.birthday_cake,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 80,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 200,
                                                    ),
                                                    Text(
                                                      birthday,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      106,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesome.phone,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 80,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 200,
                                                    ),
                                                    Text(
                                                      student.number.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      106,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(Ionicons.ios_location,
                                                        color: Colors
                                                            .green.shade900,
                                                        size: fontsize / 80),
                                                    SizedBox(
                                                      width: fontsize / 200,
                                                    ),
                                                    Text(
                                                      student.address
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      106,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0),
                                                    ),
                                                  ],
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Text(
                                        formattedDate,
                                        style: GoogleFonts.poppins(
                                            fontSize: fontsize / 96,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          student.balance!.toStringAsFixed(2),
                                          style: GoogleFonts.poppins(
                                              fontSize: fontsize / 30,
                                              color: Colors.green.shade900,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.green.shade100,
                                    indent: fontsize / 20,
                                    endIndent: fontsize / 20,
                                  ),
                                  Center(
                                    child: Text(
                                      'Outstanding balance',
                                      style: GoogleFonts.poppins(
                                          fontSize: fontsize / 120,
                                          color: Colors.green.shade900
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: fontsize / 40, top: height / 42),
                                    child: Text(
                                      'Student Paying,',
                                      style: GoogleFonts.poppins(
                                          fontSize: fontsize / 106,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 35.0,
                                          right: fontsize / 35,
                                          top: 8),
                                      child: TextFormField(
                                        controller: _amountController,
                                        decoration: InputDecoration(
                                          labelText: 'Amount',
                                          labelStyle: GoogleFonts.poppins(
                                            fontSize: fontsize / 106,
                                            color: Colors.green.shade900,
                                            fontWeight: FontWeight.w500,
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
                                          prefixIcon: Icon(
                                            FontAwesome.money,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter the Amount';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey.shade900,
                                    indent: fontsize / 40,
                                    endIndent: fontsize / 40,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: fontsize / 40,
                                          right: fontsize / 40),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  'Official Receipt Number:',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 106,
                                                    color: Colors.grey.shade900,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                  FutureBuilder<String>(
                                    future: controller.fetchCurrentORNumber(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: Lottie.asset(
                                                'assets/Loading.json'));
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Lottie.asset(
                                                'assets/Loading.json'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Center(
                                            child: Lottie.asset(
                                                'assets/viewprofile.json'));
                                      } else {
                                        final oldOR = snapshot.data!;
                                        final currentOR =
                                            (int.tryParse(oldOR) ?? 0) + 1;

                                       return Text(
                                                      currentOR.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 106,
                                                        color: Colors
                                                            .grey.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Gap(height/42),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'TOTAL',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:
                                                          fontsize / 106,
                                                      color: Colors
                                                          .grey.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Align(
                                                  alignment:
                                                      Alignment.topRight,
                                                  child: ValueListenableBuilder<
                                                          TextEditingValue>(
                                                      valueListenable:
                                                          _amountController,
                                                      builder: (context,
                                                          value, child) {
                                                        return Text(
                                                          _amountController
                                                                  .text
                                                                  .isEmpty
                                                              ? '0'
                                                              : _amountController
                                                                  .text,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize /
                                                                    106,
                                                            color: Colors.grey
                                                                .shade900,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            letterSpacing: 0,
                                                          ),
                                                        );
                                                      }),
                                                ))
                                              ]),
                                              Gap(height/42),
                                          Container(
                                            width:
                                                double.infinity, // Full width
                                            height: height/20, // Height
                                            child: ElevatedButton.icon(
                                              onPressed: _transactionApproved,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors
                                                    .transparent, // Set background color to transparent
                                                elevation:
                                                    20, // Remove elevation if you want to apply your own shadow
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                ),
                                              ),
                                              icon: Icon(
                                                MaterialCommunityIcons
                                                    .account_check, // Replace with your desired icon
                                                size: 24.0,
                                                color: Colors
                                                    .white, // Adjust size as needed
                                              ),
                                              label: Text(
                                                'Approve Payment',
                                                style: GoogleFonts.poppins(
                                                  fontSize: fontsize / 80,
                                                  fontWeight: FontWeight.w700,
                                                  color: Theme.of(context)
                                                      .dividerColor, // Text color
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor, // Background color
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  },
                ),
              )
            : Center(
                child: Lottie.asset('assets/viewprofile.json'),
              ),
      ),
    );
  }
}

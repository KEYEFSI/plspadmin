import 'package:plsp/SuperAdmin/Integrated/AddPaymentComponent.dart';
import 'package:plsp/SuperAdmin/Integrated/ISCounterController.dart';
import 'package:plsp/SuperAdmin/Integrated/ISCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ViewProfile extends StatefulWidget {
  const ViewProfile({
    Key? key,
    required this.selectedStudent,
    required this.onPaymentSaved,
  }) : super(key: key);

  final Student? selectedStudent;
  final VoidCallback onPaymentSaved;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final StudentService _studentService = StudentService();

  Future<Student?> _fetchStudentData() async {
    try {
      return await _studentService
          .fetchStudent(widget.selectedStudent!.username!);
    } catch (e) {
      // Handle error
      return null;
    }
  }

  void _showTransactionDialog(
    BuildContext context,
    String username,
    String fullname,
    double balance,
  ) {
    final TextEditingController priceController = TextEditingController();
    final FocusNode priceFocusNode = FocusNode();
    final TextEditingController paymentnameController = TextEditingController();
    final FocusNode paymentnameFocusNode = FocusNode();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddPaymentComponent(
          selectedStudent: widget.selectedStudent,
          priceController: priceController,
          priceFocusNode: priceFocusNode,
          paymentnameController: paymentnameController,
          paymentnameFocusNode: paymentnameFocusNode,
          onPaymentSaved: () {
            widget.onPaymentSaved();
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TransactionController _controller = TransactionController('$kUrl');
    final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: FutureBuilder<Student?>(
          future: _fetchStudentData(),
          builder: (BuildContext context, AsyncSnapshot<Student?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Lottie.asset('assets/Loading.json'));
            } else if (snapshot.hasError) {
              return Center(child: Lottie.asset('assets/Loading.json'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Lottie.asset('assets/viewprofile.json'));
            } else {
              final student = snapshot.data!;
              final birthday = student.birthday;
              final _birthday = birthday != null
                  ? DateFormat('MMM dd, yyyy').format(birthday)
                  : 'Unknown';
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 10,
                      color: Color(0xFFF4F0F0),
                      offset: Offset(0, 0),
                      spreadRadius: 5,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.white, Theme.of(context).primaryColor],
                    stops: const [0.8, 1],
                    begin: const AlignmentDirectional(0, 1),
                    end: const AlignmentDirectional(0, -1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(height / 42),
                    Padding(
                      padding: EdgeInsets.only(left: fontsize / 80.0),
                      child: Text(
                        'Transaction Report',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontsize / 80,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Gap(height/42),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: fontsize / 80),
                      child: Container(
                        height: height / 5,
                        decoration: const BoxDecoration(),
                        child: Stack(children: [
                          Center(
                            child: Image.asset(
                              'assets/card.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                fontsize / 80,
                                0,
                                fontsize / 80,
                                height / 56.5),
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: height / 101.0,
                                  left: fontsize / 192,
                                  bottom: height / 101.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        student.fullname ?? '',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: fontsize / 120,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        student.username ?? '',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: fontsize / 137,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Outstanding balance',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500,
                                                  fontSize: fontsize / 137,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Php ${NumberFormat('#,##0.00').format(student.balance)}',
                                                      style: GoogleFonts
                                                          .poppins(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 80,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: fontsize / 192),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'PLSP',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          fontsize / 100,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _showTransactionDialog(
                          context,
                          student.username.toString(),
                          student.fullname.toString(),
                          student.balance!,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              fontsize / 80, height / 42, fontsize / 80, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.green.shade300],
                                stops: const [0.8, 1],
                                begin: const AlignmentDirectional(1, 0),
                                end: const AlignmentDirectional(-1, 0),
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Color(0xFFF4F0F0),
                                  offset: Offset(0, 0),
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Gap(fontsize / 80),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Add',
                                      style: GoogleFonts.outfit(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontsize / 96,
                                      ),
                                    ),
                                    Text(
                                      'Add new Student Fee',
                                      style: GoogleFonts.outfit(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: fontsize / 120,
                                      ),
                                    ),
                                  ],
                                ),
                                Lottie.asset('assets/money.json',
                                    fit: BoxFit.contain)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.green,
                      indent: fontsize / 60,
                      endIndent: fontsize / 60,
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FutureBuilder<List<UserTransactionDetails>>(
                          future: _controller
                              .getTransactions(student.username.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Lottie.asset('assets/Loading.json'));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Lottie.asset('assets/Loading.json'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No transactions found.',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Lottie.asset(
                                      'assets/Empty.json',
                                      width:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              5,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              final transactions = snapshot.data!;
              
                              return ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];
                                  final date = transaction.date != null
                                      ? DateTime.parse(
                                              transaction.date.toString())
                                          .toLocal()
                                      : null;
              
                                  final formattedDate = date != null
                                      ? DateFormat('MM.dd.yyyy').format(date)
                                      : 'N/A';
                                  final main = (transaction.feeName != null &&
                                      transaction.feeName!.isNotEmpty);
              
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: fontsize / 80),
                                      child: main
                                          ? Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: fontsize / 40,
                                                        height: fontsize / 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .redAccent.shade700,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        fontsize/137)),
                                                        child: Icon(
                                                          MaterialCommunityIcons
                                                              .database_arrow_up,
                                                          color: Colors.white,
                                                        )),
                                                    Gap(fontsize / 160),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${transaction.feeName}',
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .grey.shade900
                                                                    ,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontsize /
                                                                        120),
                                                          ),
                                                          Text(
                                                            ' $formattedDate',
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontsize /
                                                                        137),
                                                          ),
                                                        ]),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .topRight,
                                                        child: Text(
                                                          ' + ${NumberFormat('#,##0.00').format(transaction.price)}',
                                                          style: GoogleFonts.poppins(
                                                              color:
                                                                  Colors.redAccent.shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize /
                                                                      130),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Colors.grey,
                                                  height: height / 84,
                                                ),
                                                Gap(height / 84)
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: fontsize / 40,
                                                        height: fontsize / 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .greenAccent.shade700,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        fontsize/137)),
                                                        child: Icon(
                                                          MaterialCommunityIcons.database_arrow_down,
                                                          color: Colors.white,
                                                        )),
                                                    Gap(fontsize / 160),
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'OR: ${transaction.invoice}',
                                                            style: GoogleFonts.poppins(
                                                                color:Colors.grey.shade900,
                                                                    
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontsize /
                                                                        120),
                                                          ),
                                                          Text(
                                                            ' $formattedDate | ${transaction.admin}',
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    fontsize /
                                                                        137),
                                                          ),
                                                        ]),
                                                    Expanded(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          ' + ${NumberFormat('#,##0.00').format(transaction.price)}',
                                                          style: GoogleFonts.poppins(
                                                              color:
                                                                  Colors.greenAccent.shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  fontsize /
                                                                      137,
                                                                      letterSpacing: 0,
                                                                      wordSpacing: 0
                                                                      ),
                                                                      
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: Colors.grey,
                                                  height: height / 84,
                                                ),
                                                Gap(height / 84)
                                              ],
                                            ));
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:plsp/SuperAdmin/College/CollegeCounterController.dart';
import 'package:plsp/SuperAdmin/College/CollegeCounterModel.dart';
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

  final StudentCollege? selectedStudent;
  final VoidCallback onPaymentSaved;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final StudentService _studentService = StudentService();

  Future<StudentCollege?> _fetchStudentData() async {
    try {
      return await _studentService
          .fetchStudent(widget.selectedStudent!.username!);
    } catch (e) {
      // Handle error
      return null;
    }
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
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: FutureBuilder<StudentCollege?>(
          future: _fetchStudentData(),
          builder:
              (BuildContext context, AsyncSnapshot<StudentCollege?> snapshot) {
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        image: student.profile_image != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  '$Purl${student.profile_image}',
                                  headers: kHeader,
                                ),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage('assets/backgroundlogin.jpg'),
                                fit: BoxFit.cover,
                              ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0x801D2429).withOpacity(0.3),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  fontsize / 200, 0, 0, fontsize / 200),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: fontsize / 600,
                                  ),
                                  Text(
                                    student.fullname ?? '',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontsize / 96,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        student.username ?? '',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontsize / 96,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: fontsize / 600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0xFFF4F0F0),
                            offset: Offset(0, 0),
                            spreadRadius: 5,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Theme.of(context).primaryColor
                          ],
                          stops: [0.6, 1],
                          begin: AlignmentDirectional(0, 1),
                          end: AlignmentDirectional(0, -1),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: fontsize / 120, top: height / 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesome.university,
                                  color: Colors.white,
                                  size: fontsize / 120,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    student.program ?? '',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: fontsize / 137,
                                        letterSpacing: 0,
                                        wordSpacing: 0),
                                  ),
                                ),
                              ],
                            ),
                            Gap(height / 120),
                            Row(
                              children: [
                                Icon(
                                  FontAwesome.birthday_cake,
                                  color: Colors.white,
                                  size: fontsize / 120,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _birthday,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 137,
                                      letterSpacing: 0,
                                      wordSpacing: 0),
                                ),
                              ],
                            ),
                            Gap(height / 120),
                            Row(
                              children: [
                                Icon(
                                  Foundation.telephone,
                                  color: Colors.white,
                                  size: fontsize / 80,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  student.number ?? '',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 137,
                                      letterSpacing: 0,
                                      wordSpacing: 0),
                                ),
                                SizedBox(width: fontsize / 400),
                                Icon(
                                  Ionicons.ios_location,
                                  color: Colors.white,
                                  size: fontsize / 100,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    student.address ?? '',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                      fontSize: fontsize / 137,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap(height / 42),
                            Text(
                              'Transaction Receipt',
                              style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontsize / 120),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: fontsize / 200),
                              child: Divider(
                                thickness: 1,
                                color: Colors.green.shade900,
                              ),
                            ),
                            Expanded(
                              child:
                                  FutureBuilder<List<UserTransactionDetails>>(
                                      future: _controller.getTransactions(
                                          student.username.toString()),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child: Lottie.asset(
                                                  'assets/Loading.json'));
                                        } else if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return Center(
                                              child: Lottie.asset(
                                                  'assets/Loading.json'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'No transactions found.',
                                                  style: GoogleFonts.poppins(
                                                    color:
                                                        Colors.green.shade900,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Lottie.asset(
                                                  'assets/Empty.json',
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      5,
                                                  fit: BoxFit.cover,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          final transactions = snapshot.data!
                                              .where((transaction) =>
                                                  transaction.documents !=
                                                      null &&
                                                  transaction
                                                      .documents!.isNotEmpty)
                                              .toList();

                                          if (transactions.isEmpty) {
                                            return Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'No valid transactions found.',
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Lottie.asset(
                                                    'assets/Empty.json',
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            5,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            itemCount: transactions.length,
                                            itemBuilder: (context, index) {
                                              final transaction =
                                                  transactions[index];
                                              final date =
                                                  transaction.date != null
                                                      ? DateTime.parse(
                                                              transaction.date
                                                                  .toString())
                                                          .toLocal()
                                                      : null;

                                              final formattedDate = date != null
                                                  ? DateFormat('MM.dd.yyyy')
                                                      .format(date)
                                                  : 'N/A';

                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    right: fontsize / 80),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 1,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .greenAccent
                                                                  .shade700,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      fontsize /
                                                                          137)),
                                                        ),
                                                        Gap(fontsize / 160),
                                                        Expanded(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  ' $formattedDate | ${transaction.admin}',
                                                                  style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade900,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          fontsize /
                                                                              137),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        'OR: ${transaction.invoice}',
                                                                        style: GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.grey.shade900,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: fontsize / 137),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.topRight,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: height / 200.0),
                                                                              child: Text(
                                                                                'TOTAL ',
                                                                                style: GoogleFonts.poppins(color: Colors.greenAccent.shade700, fontWeight: FontWeight.bold, fontSize: fontsize / 200, letterSpacing: 0, wordSpacing: 0),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              '${NumberFormat('#,##0.00').format(transaction.price)}',
                                                                              style: GoogleFonts.poppins(color: Colors.greenAccent.shade700, fontWeight: FontWeight.bold, fontSize: fontsize / 96, letterSpacing: 0, wordSpacing: 0),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                if (transaction
                                                                            .documents !=
                                                                        null &&
                                                                    transaction
                                                                        .documents!
                                                                        .isNotEmpty)
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left: fontsize /
                                                                            200.0),
                                                                    child:
                                                                        Column(
                                                                      children: transaction
                                                                          .documents!
                                                                          .map(
                                                                              (document) {
                                                                        return Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                '${document.documentName ?? 'na'}',
                                                                                style: GoogleFonts.poppins(
                                                                                  color: Colors.grey.shade900,
                                                                                  fontWeight: FontWeight.normal,
                                                                                  fontSize: fontsize / 200,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: Text(
                                                                                  ' + ${document.price != null ? NumberFormat('#,##0.00').format(document.price!) : 'na'}',
                                                                                  style: GoogleFonts.poppins(
                                                                                    color: Colors.grey.shade900,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: fontsize / 200,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  ),
                                                              ]),
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
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

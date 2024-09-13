import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plsp/FinanceAdmin/College/CollegeCounterController.dart';
import 'package:plsp/FinanceAdmin/College/CollegeCounterModel.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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

  final CollegeRequest? selectedStudent;
  final VoidCallback onPaymentSaved;

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final StudentService _studentService = StudentService();

  final ORNumberController controller = ORNumberController();
  late CollegeTransactionController transactionController =
      CollegeTransactionController();
  final UpdateCollegeRequestController _controller =
      UpdateCollegeRequestController();
  final UserRequestController _usercontroller = UserRequestController();
  final UserPaidDocumentController _UserPaidDocumentController =
      UserPaidDocumentController();

  @override
  void initState() {
    super.initState();
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

  void _insertDocuments() async {
    final selectedStudent = widget.selectedStudent!;

    final List<UserRequest>? requests = await _usercontroller.fetchRequests(
      selectedStudent.username.toString(),
      selectedStudent.date.toLocal().toIso8601String(),
    );

    if (requests == null) {
      print('No requests found.');
      return;
    }

    final ORNumberController orNumberController = ORNumberController();
    final currentORString = await orNumberController.fetchCurrentORNumber();
    final int currentOR = int.tryParse(currentORString) ?? 0;
    final invoiceNumber = currentOR;

    if (currentOR == 0) {
      print('Failed to fetch OR number.');
      return;
    }

    // Generate the list of UserPaidDocuments based on requests with invoice number
    final List<UserPaidDocument> documents = requests.map((request) {
      return UserPaidDocument(
        username: request.username,
        documentName: request.documentName,
        price: request.price,
        date: request.date, // No need to parse again
        requirements1: request.requirements1,
        requirements2: request.requirements2,
        invoice: invoiceNumber,
      );
    }).toList();

    if (documents.isEmpty) {
      print('No documents to insert.');
      return;
    }

    // Insert the documents using the controller
    final success =
        await _UserPaidDocumentController.insertDocuments(documents);

    if (success) {
      print('Documents inserted successfully.');
    } else {
      print('Failed to insert documents.');
    }
  }

//Update the Request
  Future<void> _updateRequest() async {
    try {
      final selectedStudent = widget.selectedStudent!;

      // Fetch the list of requests from the user controller
      final List<UserRequest>? requests = await _usercontroller.fetchRequests(
        selectedStudent.username.toString(),
        selectedStudent.date.toLocal().toIso8601String(),
      );

      // Ensure requests are found before making the update call
      if (requests != null && requests.isNotEmpty) {
        for (var request in requests) {
          // Prepare the data for each request
          var requestData = {
            'username': selectedStudent.username.toString(),
            'documentName': request.documentName,
            'price': request.price,
            'date': selectedStudent.date.toLocal().toIso8601String(),
            'requirements1': request.requirements1,
            'requirements2': request.requirements2,
          };

          try {
            // Print the JSON data for debugging
            print('Request data: ${jsonEncode(requestData)}');

            // Make the API call to update the request
            final response = await http.post(
              Uri.parse('$kUrl/FMSR_UpdatePaidStatusCollege'),
              headers: kHeader,
              body: jsonEncode(requestData),
            );

            // Handle the response for each request
            if (response.statusCode == 200) {
              print('Request updated successfully for: ${request.username}');
            } else {
              print('Failed to update request for: ${request.username}');
              print('Response body: ${response.body}');
            }
          } catch (e) {
            print('Error updating request for ${request.username}: $e');
          }
        }
      } else {
        // Handle case where no requests were found
        print('No requests found to update.');
      }
    } catch (e) {
      // Handle any exceptions that occur during the process
      print('Error updating requests: $e');
    }
  }

//Insert to the Transaction Table
  Future<void> _transactionApproved() async {
    try {
      // Ensure widget.selectedStudent is not null
      if (widget.selectedStudent == null) {
        throw Exception('Selected student is null');
      }

      final selectedStudent = widget.selectedStudent!;

      final String oldOR = await controller.fetchCurrentORNumber();
      final int currentOR = (int.tryParse(oldOR) ?? 0) + 1;

      final List<UserRequest>? requests = await _usercontroller.fetchRequests(
        selectedStudent.username.toString(),
        selectedStudent.date.toLocal().toIso8601String(),
      );

      final List<String> documents = requests
              ?.map((request) =>
                  '${request.documentName}, ${request.price},${request.requirements1} ,${request.requirements2} ')
              .toList() ??
          [];

      final String username = selectedStudent.username;
      final String fullname = selectedStudent.fullname;
      final String admin = widget.username;
      final String usertype = selectedStudent.usertype;
      final DateTime date = selectedStudent.date.toLocal();
      final String address = selectedStudent.address;
      final String contact = selectedStudent.number;
      final DateTime birthday = selectedStudent.birthday?.toLocal() ??
          DateTime.now(); // Handle null birthday
      final String program = selectedStudent.program;

      // Calculate the total price
      final double totalPrice = (requests ?? []).fold<double>(
        0.0,
        (sum, request) => sum + (request.price ?? 0.0),
      );

      final transaction = CollegeTransaction(
        username: username,
        fullname: fullname,
        date: date,
        price: totalPrice,
        documents: documents,
        admin: admin,
        userType: usertype,
        invoice: currentOR,
        address: address,
        number: contact,
        birthday: birthday,
        program: program,
      );

      final bool success =
          await transactionController.submitTransaction(transaction);

      if (success) {
        _insertDocuments();
        await _updateRequest();

        _showDialog('Success', 'Fee details saved successfully');

        widget.onPaymentSaved();
      } else {
        _showerrorDialog('Error', 'Failed to save fee details');
        print('errpr');
        print(transaction.username);
      }
    } catch (error) {
      _showerrorDialog('Error', 'An unexpected error occurred: $error');
      print(error);
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
    final fontsize = (MediaQuery.of(context).size.height +
        MediaQuery.of(context).size.width);

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
                      final date = student.birthday != null
                          ? DateTime.parse(student.birthday.toString())
                              .toLocal()
                          : null;

                      final birthday = date != null
                          ? DateFormat('MMM dd, yyyy').format(date)
                          : 'N/A';

                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  fontsize / 200,
                                  fontsize / 200,
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
                                          padding: const EdgeInsets.all(16.0),
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
                                                      size: fontsize / 120,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Text(
                                                      student.fullname
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      150,
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
                                                      size: fontsize / 120,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Text(
                                                      student.username
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      150,
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
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesome.university,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 120,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        student.program
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        180,
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                letterSpacing:
                                                                    0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      FontAwesome.birthday_cake,
                                                      color:
                                                          Colors.green.shade900,
                                                      size: fontsize / 120,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Text(
                                                      birthday,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      180,
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
                                                      size: fontsize / 120,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Text(
                                                      student.number.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      180,
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
                                                      Ionicons.ios_location,
                                                      size: fontsize / 120,
                                                      color:
                                                          Colors.green.shade900,
                                                    ),
                                                    SizedBox(
                                                      width: fontsize / 150,
                                                    ),
                                                    Text(
                                                      student.address
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      180,
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
                            child: FutureBuilder<List<UserRequest>?>(
                              future: _usercontroller.fetchRequests(
                                widget.selectedStudent!.username.toString(),
                                widget.selectedStudent!.date
                                    .toLocal()
                                    .toIso8601String(),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child:  Lottie.asset(
                                                  'assets/Request.json',
                                                  fit: BoxFit.contain,
                                                ),);
                                }

                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Center(
                                      child: Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain));
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text('No requests found.'));
                                }

                                final requests = snapshot.data!;
                                final totalPrice = requests.fold<double>(
                                  0.00,
                                  (sum, request) =>
                                      sum + (request.price ?? 0.00),
                                );
                                return Padding(
                                  padding: EdgeInsets.all(fontsize / 100.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 12.0),
                                          child: Text(
                                            formattedDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 150,
                                              color: Colors.grey.shade900,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: fontsize / 80,
                                            top: fontsize / 100),
                                        child: Text(
                                          'Student Paying,',
                                          style: GoogleFonts.poppins(
                                            fontSize: fontsize / 180,
                                            color: Colors.grey.shade900,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: fontsize / 200.0),
                                            child: Text(
                                              'Php',
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 80,
                                                color: Colors.green.shade800,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            totalPrice.toStringAsFixed(2),
                                            style: GoogleFonts.poppins(
                                              fontSize: fontsize / 40,
                                              color: Colors.green.shade900,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                        indent: fontsize / 100,
                                        endIndent: fontsize / 100,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: fontsize / 100.0),
                                          child: ListView.builder(
                                            itemCount: requests.length,
                                            itemBuilder: (context, index) {
                                              final request = requests[index];

                                              return Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              request
                                                                  .documentName
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        180,
                                                                color: Colors
                                                                    .green
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                            )),
                                                        Expanded(
                                                            child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  'Php ' +
                                                                      request
                                                                          .price!
                                                                          .toStringAsFixed(
                                                                              2),
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        fontsize /
                                                                            180,
                                                                    color: Colors
                                                                        .green
                                                                        .shade900,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    letterSpacing:
                                                                        0,
                                                                  ),
                                                                )))
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left:
                                                              fontsize / 200.0),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Rqmnts: ',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      220,
                                                              color: Colors
                                                                  .green
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                fontsize / 220,
                                                          ),
                                                          Text(
                                                            request
                                                                .requirements1
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      220,
                                                              color: Colors.grey
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                fontsize / 220,
                                                          ),
                                                          Text(
                                                            request
                                                                .requirements2
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize:
                                                                  fontsize /
                                                                      220,
                                                              color: Colors.grey
                                                                  .shade900,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: fontsize / 220,
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Colors.grey.shade900,
                                        indent: fontsize / 100,
                                        endIndent: fontsize / 100,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: fontsize / 100,
                                                  top: fontsize / 100,
                                                  right: fontsize / 100),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      'Official Receipt Number:',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            fontsize / 160,
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
                                                      child:
                                                          FutureBuilder<String>(
                                                        future: controller
                                                            .fetchCurrentORNumber(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Center(
                                                                child: Lottie.asset(
                                                                    'assets/Loading.json'));
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Center(
                                                                child: Lottie.asset(
                                                                    'assets/Loading.json'));
                                                          } else if (!snapshot
                                                                  .hasData ||
                                                              snapshot.data ==
                                                                  null) {
                                                            return Center(
                                                                child: Lottie.asset(
                                                                    'assets/viewprofile.json'));
                                                          } else {
                                                            final oldOR =
                                                                snapshot.data!;
                                                            final currentOR =
                                                                (int.tryParse(
                                                                            oldOR) ??
                                                                        0) +
                                                                    1;

                                                            return Text(
                                                              currentOR
                                                                  .toString(),
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize:
                                                                    fontsize /
                                                                        160,
                                                                color: Colors
                                                                    .grey
                                                                    .shade900,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: fontsize / 100,
                                                  top: fontsize / 300,
                                                  right: fontsize / 100),
                                              child: Row(
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
                                                              fontsize / 160,
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
                                                        child: Text(
                                                          totalPrice.toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:
                                                                fontsize / 160,
                                                            color: Colors
                                                                .grey.shade900,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            fontsize / 100,
                                            0,
                                            fontsize / 100,
                                            0),
                                        child: Container(
                                          width: double.infinity,
                                          height: fontsize / 50,
                                          child: ElevatedButton.icon(
                                            onPressed: _transactionApproved,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 20,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                            ),
                                            icon: Icon(
                                              MaterialCommunityIcons
                                                  .account_check,
                                              size: 24.0,
                                              color: Colors.white,
                                            ),
                                            label: Text(
                                              'Approve Payment',
                                              style: GoogleFonts.poppins(
                                                fontSize: fontsize / 160,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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

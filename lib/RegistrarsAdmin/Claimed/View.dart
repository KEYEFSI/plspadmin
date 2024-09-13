import 'package:plsp/RegistrarsAdmin/Claimed/Controller.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/Counter.dart';
import 'package:plsp/RegistrarsAdmin/Claimed/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ViewPage extends StatefulWidget {
  final String user;
  final VoidCallback onCallback;
  final String admin;
 
  const ViewPage({
    super.key,
    required this.user,
    required this.onCallback,
    required this.admin,
    required this.fontsize,
    required this.height,
    required CollegeDocumentRequest? selectedStudent,
  }) : _selectedStudent = selectedStudent;

   final double fontsize;
  final double height;
  final CollegeDocumentRequest? _selectedStudent;

  @override
  State<ViewPage> createState() => _ViewPageState();
}



class _ViewPageState extends State<ViewPage> {
      late Future<List<DocumentList>> _documentsFuture;
  final CollegePaidDocumentController _updateController=
      CollegePaidDocumentController();


   @override
  void initState() {
    super.initState();
    _documentsFuture = Document().fetchDocuments();
  }

Future<void> _updateDocumentToClaimable() async {
  final DateTime date = widget._selectedStudent!.requestDate!.toLocal();

  for (var document in widget._selectedStudent!.documents) {
    CollegePaidDocument paidDocument = CollegePaidDocument(
      username: widget._selectedStudent!.username.toString(),
      documentName: document.documentName,
      date: date,
      requirements1: document.requirements1,
      requirements2: document.requirements2,
      admin: document.admin, // Add admin field here
    );

    bool success = await _updateController.updateCollegePaidDocumentToClaimable(paidDocument);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Document updated to claimed successfully"),
      ));

      widget.onCallback();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to update document"),
      ));
    }
  }
}

   @override
  Widget build(BuildContext context) {


    final birthday = widget._selectedStudent?.birthday?.toLocal();
    final _birthday = birthday != null
        ? DateFormat('MMM dd, yyyy').format(birthday)
        : 'Unknown';
    final reqdate = widget._selectedStudent?.requestDate?.toLocal();
    final requestdate = reqdate != null
        ? DateFormat('EEE, MMM dd, yyyy').format(reqdate)
        : 'Unknown';

    return  Expanded(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.fontsize / 120.0,
                    vertical: widget.height / 45.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: widget._selectedStudent != null
        ? Column(children: [
                      Expanded(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: widget.fontsize / 52.6,
                                    top: widget.height / 32),
                                child: Container(
                                  width: widget.fontsize / 12.64,
                                  height: widget.height / 7,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.greenAccent,
                                        Colors.green.shade900
                                      ],
                                      stops: [0, 1],
                                      begin: AlignmentDirectional(0, -1),
                                      end: AlignmentDirectional(0, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: widget._selectedStudent != null
                                          ? Image.network(
                                              '$Purl${widget._selectedStudent?.profileImage}',
                                              width: 32,
                                              height: widget.height / 16.95,
                                              fit: BoxFit.cover,
                                              headers: kHeader,
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 50,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Gap(widget.fontsize / 100),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.only(
                                  top: widget.height / 40,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget._selectedStudent?.username}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green.shade900,
                                        fontSize: widget.fontsize / 80,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Gap(1),
                                    Text(
                                      '${widget._selectedStudent?.fullname}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.green.shade900,
                                        fontSize: widget.fontsize / 80,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                            ]),
                      ),
                     
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: widget.fontsize / 80.0,
                                horizontal: widget.height / 42.375),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: Offset(0, 5),
                                    )
                                  ]),
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      widget.fontsize / 120,
                                      widget.height / 63.5625,
                                      widget.fontsize / 120,
                                      widget.height / 63.5625),
                                  child: Column(children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          '$requestdate',
                                          style: GoogleFonts.poppins(
                                            color: Colors.green.shade900,
                                            fontSize: widget.fontsize / 80,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(widget.height / 150),
                                    Expanded(
                                        flex: 6,
                                        child:
                                            FutureBuilder<List<DocumentList>>(
                                                future: _documentsFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child:
                                                           Lottie.asset(
                                           'assets/Loading.json',
                                                  fit: BoxFit.contain,
                                                ),);
                                                  }

                                                  if (snapshot.hasError) {
                                                    return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                                                  }

                                                  if (!snapshot.hasData ||
                                                      snapshot.data!.isEmpty) {
                                                    return  Lottie.asset('assets/Empty.json', 
                              fit: BoxFit.contain);
                                                  }

                                                  final documents =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    itemCount: widget
                                                        ._selectedStudent!
                                                        .documents
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      CollegeDocument document = widget
                                                          ._selectedStudent!
                                                          .documents[index];
                                                      final matchingDocument =
                                                          documents.firstWhere(
                                                        (doc) =>
                                                            doc.documentName ==
                                                            document
                                                                .documentName,
                                                      );

                                                      // Retrieve requirements
                                                      final requirements1String =
                                                          matchingDocument
                                                              .requirements1;
                                                      final requirements2String =
                                                          matchingDocument
                                                              .requirements2;
                                                      return Row(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                document
                                                                    .documentName,
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color: Colors
                                                                      .green
                                                                      .shade900,
                                                                  fontSize:
                                                                      widget.fontsize /
                                                                          80,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Requirements: ',
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        widget.fontsize /
                                                                            120,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        widget.fontsize /
                                                                            100,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      '$requirements1String :',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            widget.fontsize /
                                                                                100,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${document.requirements1}',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            widget.fontsize /
                                                                                100,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                    Gap(widget
                                                                            .fontsize /
                                                                        100),
                                                                    Text(
                                                                      '$requirements2String :',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            widget.fontsize /
                                                                                100,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      '${document.requirements2}',
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            widget.fontsize /
                                                                                100,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            8,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  children: [],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                })),
                                    Container(
                                      width: double.infinity, // Full width
                                      height: widget.height / 20, // Height
                                      child: ElevatedButton.icon(
                                        onPressed: _updateDocumentToClaimable,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                        icon: Icon(
                                          MaterialCommunityIcons.account_check,
                                          size: 24.0,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          'Mark as Ready to Claim',
                                          style: GoogleFonts.poppins(
                                            fontSize: widget.fontsize / 80,
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
                                    )
                                  ])),
                            ),
                          ),
                        ),
                      ),
                    ]): Lottie.asset('assets/DesignAcc.json')
                
                    )
                    )
                    );
        
  }
}



import 'package:gap/gap.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'Controller.dart';
import 'Model.dart';
import 'PendingList.dart';

class ViewRequestPage extends StatefulWidget {
  const ViewRequestPage({
    super.key,
    required StudentModel? selectedStudent,
    required this.fontsize,
    required this.height,
    required this.widget,
    required this.onClearSelection,
    required this.window,
    required this.admin,
  }) : _selectedStudent = selectedStudent;

  final StudentModel? _selectedStudent;
  final double fontsize;
  final double height;
  final PendingList widget;
  final String window;
  final VoidCallback onClearSelection;
  final String admin;

  @override
  State<ViewRequestPage> createState() => _ViewRequestPageState();
}

class _ViewRequestPageState extends State<ViewRequestPage> {
  
  final _formKey = GlobalKey<FormState>();

  String? selectedUsername;
  final ObtainedRequestController _controller = ObtainedRequestController();



  
    @override
  void initState() {
    super.initState();
    // Initially select the username and fetch the data
    _onUsernameSelected(widget._selectedStudent!.username);
  }

  @override
  void didUpdateWidget(ViewRequestPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the username has changed
    if (oldWidget._selectedStudent!.username != widget._selectedStudent!.username) {
      // If it has changed, fetch the new data
      _onUsernameSelected(widget._selectedStudent!.username);
    }
  }

  void _onUsernameSelected(String username) {
    setState(() {
      selectedUsername = username;
    });
    _controller.fetchObtainedRequests(username); // Fetch new data for the new username
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                              'Student Data',
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
                            'Student Information: ',
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
                                            color: Colors.green[
                                                900], // Icon color for the placeholder
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
                                        widget._selectedStudent!.username,
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
                                        widget._selectedStudent!.fullname,
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
                                        widget._selectedStudent!.program,
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.fontsize / 120,
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Gap(height / 80),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 4,
                          ),
                          Gap(widget.fontsize / 200),
                          Text(
                            'Document Requests Details: ',
                            style: GoogleFonts.poppins(
                              fontSize: widget.fontsize / 100,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(widget.fontsize / 100),
                          Expanded(
                            child: StreamBuilder<List<ObtainedRequest>?>(
                                stream: _controller.obtainedRequestsStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot.error}'));
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    return Lottie.asset('assets/error.json', fit: BoxFit.contain);
                                  }

                                  final obtainedRequests = snapshot.data!
                                    ..sort((a, b) {
                                      final dateA = a.obtainedDate;
                                      final dateB = b.obtainedDate;

                                      if (dateA == null && dateB == null)
                                        return 0;
                                      if (dateA == null)
                                        return 1; // Nulls go last
                                      if (dateB == null)
                                        return -1; // Nulls go last

                                      return dateB
                                          .compareTo(dateA); // Descending order
                                    });

                                  return ListView.builder(
                                      itemCount: obtainedRequests.length,
                                      itemBuilder: (context, index) {
                                        final request = obtainedRequests[index];

                                        final date =
                                            request.obtainedDate != null
                                                ? DateTime.parse(request
                                                        .obtainedDate
                                                        .toString())
                                                    .toLocal()
                                                : null;

                                        final formattedDate = date != null
                                            ? DateFormat('MM.dd.yyyy')
                                                .format(date)
                                            : 'N/A';
                                        return Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.green.shade100,
                                                  Colors.white
                                                ],
                                                stops: [0.6, 1],
                                                begin:
                                                    AlignmentDirectional(0, -1),
                                                end: AlignmentDirectional(0, 1),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      fontsize / 120)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        fontsize / 161.0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${request.documentName}',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors
                                                            .green.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 80),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        fontsize / 80.0),
                                                child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      '${request.requirements1 ?? ''} | ${request.requirements2 ?? ''}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  fontsize / 90,
                                                              letterSpacing: 0,
                                                              wordSpacing: 0),
                                                    )),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: fontsize / 80.0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${formattedDate} | ${request.adminAssigned}',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors
                                                            .grey.shade900,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            fontsize / 110),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                                thickness: 1,
                                                color: Colors.grey.shade300,
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          )
                        ],
                      ),
                    ),
                  ))));
    });
  }
}

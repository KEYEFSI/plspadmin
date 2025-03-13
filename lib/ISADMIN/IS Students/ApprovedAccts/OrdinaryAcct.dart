import 'package:gap/gap.dart';
import 'package:plsp/SuperAdminRegistrar/Students/ApprovedAccts/Controller.dart';
import 'package:plsp/SuperAdminRegistrar/Students/ApprovedAccts/Model.dart';
import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OrdinaryAcct extends StatefulWidget {
  const OrdinaryAcct({
    super.key,
  });

  @override
  State<OrdinaryAcct> createState() => _OrdinaryAcctState();
}

class _OrdinaryAcctState extends State<OrdinaryAcct> {

  late OrdinaryStudentController _controller;
  // final DeleteStudentController controller = DeleteStudentController();
  int? hoveredIndex;

// void _approveStudent(String username) async {
//   await controller.deleteStudent(username);
// }

  @override
  void initState() {
    super.initState();
    _controller = OrdinaryStudentController();
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

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(fontsize / 100.0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gap(fontsize / 80),
                  Text('  Image',
                      style: GoogleFonts.poppins(
                        fontSize: fontsize / 80,
                        color: Colors.grey,
                      )),
                  Gap(fontsize / 80),
                  Expanded(
                    child: Text('Fullname',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Student No.',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Email',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                  Expanded(
                    child: Text('Program',
                        style: GoogleFonts.poppins(
                          fontSize: fontsize / 80,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey,
            ),
            Expanded(
              child: StreamBuilder<List<OrdinaryStudent>>(
                stream: _controller.studentsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    final students = snapshot.data!;
                    return ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        final isHovered = hoveredIndex == index;

                        final profileImageUrl = student.profileImage != null
                            ? '$Purl${student.profileImage}'
                            : null;
                        
                        return MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                hoveredIndex = index;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                hoveredIndex = null;
                              });
                            },
                            child: Transform(
                                transform: isHovered
                                    ? (Matrix4.identity()
                                      ..scale(1.01)) // Scale up on hover
                                    : Matrix4.identity(),
                                alignment: Alignment.center,
                                child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isHovered
                                          ? [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 3,
                                                blurRadius: 5,
                                              )
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 2,
                                              )
                                            ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: isHovered
                                              ? Colors.white12
                                              : Colors.white),
                                      child: Column(
                                        children: [
                                          Gap(height / 100),
                                          Row(children: [
                                            Gap(fontsize / 80),
                                            Container(
                                              width: fontsize / 19.2,
                                              height: height / 10.17,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.greenAccent,
                                                    Colors.green
                                                  ],
                                                  stops: [0, 1],
                                                  begin: AlignmentDirectional(
                                                      0, -1),
                                                  end: AlignmentDirectional(
                                                      0, 1),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: profileImageUrl != null
                                                      ? Image.network(
                                                          profileImageUrl,
                                                          width: 32,
                                                          height:
                                                              height / 16.95,
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
                                            Gap(fontsize / 80),
                                            Expanded(
                                              child: Text(
                                                  student.fullname ?? '',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: fontsize / 90,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            Expanded(
                                              child: Text(
                                                  student.username ?? '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 90,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Text(student.email ?? '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            Gap(fontsize/80),
                                            Expanded(
                                              
                                              child: Text(student.program ?? '',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: fontsize / 100,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                          ]),
                                          Gap(height / 100),
                                        ],
                                      ),
                                    ))));
                      },
                    );
                  } else {
                    return Center(child: Text("No data found"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

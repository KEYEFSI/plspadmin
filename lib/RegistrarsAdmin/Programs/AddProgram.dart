import 'package:plsp/RegistrarsAdmin/Programs/Controller.dart';

import 'package:plsp/RegistrarsAdmin/Programs/Model.dart';

import 'package:plsp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';


class AddProgram extends StatefulWidget {
      final VoidCallback onCallback;

  const AddProgram({
    super.key, 
    required this.onCallback,
  });

  @override
  State<AddProgram> createState() => _AddProgramState();
}

class _AddProgramState extends State<AddProgram> {
  late TextEditingController _acronymController;
  late TextEditingController _programController;

  final InsertController _controller = InsertController();

  @override
  void initState() {
    super.initState();
    _acronymController = TextEditingController();
    _programController = TextEditingController();
  

  }


Future<void> _insertCourse() async {
    String acronym = _acronymController.text;
    String program = _programController.text;

    Courses newCourse = Courses(acronym: acronym, program: program);
    bool success = await _controller.insertCourse(newCourse);

    if (success) {

      widget.onCallback();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course inserted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to insert course.')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
        final fontsize = (MediaQuery.of(context).size.width);
    final height = (MediaQuery.of(context).size.height);


    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
              Expanded(
                child: Padding(
                  padding:  EdgeInsets.all(fontsize/80.0),
                  child: Column(
                    children: [
                  Expanded(
                    child: Row(
                      children: [
                        
                         Gap(fontsize/200),
                        Expanded(
                          child: Text('Add Program',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: fontsize/100.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900
                            ),),
                        ),  
                        
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(


children: [
  Gap(fontsize/120),
    Container(
                    height: height/17,
                    child: TextFormField(
                      controller: _acronymController,
                      decoration: InputDecoration(
                        labelText: 'Acronym',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize / 120,
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
                          MaterialCommunityIcons.code_brackets,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(height/400),
                     Container(
                    height: height/17,
                    child: TextFormField(
                      controller: _programController,
                      decoration: InputDecoration(
                        labelText: 'Program Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize / 120,
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
                          AntDesign.appstore1,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize/120
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(fontsize/400),
                   Container(
                     height: height/17,
                            width: double.infinity, // Full width
                           // Height
                            child: ElevatedButton.icon(
                              onPressed:_insertCourse
                              
                              
                             ,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Set background color to transparent
                                elevation:
                                    20, // Remove elevation if you want to apply your own shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              icon: Icon(
                               MaterialCommunityIcons.account_check, // Replace with your desired icon
                                size: 24.0,
                                color: Colors.white, // Adjust size as needed
                              ),
                              label: Text(
                                'Add Program',
                                style: GoogleFonts.poppins(
                                  fontSize:fontsize/160,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context)
                                      .dividerColor, // Text color
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor, // Background color
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          )


],
                      
                    ))
                      
                    ],
                  ),
                ),
              ),
              Gap(fontsize/200),
              Expanded(child: Center(
                child: Lottie.network('https://lottie.host/c1dc38a5-4e83-4294-9fca-3f98aeeb9a2e/pgZQQyx349.json',
                                         fit: BoxFit.contain),
              ))
            ])));
  }
}

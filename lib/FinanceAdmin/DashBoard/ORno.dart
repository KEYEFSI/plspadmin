

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Model.dart';
import 'controller.dart';

class OrNUmber extends StatefulWidget {
  final VoidCallback onCallback;
  const OrNUmber({
    super.key,
    required Future<CurrentORNumber?> ORFuture,
    required this.fontsize,
    required this.onCallback,
  }) : _ORFuture = ORFuture;

  final Future<CurrentORNumber?> _ORFuture;
  final double fontsize;

  @override
  State<OrNUmber> createState() => _OrNUmberState();
}

class _OrNUmberState extends State<OrNUmber> {
  late TextEditingController _orController;
  final _controller = ORNumberController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _orController = TextEditingController();
  }

  void _updateORNumber() async {
    setState(() {
      _isLoading = true;
    });

    final OR = int.tryParse(_orController.text);
    final mainOr = OR! - 1;
    int orNumber = mainOr;
    bool success = await _controller.updateORNumber(orNumber);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      widget.onCallback();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OR Number updated successfully')),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update OR Number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;
    return FutureBuilder<CurrentORNumber?>(
      future: widget._ORFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset('assets/loading.json'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final currentORNumber = snapshot.data!;
        
          final Mainor = currentORNumber.currentOrNumber + 1;

          _orController.text = Mainor.toString();
          return Expanded(
           
              child: Padding(
            padding: EdgeInsets.only(
                top: widget.fontsize / 150, left: widget.fontsize / 100),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(widget.fontsize / 80)),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text('Last Official Receipt Number:',
                            style: GoogleFonts.poppins(
                              fontSize: widget.fontsize / 160,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors.grey.shade900.withOpacity(0.5),
                            )),
                        
                      ],
                    ),
                   
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.fontsize / 100.0),
                      child: Column(children: [
                        TextFormField(
                          
                          controller: _orController,
                          decoration: InputDecoration(
                            labelText: 'OR Number',
                            labelStyle: GoogleFonts.poppins(
                              fontSize: widget.fontsize / 150,
                              color: Colors.green.shade900,
                              fontWeight: FontWeight.w500,
                            ),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).hintColor,
                                width: 2.0,
                              ),
                              borderRadius:
                                  BorderRadius.circular(12.0),
                            ),
                            
                          ),
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: fontsize/80
                            
                          ),
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the OR Number';
                            }
                            return null;
                          },
                        ),
                        Gap(widget.fontsize / 500),
                         ElevatedButton(
                           onPressed: _updateORNumber,
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
                                   'Save'
                                      ,
                                   style: GoogleFonts.poppins(
                                     fontSize: fontsize / 106,
                                     fontWeight: FontWeight.bold,
                                     color: Colors.white,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       
                      ]),
                    )
                  ],
                )),
          ));
        } else {
          return Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }
}


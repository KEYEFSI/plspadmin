import 'package:plsp/FinanceAdmin/DashBoard/Controllers.dart';
import 'package:plsp/FinanceAdmin/DashBoard/Model.dart';
import 'package:plsp/FinanceAdmin/DashBoard/ORno.dart';
import 'package:plsp/FinanceAdmin/DashBoard/daily.dart';
import 'package:plsp/SuperAdmin/College/CollegeCounterModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
    return Expanded(
      child: Column(
        children: [
          FutureBuilder<CurrentORNumber?>(
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
                return Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.fontsize / 100, left: widget.fontsize / 100),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(widget.fontsize / 80)),
                      child: Padding(
                        padding: EdgeInsets.all(widget.fontsize / 100.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Text('Last Official Receipt Number:',
                                    style: GoogleFonts.poppins(
                                      fontSize: widget.fontsize / 100,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors.grey.shade900.withOpacity(0.5),
                                    )),
                                Text(Mainor.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: widget.fontsize / 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade900,
                                    ))
                              ],
                            ),
                            Gap(widget.fontsize / 80),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.fontsize / 100.0),
                              child: Column(children: [
                                Container(
                                  height: widget.fontsize / 50,
                                  child: TextFormField(
                                    controller: _orController,
                                    decoration: InputDecoration(
                                      labelText: 'New OR Number',
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: widget.fontsize / 100,
                                        color: Colors.green.shade900,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                      prefixIcon: Icon(
                                        Octicons.number,
                                        color: Colors.green.shade900,
                                        size: widget.fontsize / 80,
                                      ),
                                    ),
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the OR Number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Gap(widget.fontsize / 100),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _updateORNumber,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    icon: Icon(
                                      Ionicons.receipt,
                                      size: widget.fontsize / 80.0,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Set New OR Number',
                                      style: GoogleFonts.poppins(
                                        fontSize: widget.fontsize / 100,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                )
                              ]),
                            )
                          ],
                        ),
                      )),
                ));
              } else {
                return Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
          Daily(widget: widget),
        ],
      ),
    );
  }
}


import 'package:audioplayers/audioplayers.dart';
import 'package:gap/gap.dart';
import 'package:plsp/SuperAdmin/Integrated/ISCounterController.dart';
import 'package:plsp/SuperAdmin/Integrated/ISCounterModel.dart';


import 'package:flutter/material.dart';

import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lottie/lottie.dart';


class AddFee extends StatefulWidget {
  const AddFee({
    super.key,
  });

  @override
  State<AddFee> createState() => _AddFeeState();
}

class _AddFeeState extends State<AddFee> {
  final TextEditingController feesController = TextEditingController();
  final AddFeeController _feeController = AddFeeController();
  bool _isLoading = false;

  final AddFeeService _feeService = AddFeeService();


 final TextEditingController _feeNameController = TextEditingController();


void _deleteFee(String feeName) async {
  if (feeName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a fee name')),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Deleting fee...'), duration: Duration(seconds: 2)),
  );

  final controller = DeleteFeeController();
  final success = await controller.deleteFee(feeName);

 
  if (success) {
   
   _showSuccessMessage('Fee deleted successfully!');
    _feeNameController.clear(); // Clear input after successful deletion
  } else {
 
 _showErrorMessage('Failed to delete fee');
  }
}
void _showReasonDialog(String feeName) {
  final reasonController = TextEditingController();
  final fontsize = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Entypo.squared_cross, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Confirm Request Rejection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontsize / 60,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure to remove this Payment?',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontsize / 100,
                color: Colors.black,
              ),
            ),
            Gap(height / 40),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: fontsize / 80,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Call the delete fee function
              _deleteFee(feeName); // Pass feeName to _deleteFee
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontSize: fontsize / 80,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  void initState() {
    super.initState();
    _feeService.startFetching();
  }

  @override
  void dispose() {
    _feeService.stopFetching();
    super.dispose();
  }

  
void _submitFee() async {
  String feeName = feesController.text.trim();

  if (feeName.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a fee name")),
    );
    return;
  }

  if (feeName.length < 3) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fee name must be at least 3 characters long")),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final newFee = AddFeeModel(feeName: feeName);
    bool success = await _feeController.addFee(newFee);

    if (success) {
      _showSuccessMessage('Fee Added Successfully');


    
      feesController.clear();

  Navigator.of(context).pop();
    

    } else {
    _showErrorMessage('Failed to add fee. Please try again.');
      
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An unexpected error occurred: $e"),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final fontsize = (MediaQuery.of(context).size.width);
    final height = MediaQuery.of(context).size.height;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        height: MediaQuery.of(context).size.height / 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [

               Expanded(
                 child: Container(
                  

                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      Text('Payment Lists',
 style: GoogleFonts.poppins(
                                              fontSize: fontsize / 96,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green.shade900,
                                            ),

                      ),
                       Expanded(
                         child: StreamBuilder<List<AddFeeModel>>(
                                 stream: _feeService.feeStream,
                                 builder: (context, snapshot) {
                                   if (snapshot.connectionState == ConnectionState.waiting) {
                                     return Center(child: CircularProgressIndicator());
                                   }
                         
                                   if (snapshot.hasError) {
                                     return Center(child: Text("Error: ${snapshot.error}"));
                                   }
                         
                                   final fees = snapshot.data ?? [];
                         
                                   if (fees.isEmpty) {
                                     return Center(child: Text("No fees available."));
                                   }
                         
                                   return ListView.builder(
                                     itemCount: fees.length,
                                     itemBuilder: (context, index) {
                                       final fee = fees[index];
                                       return Column(
                                         children: [
                                           Container(
                                            
                                                                       child: Row(
                                                                         children: [
                                                                           Expanded(
                            child: Text(
                              (fee.feeName ?? 'Unnamed Fee'),
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: fontsize / 100,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                              message: 'Delete Payment',
                              textStyle: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: fontsize / 100,
                                  fontWeight: FontWeight.bold),
                              decoration: BoxDecoration(
                                  color: Colors.green.shade900,
                                  borderRadius: BorderRadius.circular(14)),
                              child: GestureDetector(
                                onTap: (){ _showReasonDialog(fee.feeName);},
                                child: Icon(
                                  MaterialCommunityIcons.trash_can,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )


                                                                         ],
                                                                       ),
                                           ),
                                         ],
                                       );
                                     },
                                   );
                                 },
                               ),
                       ),
                     ],
                   ),
                 ),
               ),
  
              Text(
                'Create New Payment',
                style: GoogleFonts.poppins(
                  fontSize: fontsize / 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: feesController,
                decoration: InputDecoration(
                  
                  labelText: 'Payment Name',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: fontsize / 137,
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
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).cardColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: false,
                  fillColor: Theme.of(context).primaryColorLight,
                  prefixIcon: Icon(
                    FontAwesome.money,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Gap(height / 80),
              Padding(
                padding: EdgeInsets.only(
                    left: fontsize / 80.0, right: fontsize / 80),
                child: ElevatedButton(
                  onPressed: () {
                    _submitFee();
                    Navigator.of(context).pop();
                  },
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
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: fontsize / 120,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
    );
  }

  
  void _showSuccessMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    player.play(AssetSource('success.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 7,
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade700,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/success.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Awesome!,',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _showErrorMessage(String message) {
    final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    final player = AudioPlayer(); // For playing sound

    // Play sound
    player.play(AssetSource('Error.wav'));

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // Adjust for status bar
        left: fontsize / 1.4,
        right: fontsize / 80,
        child: Material(
          elevation: 10,
          color: Colors.transparent,
          child: Container(
            height: height / 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                Lottie.asset('assets/error.json', fit: BoxFit.contain),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Oh snap!',
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            message,
                            style: GoogleFonts.poppins(
                              fontSize: fontsize / 100,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the specified duration
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

}
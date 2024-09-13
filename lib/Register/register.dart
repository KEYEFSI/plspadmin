import 'package:plsp/Login/login.dart';
import 'package:plsp/Register/registermodel.dart';
import 'package:plsp/Register/secondpane.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/animation.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> with SingleTickerProviderStateMixin {
  late RegisterModel _model; 
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final passwordTextController = TextEditingController();
  late TextEditingController _firstnameController;
  late TextEditingController _middlenameController;
  late TextEditingController _lastnameController;
  var valuechoose;

 
  @override
  void initState() {
    super.initState();
  
 ;


    _firstnameController = TextEditingController();
    _middlenameController = TextEditingController();
    _lastnameController = TextEditingController();
    
  }

  @override
  void dispose() {
    _model.emailAddressTextController?.dispose();
    _model.emailAddressFocusNode?.dispose();
    _model.fullnameFocusNode?.dispose();
  }



  void _handleButtonPress(BuildContext context) {
  if (_firstnameController.text.isEmpty || _middlenameController.text.isEmpty || _lastnameController.text.isEmpty) {
   
   _showErrorMessage('Please fill the information below');
  
  } else {
    _showSuccessMessage("Now, let's capture a few more details.");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondPane(
          firstname: _firstnameController.text,
          middlename: _middlenameController.text,
          lastname: _lastnameController.text,
        ),
      ),
    );
  }
}

  void _showSuccessMessage(String message) {
     final height = MediaQuery.of(context).size.height;
final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 11,
        duration: Duration(seconds: 2),
        content: Container(
         height: height/9,

          decoration: BoxDecoration(
            color: Colors.greenAccent.shade700,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Lottie.asset(
                'assets/success.json',
              fit: BoxFit.contain
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Awesome!,',
                       style: GoogleFonts.poppins(
                        fontSize: fontsize/80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: fontsize/80,
                        fontWeight: FontWeight.normal
                    
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
          ,
        )
      )
    );
  }

  void _showErrorMessage(String message) {
     final height = MediaQuery.of(context).size.height;
final fontsize = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 11,
        duration: Duration(seconds: 2),
        content: Container(
         height: height/9,

          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Lottie.asset(
                'assets/error.json',
              fit: BoxFit.contain
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Oh snap!',
                       style: GoogleFonts.poppins(
                        fontSize: fontsize/80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: fontsize/80,
                        fontWeight: FontWeight.normal
                    
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
          ,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final height = MediaQuery.of(context).size.height;
    final fontsize = MediaQuery.of(context).size.width;

    return  SafeArea(
        child: Scaffold(
     
     
      
      body: 
      SingleChildScrollView(
          child: Container(
           height: height,
            
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundlogin.jpg'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: fontsize/80),
              child: Column(
              
                children: [
                  GestureDetector
                
                      ( onTap:() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginWidget()),
                                            ); },
                       
                    child: Padding(
                      padding:  EdgeInsets.only(top: fontsize/80),
                      child: Align(alignment: Alignment.topLeft,
                        child: Icon(Ionicons.arrow_back_outline,
                        color: Colors.white,
                        size: fontsize/80,),
                      ),
                    ),
                  ),
                    Spacer(),
                   ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: fontsize/8,
                 
                  fit: BoxFit.cover,
                ),
              ),
                Gap(fontsize/120),
                  
                  Container(
                    constraints:  BoxConstraints(maxWidth: fontsize/3.0),
                    padding: const EdgeInsets.all(24.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4.0,
                          color: Theme.of(context).primaryColor,
                          offset: const Offset(0.0, 2.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                   
                      children: [
                        
                        Text(
                          "What's your name?",
                          
                          style: GoogleFonts.poppins(
                            fontSize: fontsize/80,
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Enter the name you use in real life',
                           
                            style: GoogleFonts.poppins(
                              fontSize: fontsize/120,
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Gap(fontsize/80),
                           Container(
                    height: height/20,
                    child: TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize/80,
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
                          MaterialCommunityIcons.account_tie,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: fontsize/80,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(fontsize/80),
                           Container(
                    height: height/20,
                    child: TextFormField(
                      controller: _middlenameController,
                      decoration: InputDecoration(
                        labelText: 'Middle Name',
                        labelStyle: GoogleFonts.poppins(
                          fontSize: fontsize/80,
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
                          MaterialCommunityIcons.account_tie,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                         fontSize: fontsize/80
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Gap(fontsize/80),
                           Container(
                    height: height/20,
                    child: TextFormField(
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: GoogleFonts.poppins(
                      fontSize:fontsize/80,
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
                          MaterialCommunityIcons.account_tie,
                          color: Colors.green.shade900,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize:fontsize/80,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the First Name';
                        }
                        return null;
                      },
                    ),
                  ), 
                 Gap(fontsize/80),
                   Container(
                     height: height/13,
                            width: double.infinity, // Full width
                           // Height
                            child: ElevatedButton.icon(
                              onPressed: () => _handleButtonPress(context),
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
                                'Next',
                                style: GoogleFonts.poppins(
                                 fontSize: fontsize/80,
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
                            ),
                          ),
                        
                      
                    
                  
                     Spacer(),
                            Align(
                                  alignment: Alignment.center,
                                     
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginWidget()),
                                      );
                                    },
                                    child: Text(
                                      "I already have an account",
                                      style: GoogleFonts.poppins(
                                        fontSize: fontsize/80,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer()
                ],
              ),
            ),
          ),
      ),

      ),
       
    );
      }

  
}

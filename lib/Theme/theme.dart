import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF046007);
const Color secondaryColor = Color(0xFF009B00);
const Color tertiaryColor = Color(0xFF99E79B);
const Color alternate=Color(0xFFB5B5B5);
const Color primarytext=Color.fromRGBO(33, 33, 33, 1);
const Color secondarytext=Color.fromRGBO(117, 117, 117, 1);
const Color primaryBackground = Color.fromRGBO(255, 255, 255, 1);
const Color secondaryBackground = Color.fromARGB(252, 243, 239, 239);
const Color accent1 = Color.fromRGBO(4, 99, 7, 1);
const Color accent2 = Color.fromRGBO(12, 252, 39, 0.52);
const Color success = Color.fromRGBO(76, 175, 80, 1);
const Color error = Color.fromRGBO(244, 67, 54, 1);
const Color warning = Color.fromRGBO(255, 152, 0, 1);
const Color info = Color.fromRGBO(33, 150, 243, 1);


const Color primaryColorDark = Color(0xFF046007);
const Color secondaryColorDark = Color(0xFF046007);
const Color tertiaryColorDark = Color(0xFF046007);
const Color alternateDark=Color(0xFF046007);
const Color primarytextDark=Color(0xFF046007);
const Color secondarytextDark=Color(0xFF046007);
const Color primaryBackgroundDark = Color(0xFFFFFFFF);
const Color secondaryBackgroundDark = Color(0xFFFFFFFF);
const Color accent1Dark = Color(0xFFFFFFFF);
const Color accent2Dark = Color(0xFFFFFFFF);
const Color accent3Dark = Color(0xFFFFFFFF);
const Color accent4Dark = Color(0xFFFFFFFF);
const Color successDark = Color(0xFFFFFFFF);
const Color errorDark = Color(0xFFFFFFFF);
const Color warningDark = Color(0xFFFFFFFF);
const Color infoDark = Color(0xFFFFFFFF);


class MyTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: primaryColor,
        secondaryHeaderColor: secondaryColor,
        hintColor: tertiaryColor,
        focusColor: alternate,
        hoverColor: primarytext,
        canvasColor: secondarytext,
        dividerColor: primaryBackground,
        primaryColorLight: secondaryBackground,
        primaryColorDark: accent1,
        indicatorColor: accent2,
        disabledColor: success,
        cardColor: error,
        unselectedWidgetColor: warning,
        highlightColor: info,


      textTheme: const TextTheme(
        labelLarge: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: primarytext),
        labelSmall: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic, color: secondarytext),
     

        labelMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500, color: primarytext),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueGrey,
      primaryColorLight: Colors.blueGrey[300],
      primaryColorDark: Colors.blueGrey[700],
      hintColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
      textTheme: const TextTheme(
        labelLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        labelSmall: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

extension CustomTheme on BuildContext {
  ThemeData get theme => Theme.of(this);
}

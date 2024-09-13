

import 'dart:convert';




class CourseWithStudentCount {
  final String acronym;
  final String program;
  final int studentCount;


  CourseWithStudentCount({
    required this.acronym,
    required this.program,
    required this.studentCount,

  });

  // Factory constructor to create an instance from JSON
  factory CourseWithStudentCount.fromJson(Map<String, dynamic> json) {
    return CourseWithStudentCount(
      acronym: json['Acronym'],
      program: json['Program'],
      studentCount: json['studentCount'],
   
    );
  }

  // Convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Acronym': acronym,
      'Program': program,
      'studentCount': studentCount,
   
    };
  }
}

class Courses {
  final String acronym;
  final String program;

  Courses({
    required this.acronym,
    required this.program,
  });

  factory Courses.fromJson(Map<String, dynamic> json) {
    return Courses(
      acronym: json['Acronym'] ?? '', 
      program: json['Program'] ?? '', 
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'Acronym': acronym,
      'Program': program,
    };
  }
}

List<Courses> parseCourses(String responseBody) {
  final List<dynamic> parsed = json.decode(responseBody);
  return parsed.map<Courses>((json) => Courses.fromJson(json)).toList();
}


class CounterData {
  final int collegeUserCount;
  final int totalCourseCount;

  CounterData({
    required this.collegeUserCount,
    required this.totalCourseCount,
  });

  factory CounterData.fromJson(Map<String, dynamic> json) {
    return CounterData(
      collegeUserCount: json['college_user_count'],
      totalCourseCount: json['total_course_count'],
    );
  }
}
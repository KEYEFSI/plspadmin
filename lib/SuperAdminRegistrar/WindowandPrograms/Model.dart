
class Window {
  final int windowName; // Corresponds to the "Window Name" column in the database
  final List<String>? programs; // "Programs" is nullable and can be a List of Strings

  Window({
    required this.windowName,
    this.programs, // Nullable programs
  });

  /// Factory method to create a `Window` instance from JSON
  factory Window.fromJson(Map<String, dynamic> json) {
    return Window(
      windowName: json['windowName'] as int,
      programs: json['programs'] != null
          ? List<String>.from(json['programs']) // Parse if not null
          : null, // Set to null if missing
    );
  }

  /// Convert the `Window` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'windowName': windowName,
      'programs': programs ?? [], // Default to an empty list if null
    };
  }
}

class WindowCreate {
  final int windowName;
  final List<String> programs;

  WindowCreate({
    required this.windowName,
    required this.programs,
  });

  factory WindowCreate.fromJson(Map<String, dynamic> json) {
    return WindowCreate(
      windowName: json['windowName'],
      programs: List<String>.from(json['programs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'windowName': windowName,
      'programs': programs,
    };
  }
}

class UnselectedProgram {
  final String? program;
  final String? acronym;

  // Constructor
  UnselectedProgram({this.program, this.acronym});

  // Factory method to create an instance from JSON
  factory UnselectedProgram.fromJson(Map<String, dynamic> json) {
    return UnselectedProgram(
      program: json['program'] as String?, // Use null-aware type
      acronym: json['acronym'] as String?, // Use null-aware type
    );
  }

  // Method to convert the instance back to JSON (optional, if needed)
  Map<String, dynamic> toJson() {
    return {
      'program': program,
      'acronym': acronym,
    };
  }
}


class AddProgramRequest {
  final int windowName;
  final String program;

  AddProgramRequest({
    required this.windowName,
    required this.program,
  });

  Map<String, dynamic> toJson() {
    return {
      "window_name": windowName,
      "program": program,
    };
  }
}

class DeleteProgramResponse {
  final bool success;
  final String message;

  DeleteProgramResponse({required this.success, required this.message});

  factory DeleteProgramResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProgramResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}

class CourseModel {
  final String acronym;
  final String program;

  CourseModel({required this.acronym, required this.program});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      acronym: json['acronym'],
      program: json['program'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acronym': acronym,
      'program': program,
    };
  }
}
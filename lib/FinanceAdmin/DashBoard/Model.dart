class CurrentORNumber {
  final int currentOrNumber;  // Changed from String to int

  CurrentORNumber({required this.currentOrNumber});

  factory CurrentORNumber.fromJson(Map<String, dynamic> json) {
    return CurrentORNumber(
      currentOrNumber: json['current_or_number'],  // Ensure this is treated as an int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_or_number': currentOrNumber,  // Convert int to JSON
    };
  }
}



class RequestStatistics {
  final int studentsCount;
  final int totalUnpaidRequests;
  final int totalPaidRequests;
  final int totalRequests;
  final int dailyRequests;
  final int dailyPaidRequests;
  final String dailyRequestPercentage;
  final String dailyPaidPercentage;
  final String dailyRequestChange;
  final String dailyPaidChange;
  final bool hasRequestIncreased;
  final bool hasPaidRequestIncreased;

  RequestStatistics({
    required this.studentsCount,
    required this.totalUnpaidRequests,
    required this.totalPaidRequests,
    required this.totalRequests,
    required this.dailyRequests,
    required this.dailyPaidRequests,
    required this.dailyRequestPercentage,
    required this.dailyPaidPercentage,
    required this.dailyRequestChange,
    required this.dailyPaidChange,
    required this.hasRequestIncreased,
    required this.hasPaidRequestIncreased,
  });

  factory RequestStatistics.fromJson(Map<String, dynamic> json) {
    return RequestStatistics(
      studentsCount: json['studentsCount'] ?? 0,
      totalUnpaidRequests: json['totalUnpaidRequests'] ?? 0,
      totalPaidRequests: json['totalPaidRequests'] ?? 0,
      totalRequests: json['totalRequests'] ?? 0,
      dailyRequests: json['dailyRequests'] ?? 0,
      dailyPaidRequests: json['dailyPaidRequests'] ?? 0,
      dailyRequestPercentage: json['dailyRequestPercentage'] ?? '0.00',
      dailyPaidPercentage: json['dailyPaidPercentage'] ?? '0.00',
      dailyRequestChange: json['dailyRequestChange'] ?? '0.00',
      dailyPaidChange: json['dailyPaidChange'] ?? '0.00',
      hasRequestIncreased: json['hasRequestIncreased'] ?? false,
      hasPaidRequestIncreased: json['hasPaidRequestIncreased'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentsCount': studentsCount,
      'totalUnpaidRequests': totalUnpaidRequests,
      'totalPaidRequests': totalPaidRequests,
      'totalRequests': totalRequests,
      'dailyRequests': dailyRequests,
      'dailyPaidRequests': dailyPaidRequests,
      'dailyRequestPercentage': dailyRequestPercentage,
      'dailyPaidPercentage': dailyPaidPercentage,
      'dailyRequestChange': dailyRequestChange,
      'dailyPaidChange': dailyPaidChange,
      'hasRequestIncreased': hasRequestIncreased,
      'hasPaidRequestIncreased': hasPaidRequestIncreased,
    };
  }
}


class HolidayEvent {
  final String eventName;
  final DateTime date;

  HolidayEvent({required this.eventName, required this.date});

  factory HolidayEvent.fromJson(Map<String, dynamic> json) {
    return HolidayEvent(
      eventName: json['event_name'],
      date: DateTime.parse(json['date']),
    );
  }
}

class RequestCountsByDate {
  final DateTime date;
  final int paidRequests;
  final int unpaidRequests;

  RequestCountsByDate({
    required this.date,
    required this.paidRequests,
    required this.unpaidRequests,
  });

  factory RequestCountsByDate.fromJson(Map<String, dynamic> json) {
    return RequestCountsByDate(
      date: DateTime.parse(json['date']),
      paidRequests: json['paidRequests'],
      unpaidRequests: json['unpaidRequests'],
    );
  }
}

class CombinedData {
  final List<RequestCountsByDate> graduatesRequestsByDate;
  final List<RequestCountsByDate> collegeRequestsByDate;
  final List<RequestCountsByDate> isRequestsByDate;
  final List<HolidayEvent> holidayDates;

  CombinedData({
    required this.graduatesRequestsByDate,
    required this.collegeRequestsByDate,
    required this.isRequestsByDate,
    required this.holidayDates,
  });

  factory CombinedData.fromJson(Map<String, dynamic> json) {
    return CombinedData(
      graduatesRequestsByDate: (json['graduatesRequestsByDate'] as List)
          .map((data) => RequestCountsByDate.fromJson(data))
          .toList(),
      collegeRequestsByDate: (json['collegeRequestsByDate'] as List)
          .map((data) => RequestCountsByDate.fromJson(data))
          .toList(),
      isRequestsByDate: (json['isRequestsByDate'] as List)
          .map((data) => RequestCountsByDate.fromJson(data))
          .toList(),
      holidayDates: (json['holidayDates'] as List)
          .map((data) => HolidayEvent.fromJson(data))
          .toList(),
    );
  }
}


class RequestCountsToday {
  final String today;
  final RequestCount graduatesRequests;
  final RequestCount collegeRequests;
  final RequestCount isRequests;

  RequestCountsToday({
    required this.today,
    required this.graduatesRequests,
    required this.collegeRequests,
    required this.isRequests,
  });

  factory RequestCountsToday.fromJson(Map<String, dynamic> json) {
    return RequestCountsToday(
      today: json['today'],
      graduatesRequests: RequestCount.fromJson(json['graduatesRequests']),
      collegeRequests: RequestCount.fromJson(json['collegeRequests']),
      isRequests: RequestCount.fromJson(json['isRequests']),
    );
  }
}

class RequestCount {
  final int paidRequests;
  final int unpaidRequests;

  RequestCount({
    required this.paidRequests,
    required this.unpaidRequests,
  });

  factory RequestCount.fromJson(Map<String, dynamic> json) {
    return RequestCount(
      paidRequests: json['paidRequests'] ?? 0,
      unpaidRequests: json['unpaidRequests'] ?? 0,
    );
  }
}

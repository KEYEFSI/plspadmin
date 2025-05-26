

class RequestCountsToday {
  final int totalStudents;
  final int totalRequests;
  final DocumentStatus pending;
  final DocumentStatus approved;
  final DocumentStatus paid;
  final DocumentStatus completed;
  final DocumentStatus obtained;
  final DocumentStatus rejected;

  RequestCountsToday({
    required this.totalStudents,
    required this.totalRequests,
    required this.pending,
    required this.approved,
    required this.paid,
    required this.completed,
    required this.obtained,
    required this.rejected,
  });

  factory RequestCountsToday.fromJson(Map<String, dynamic> json) {
    return RequestCountsToday(
      totalStudents: json['totalStudents'] as int? ?? 0,
      totalRequests: json['totalRequests'] as int? ?? 0,
      pending: DocumentStatus.fromJson(json['documentRequests']['pending']),
      approved: DocumentStatus.fromJson(json['documentRequests']['approved']),
      paid: DocumentStatus.fromJson(json['documentRequests']['paid']),
      completed: DocumentStatus.fromJson(json['documentRequests']['completed']),
      obtained: DocumentStatus.fromJson(json['documentRequests']['obtained']),
      rejected: DocumentStatus.fromJson(json['documentRequests']['rejected']),
    );
  }
}

class DocumentStatus {
  final int count;
  final double percentage;
  final bool increase;

  DocumentStatus({
    required this.count,
    required this.percentage,
    required this.increase,
  });

  factory DocumentStatus.fromJson(Map<String, dynamic> json) {
    return DocumentStatus(
      count: json['count'] as int? ?? 0,
      percentage: (json['percentage'] is String)
          ? double.tryParse(json['percentage']) ?? 0.0
          : (json['percentage'] as num?)?.toDouble() ?? 0.0,
      increase: json['increase'] as bool? ?? false,
    );
  }
}



class RequestByDate {
  final String date;
  final int paidRequests;
  final int unpaidRequests;
  final String percentageChange;
  final bool isIncreased;

  RequestByDate({
    required this.date,
    required this.paidRequests,
    required this.unpaidRequests,
    required this.percentageChange,
    required this.isIncreased,
  });

  factory RequestByDate.fromJson(Map<String, dynamic> json) {
    return RequestByDate(
      date: json['date'] as String,
      paidRequests: json['paidRequests'] as int,
      unpaidRequests: json['unpaidRequests'] as int,
      percentageChange: json['percentageChange'] as String,
      isIncreased: json['isIncreased'] as bool,
    );
  }
}

class RequestStats {
  final int pending;
  final int approved;
  final int paid;
  final int completed;
  final int obtained;

  RequestStats({
    required this.pending,
    required this.approved,
    required this.paid,
    required this.completed,
    required this.obtained,
  });

  factory RequestStats.fromJson(Map<String, dynamic> json) {
    return RequestStats(
      pending: json['documentRequests']['pending'] ?? 0,
      approved: json['documentRequests']['approved'] ?? 0,
      paid: json['documentRequests']['paid'] ?? 0,
      completed: json['documentRequests']['completed'] ?? 0,
      obtained: json['documentRequests']['obtained'] ?? 0,
    );
  }
}

class HolidayDate {
  final String eventName;
  final DateTime date;

  HolidayDate({
    required this.eventName,
    required this.date,
  });

  factory HolidayDate.fromJson(Map<String, dynamic> json) {
    return HolidayDate(
      eventName: json['eventName'] ?? 'Unknown Event',
      date: DateTime.tryParse(json['date']?.toString() ?? '')?.toLocal() ?? DateTime(1970, 1, 1),
    );
  }
}

class RequestData {
  final DateTime date;
  final int pending;
  final int approved;
  final int paid;
  final int completed;
  final int obtained;

  RequestData({
    required this.date,
    required this.pending,
    required this.approved,
    required this.paid,
    required this.completed,
    required this.obtained,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
      date: DateTime.tryParse(json['date']?.toString() ?? '')?.toLocal() ?? DateTime(1970, 1, 1),
      pending: int.tryParse(json['Pending']?.toString() ?? '0') ?? 0,
      approved: int.tryParse(json['Approved']?.toString() ?? '0') ?? 0,
      paid: int.tryParse(json['Paid']?.toString() ?? '0') ?? 0,
      completed: int.tryParse(json['Completed']?.toString() ?? '0') ?? 0,
      obtained: int.tryParse(json['Obtained']?.toString() ?? '0') ?? 0,
    );
  }
}

class CombinedData {
  final List<RequestData> requestsByDate;
  final List<HolidayDate> holidayDates;

  CombinedData({
    required this.requestsByDate,
    required this.holidayDates,
  });

  factory CombinedData.fromJson(Map<String, dynamic> json) {
    return CombinedData(
      requestsByDate: (json['requestsByDate'] as List<dynamic>?)?.map((item) => RequestData.fromJson(item)).toList() ?? [],
      holidayDates: (json['holidays'] as List<dynamic>?)?.map((item) => HolidayDate.fromJson(item)).toList() ?? [],
    );
  }
}

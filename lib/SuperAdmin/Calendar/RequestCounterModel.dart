


class RequestCount {
  final String date;
  final int isRequests;
  final int graduatesRequests;
  final int collegeRequests;
  final int totalCount;

  RequestCount({
    required this.date,
    required this.isRequests,
    required this.graduatesRequests,
    required this.collegeRequests,
    required this.totalCount,
  });

  factory RequestCount.fromJson(Map<String, dynamic> json) {
    return RequestCount(
      date: json['date'],
      isRequests: json['isRequests'],
      graduatesRequests: json['graduatesRequests'],
      collegeRequests: json['collegeRequests'],
      totalCount: json['total_count'],
    );
  }
}



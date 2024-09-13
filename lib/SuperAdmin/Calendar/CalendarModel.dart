
class HolidayDate {
  final String eventName;
  final DateTime date;

  HolidayDate({required this.eventName, required this.date});

  factory HolidayDate.fromJson(Map<String, dynamic> json) {
    return HolidayDate(
      eventName: json['event_name'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_name': eventName,
      'date': date.toIso8601String(),
    };
  }
}



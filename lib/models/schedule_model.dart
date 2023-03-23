class ScheduleModel {
  final String startTime, endTime, scheduleTitle;
  ScheduleModel(Map<String, dynamic> json)
      : startTime = json['startTime'],
        endTime = json['endTime'],
        scheduleTitle = json['scheduleTitle'];
}
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
      ),
    );
  }
}

class MettingDataSource extends CalendarDataSource {
  MettingDataSource(List<Appointment> sourec) {
    appointments = sourec;
  }
}

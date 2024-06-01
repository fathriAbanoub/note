import 'package:flutter/material.dart';
import 'package:notes/calendar/Google%20_Calendar_%20API.dart';


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarService _calendarService = CalendarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                print('List Calendars button pressed');
                await _calendarService.listCalendars();
              },
              child: Text('List Calendars'),
            ),
            ElevatedButton(
              onPressed: () async {
                print('Create Event button pressed');
                await _calendarService.createEvent();
              },
              child: Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}

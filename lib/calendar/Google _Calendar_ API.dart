import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;
import 'package:notes/calendar/Google%20Sign-In.dart';

class CalendarService {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  Future<void> listCalendars() async {
    final client = await _googleSignInService.getAuthenticatedClient();
    if (client == null) {
      print('Failed to get authenticated client');
      return;
    }

    final calendarApi = CalendarApi(client);

    try {
      final calendarList = await calendarApi.calendarList.list();
      for (var calendar in calendarList.items!) {
        print('Calendar: ${calendar.summary}');
      }
    } catch (e) {
      print('Error listing calendars: $e');
    }
  }

  Future<void> createEvent() async {
    final client = await _googleSignInService.getAuthenticatedClient();
    if (client == null) {
      print('Failed to get authenticated client');
      return;
    }

    final calendarApi = CalendarApi(client);

    try {
      Event event = Event(
        summary: 'New Event',
        start: EventDateTime(
          dateTime: DateTime.now(),
          timeZone: 'GMT+00:00',
        ),
        end: EventDateTime(
          dateTime: DateTime.now().add(Duration(hours: 1)),
          timeZone: 'GMT+00:00',
        ),
      );

      final createdEvent = await calendarApi.events.insert(event, 'primary');
      print('Event created: ${createdEvent.htmlLink}');
    } catch (e) {
      print('Error creating event: $e');
    }
  }
}

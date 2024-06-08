
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:icalendar_parser/icalendar_parser.dart';

import 'Edit_page.dart';

class Calendar_Page extends StatefulWidget {
  const Calendar_Page({super.key});

  @override
  State<Calendar_Page> createState() => _Calendar_PageState();
}

class _Calendar_PageState extends State<Calendar_Page> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[GoogleAPI.CalendarApi.calendarScope],
  );
  GoogleSignInAccount? _currentUser;
  List<GoogleAPI.Event> _events = [];

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _fetchEvents();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _fetchEvents() async {
    if (_currentUser != null) {
      print('Fetching events...');
      await _googleSignIn.signIn();
      final events = await getGoogleEventsData();
      setState(() {
        _events = events;
      });
      print('Events fetched: ${_events.length}');
    }
  }

  Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleAPIClient httpClient = GoogleAPIClient(await googleUser!.authHeaders);
    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    final GoogleAPI.Events calEvents = await calendarApi.events.list("primary");
    final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
    if (calEvents.items != null) {
      for (int i = 0; i < calEvents.items!.length; i++) {
        final GoogleAPI.Event event = calEvents.items![i];
        if (event.start == null) {
          continue;
        }
        appointments.add(event);
      }
    }
    print('Google events data retrieved: ${appointments.length}');
    return appointments;
  }

  Future<void> _addEvent(DateTime date, {GoogleAPI.Event? eventToUpdate}) async {
    final TextEditingController titleController = TextEditingController(
        text: eventToUpdate?.summary ?? '');
    final TextEditingController descriptionController = TextEditingController(
        text: eventToUpdate?.description ?? '');

    // Initialize fixed from and to dates and times
    DateTime fromDate = DateTime(date.year, date.month, date.day, 8, 0); // Fixed from date and time
    DateTime toDate = DateTime(date.year, date.month, date.day, 9, 0); // Fixed to date and time
    TimeOfDay fromTime = TimeOfDay.fromDateTime(fromDate);
    TimeOfDay toTime = TimeOfDay.fromDateTime(toDate);

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              ListTile(
                title: const Text("From Date"),
                subtitle: Text("${fromDate.toLocal()}".split(' ')[0]),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: fromDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != fromDate) {
                    setState(() {
                      fromDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text("From Time"),
                subtitle: Text("${fromTime.format(context)}"),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: fromTime,
                  );
                  if (picked != null && picked != fromTime) {
                    setState(() {
                      fromTime = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text("To Date"),
                subtitle: Text("${toDate.toLocal()}".split(' ')[0]),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: toDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != toDate) {
                    setState(() {
                      toDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text("To Time"),
                subtitle: Text("${toTime.format(context)}"),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: toTime,
                  );
                  if (picked != null && picked != toTime) {
                    setState(() {
                      toTime = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                if (titleController.text.isNotEmpty) {
                  final DateTime startDateTime = DateTime(
                    fromDate.year,
                    fromDate.month,
                    fromDate.day,
                    fromTime.hour,
                    fromTime.minute,
                  );
                  final DateTime endDateTime = DateTime(
                    toDate.year,
                    toDate.month,
                    toDate.day,
                    toTime.hour,
                    toTime.minute,
                  );

                  final GoogleAPI.Event event = GoogleAPI.Event(
                    summary: titleController.text,
                    description: descriptionController.text,
                    start: GoogleAPI.EventDateTime(
                      dateTime: startDateTime,
                      timeZone: 'GMT-0',
                    ),
                    end: GoogleAPI.EventDateTime(
                      dateTime: endDateTime,
                      timeZone: 'GMT-0',
                    ),
                  );

                  final GoogleAPIClient httpClient = GoogleAPIClient(await _currentUser!.authHeaders);
                  final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);

                  if (eventToUpdate != null) {
                    event.id = eventToUpdate.id;
                    await calendarApi.events.update(event, "primary", eventToUpdate.id!);
                    print('Event updated: ${event.summary}');
                  } else {
                    await calendarApi.events.insert(event, "primary");
                    print('Event added: ${event.summary}');
                  }

                  await _fetchEvents();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEventsForDate(DateTime date) async {
    if (_events == null || _events.isEmpty) {
      print('No events found in the list');
      return;
    }

    final eventsForDate = _events.where((event) =>
    event.start != null &&
        event.start!.dateTime != null &&
        event.start!.dateTime!.toLocal().year == date.year &&
        event.start!.dateTime!.toLocal().month == date.month &&
        event.start!.dateTime!.toLocal().day == date.day);

    if (eventsForDate.isEmpty) {
      print('No events found for the selected date');
      return;
    }

    print('Events found for the selected date: ${eventsForDate.length}');

    for (final event in eventsForDate) {
      await _deleteEvent(event);
    }
  }


  Future<void> _deleteEvent(GoogleAPI.Event event) async {
    final GoogleAPIClient httpClient = GoogleAPIClient(await _currentUser!.authHeaders);
    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    await calendarApi.events.delete("primary", event.id!);
    print('Event deleted: ${event.summary}');
    await _fetchEvents();
  }
  Future<void> _editEvent(DateTime date) async {
    GoogleAPI.Event? event;
    for (final e in _events) {
      if (e.start?.dateTime != null) {
        final eventDate = e.start!.dateTime!.toLocal();
        if (eventDate.year == date.year && eventDate.month == date.month && eventDate.day == date.day) {
          event = e;
          break;
        }
      }
    }

    if (event != null) {
      final TextEditingController titleController = TextEditingController(text: event.summary ?? '');
      final TextEditingController descriptionController = TextEditingController(text: event.description ?? '');

      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Event'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _deleteEvent(event!);
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: titleController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: descriptionController,
                ),
                // Add more input fields as needed
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  // Update event with edited details
                  final GoogleAPI.Event updatedEvent = GoogleAPI.Event(
                    id: event!.id,
                    summary: titleController.text,
                    description: descriptionController.text,
                    start: event.start,
                    end: event.end,
                  );

                  final GoogleAPIClient httpClient = GoogleAPIClient(await _currentUser!.authHeaders);
                  final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);

                  await calendarApi.events.update(updatedEvent, "primary", event.id!);
                  print('Event updated: ${updatedEvent.summary}');
                  await _fetchEvents();

                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      if (result == true) {
        print('Event updated successfully');
      }
    } else {
      print('No event found for the selected date');
    }
  }



  Future<void> _importICS() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ics'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String icsContent = await file.readAsString();
      final ICalendar iCalendar = ICalendar.fromString(icsContent);

      final GoogleAPIClient httpClient = GoogleAPIClient(await _currentUser!.authHeaders);
      final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);

      for (final event in iCalendar.data) {
        final IcsDateTime start = event['dtstart'];
        final IcsDateTime end = event['dtend'];
        final DateTime? startDateTime = start.toDateTime();
        final DateTime? endDateTime = end.toDateTime();
        final GoogleAPI.Event googleEvent = GoogleAPI.Event(
          summary: event['summary'] ?? 'No Title',
          description: event['description'] ?? '',
          start: GoogleAPI.EventDateTime(
            dateTime: startDateTime,
            timeZone: 'GMT-0',
          ),
          end: GoogleAPI.EventDateTime(
            dateTime: endDateTime,
            timeZone: 'GMT-0',
          ),
        );
        await calendarApi.events.insert(googleEvent, "primary");
        print('Imported event: ${googleEvent.summary}');
      }

      await _fetchEvents();
    } else {
      print('No file selected');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _importICS,
          ),
        ],
      ),
      body: FutureBuilder(
        future: getGoogleEventsData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text('No events found'),
            );
          } else {
            return GestureDetector(
              onDoubleTap: () async {
                final date = DateTime.now(); // Placeholder, replace with actual date calculation
                final eventsForDate = _events.where((e) => e.start!.dateTime!.toLocal().day == date.day).toList();
                if (eventsForDate.isNotEmpty) {
                  final event = eventsForDate.first;
                  await _deleteEvent(event);
                } else {
                  print('No event found for the selected date');
                }
              },

              child: SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: DateTime(2024, 6, 4, 9, 0, 0),
                dataSource: GoogleDataSource(events: _events),
                monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                ),
                onTap: (CalendarTapDetails details) async {
                  print('onTap triggered');
                  if (details.targetElement == CalendarElement.calendarCell) {
                    print('Tapped on calendar cell');
                    final selectedDate = details.date!;
                    print('Selected date: $selectedDate');
                    // Call the edit event method for the selected date
                    await _editEvent(selectedDate);
                  }
                },





              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final date = DateTime.now(); // Placeholder, replace with actual date calculation
          _addEvent(date);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    if (_googleSignIn.currentUser != null) {
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }
    super.dispose();
  }
}

class GoogleDataSource extends CalendarDataSource {
  GoogleDataSource({required List<GoogleAPI.Event>? events}) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.start?.date ?? event.start!.dateTime!.toLocal();
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].start.date != null;
  }

  @override
  DateTime getEndTime(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.endTimeUnspecified != null && event.endTimeUnspecified!
        ? (event.start?.date ?? event.start!.dateTime!.toLocal())
        : (event.end?.date != null
        ? event.end!.date!.add(const Duration(days: -1))
        : event.end!.dateTime!.toLocal());
  }

  @override
  String getLocation(int index) {
    return appointments![index].location ?? '';
  }

  @override
  String getNotes(int index) {
    return appointments![index].description ?? '';
  }

  @override
  String getSubject(int index) {
    final GoogleAPI.Event event = appointments![index];
    return event.summary == null || event.summary!.isEmpty
        ? 'No Title'
        : event.summary!;
  }
}

class GoogleAPIClient extends IOClient {
  final Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url,
          headers: (headers != null ? (headers..addAll(_headers)) : headers));
}
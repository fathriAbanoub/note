import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;
import 'package:http/io_client.dart' show IOClient, IOStreamedResponse;
import 'package:http/http.dart' show BaseRequest, Response;

class EditEventPage extends StatefulWidget {
  final String eventId; // Unique identifier for the event
  final String initialName;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final GoogleSignIn googleSignIn;

  const EditEventPage({
    Key? key,
    required this.eventId,
    required this.initialName,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.googleSignIn,
  }) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _nameController;
  late DateTime _startDate;
  late DateTime _endDate;
  GoogleAPI.CalendarApi? _calendarApi;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _initializeApi();
  }

  Future<void> _initializeApi() async {
    if (widget.googleSignIn.currentUser != null) {
      final httpClient = GoogleAPIClient(await widget.googleSignIn.currentUser!.authHeaders);
      setState(() {
        _calendarApi = GoogleAPI.CalendarApi(httpClient);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? TimeOfDay.fromDateTime(_startDate) : TimeOfDay.fromDateTime(_endDate),
    );
    if (picked != null) {
      setState(() {
        final dateTime = DateTime(
          isStart ? _startDate.year : _endDate.year,
          isStart ? _startDate.month : _endDate.month,
          isStart ? _startDate.day : _endDate.day,
          picked.hour,
          picked.minute,
        );
        if (isStart) {
          _startDate = dateTime;
        } else {
          _endDate = dateTime;
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_calendarApi == null) return;

    final updatedEvent = GoogleAPI.Event(
      id: widget.eventId,
      summary: _nameController.text,
      start: GoogleAPI.EventDateTime(
        dateTime: _startDate,
        timeZone: 'GMT',
      ),
      end: GoogleAPI.EventDateTime(
        dateTime: _endDate,
        timeZone: 'GMT',
      ),
    );

    try {
      await _calendarApi!.events.update(updatedEvent, "primary", widget.eventId);
      print('Event updated: ${updatedEvent.summary}');
      Navigator.of(context).pop(true);
    } catch (error) {
      print('Error updating event: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update event. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _deleteEvent() async {
    if (_calendarApi == null) return;

    try {
      await _calendarApi!.events.delete("primary", widget.eventId);
      print('Event deleted: ${widget.eventId}');
      Navigator.of(context).pop(true);
    } catch (error) {
      print('Error deleting event: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to delete event. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteEvent,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Event Name', hintText: 'Enter Event Name'),
            ),
            SizedBox(height: 16.0),
            Text('Start Date: ${_startDate.toLocal()}'),
            ElevatedButton(
              onPressed: () => _selectDate(context, true),
              child: Text('Select Start Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context, true),
              child: Text('Select Start Time'),
            ),
            SizedBox(height: 16.0),
            Text('End Date: ${_endDate.toLocal()}'),
            ElevatedButton(
              onPressed: () => _selectDate(context, false),
              child: Text('Select End Date'),
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context, false),
              child: Text('Select End Time'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
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

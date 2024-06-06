import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/firestore.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? selectedDate;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  MeetingDataSource _dataSource = MeetingDataSource(<Meeting>[]);
  FirestoreDatasource _firestoreDatasource = FirestoreDatasource();

  @override
  void dispose() {
    _eventController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
        initialDisplayDate: DateTime.now(),
        dataSource: _dataSource,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            setState(() {
              selectedDate = details.date;
            });
            _showDialog();
          } else if (details.targetElement == CalendarElement.appointment) {
            final Meeting appointment = details.appointments![0];
            _showDialog(event: appointment);
          }
        },
      ),
    );
  }

  Future<void> _showDialog({Meeting? event}) async {
    final DateFormat dateFormat = DateFormat.yMd();
    final DateFormat timeFormat = DateFormat('hh:mm a');

    if (event != null) {
      _eventController.text = event.eventName;
      _startDateController.text = dateFormat.format(event.from);
      _endDateController.text = dateFormat.format(event.to);
      _startTimeController.text = timeFormat.format(event.from);
      _endTimeController.text = timeFormat.format(event.to);
    } else {
      DateTime initialStartDate = selectedDate!;
      DateTime initialEndDate = selectedDate!.add(Duration(hours: 2));
      TimeOfDay initialStartTime = TimeOfDay(hour: 9, minute: 0);
      TimeOfDay initialEndTime = TimeOfDay(hour: 11, minute: 0);

      _eventController.clear();
      _startDateController.text = dateFormat.format(initialStartDate);
      _endDateController.text = dateFormat.format(initialEndDate);
      _startTimeController.text = timeFormat.format(DateTime(
        initialStartDate.year,
        initialStartDate.month,
        initialStartDate.day,
        initialStartTime.hour,
        initialStartTime.minute,
      ));
      _endTimeController.text = timeFormat.format(DateTime(
        initialEndDate.year,
        initialEndDate.month,
        initialEndDate.day,
        initialEndTime.hour,
        initialEndTime.minute,
      ));
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                ),
              ),
              TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: event?.from ?? selectedDate!,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                      _startDateController.text = dateFormat.format(picked);
                    });
                  }
                },
              ),
              TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: event?.to ??
                        selectedDate!.add(Duration(hours: 2)),
                    firstDate: event?.from ?? selectedDate!,
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDateController.text = dateFormat.format(picked);
                    });
                  }
                },
              ),
              TextField(
                controller: _startTimeController,
                decoration: InputDecoration(
                  labelText: 'Start Time',
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        event?.from ?? DateTime.now()),
                  );
                  if (picked != null) {
                    setState(() {
                      _startTimeController.text = picked.format(context);
                    });
                  }
                },
              ),
              TextField(
                controller: _endTimeController,
                decoration: InputDecoration(
                  labelText: 'End Time',
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        event?.to ?? DateTime.now().add(Duration(hours: 2))),
                  );
                  if (picked != null) {
                    setState(() {
                      _endTimeController.text = picked.format(context);
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String eventName = _eventController.text;
                DateTime startDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  TimeOfDay
                      .fromDateTime(selectedDate!)
                      .hour,
                  TimeOfDay
                      .fromDateTime(selectedDate!)
                      .minute,
                );
                DateTime endDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  TimeOfDay
                      .fromDateTime(selectedDate!.add(Duration(hours: 2)))
                      .hour,
                  TimeOfDay
                      .fromDateTime(selectedDate!.add(Duration(hours: 2)))
                      .minute,
                );

                if (endDateTime.isBefore(startDateTime)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('End time cannot be before start time')),
                  );
                  return;
                }

                Navigator.of(context).pop();

                if (event == null) {
                  _addEvent(eventName, startDateTime, endDateTime);
                } else {
                  _editEvent(event, eventName, startDateTime, endDateTime);
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addEvent(String eventName, DateTime startDateTime, DateTime endDateTime) {
    if (selectedDate != null && eventName.isNotEmpty) {
      final String eventId = _firestoreDatasource.generateEventId(); // Generate a unique ID

      setState(() {
        final Meeting newMeeting = Meeting(
          eventId,
          eventName,
          startDateTime,
          endDateTime,
          const Color(0xFF0F8644),
          false,
        );
        _dataSource.appointments!.add(newMeeting);
        _dataSource.notifyListeners(CalendarDataSourceAction.add, [newMeeting]);
      });

      _firestoreDatasource.addEventToFirestore(eventId, eventName, startDateTime, endDateTime);
    }
  }




  void _editEvent(Meeting oldEvent, String eventName, DateTime startDateTime,
      DateTime endDateTime) {
    setState(() {
      oldEvent.eventName = eventName;
      oldEvent.from = startDateTime;
      oldEvent.to = endDateTime;
      _dataSource.notifyListeners(
          CalendarDataSourceAction.reset, _dataSource.appointments!);
    });

    _firestoreDatasource.updateEventInFirestore(
        oldEvent.id, eventName, startDateTime, endDateTime);
  }
}

  class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.id,this.eventName, this.from, this.to, this.background, this.isAllDay);
  String id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

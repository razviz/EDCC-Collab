import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final String eventId;

  EditEventScreen({required this.event, required this.eventId});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _addressController;
  late TextEditingController _timeController;
  late TextEditingController _geopointController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event['name']);
    _locationController = TextEditingController(text: widget.event['location']);
    _addressController = TextEditingController(text: widget.event['address']);
    _timeController = TextEditingController(text: widget.event['time'].toDate().toString());
    _geopointController = TextEditingController(text: '${widget.event['geopoint']?.latitude ?? 0.0}, ${widget.event['geopoint']?.longitude ?? 0.0}');
  }

  // Function to update event in Firestore
  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('Events').doc(widget.eventId).update({
        'name': _nameController.text,
        'location': _locationController.text,
        'address': _addressController.text,
        'time': Timestamp.fromDate(DateTime.parse(_timeController.text)),
        'geopoint': GeoPoint(
          double.parse(_geopointController.text.split(', ')[0]),
          double.parse(_geopointController.text.split(', ')[1]),
        ),
      });
      Navigator.pop(context); // Close the screen after editing
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Event Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Event Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Event Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _geopointController,
                decoration: InputDecoration(labelText: 'Geopoint (Latitude, Longitude)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the geopoint';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateEvent,
                child: Text('Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  TextEditingController _newTagController = TextEditingController();

  List<String> _availableTags = []; // Combined tags from Firestore and event
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event['name']);
    _locationController = TextEditingController(text: widget.event['location']);
    _addressController = TextEditingController(text: widget.event['address']);
    _timeController = TextEditingController(text: widget.event['time'].toDate().toString());
    _geopointController = TextEditingController(
        text: '${widget.event['geopoint']?.latitude ?? 0.0}, ${widget.event['geopoint']?.longitude ?? 0.0}');

    // Load tags and initialize selected tags
    _loadTags();
  }

  Future<void> _loadTags() async {
    final List<String> loadedTags = [];

    // Fetch tags from Firestore
    final tagsDoc = await FirebaseFirestore.instance.collection('AppData').doc('Tags').get();
    if (tagsDoc.exists && tagsDoc.data() != null) {
      final data = tagsDoc.data()!;
      if (data.containsKey('tags') && data['tags'] is List) {
        loadedTags.addAll(List<String>.from(data['tags']));
      }
    }

    // Add tags from the current event, ensuring no duplicates
    if (widget.event.containsKey('tags') && widget.event['tags'] is List) {
      for (var tag in widget.event['tags']) {
        if (!loadedTags.contains(tag)) {
          loadedTags.add(tag);
        }
      }
    }

    setState(() {
      _availableTags = loadedTags; // Set the combined list of tags
      _selectedTags = List<String>.from(widget.event['tags'] ?? []);
    });
  }

  Future<void> _addNewTag() async {
    final newTag = _newTagController.text.trim();
    if (newTag.isNotEmpty && !_availableTags.contains(newTag)) {
      setState(() {
        _availableTags.add(newTag); // Add to the local list
        _selectedTags.add(newTag); // Automatically select the new tag
        _newTagController.clear(); // Clear the input field
      });

      // Update Firestore with the new tag
      await FirebaseFirestore.instance.collection('AppData').doc('Tags').set({
        'tags': _availableTags,
      }, SetOptions(merge: true));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(newTag.isEmpty ? 'Tag cannot be empty!' : 'Tag already exists!'),
      ));
    }
  }

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
        'tags': _selectedTags, // Save selected tags
      });
      Navigator.pop(context); // Close the screen after editing
    }
  }

  Widget _buildTagsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        ..._availableTags.map((tag) {
          return CheckboxListTile(
            title: Text(tag),
            value: _selectedTags.contains(tag),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedTags.add(tag);
                } else {
                  _selectedTags.remove(tag);
                }
              });
            },
          );
        }).toList(),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _newTagController,
                decoration: InputDecoration(labelText: 'Add New Tag'),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addNewTag,
              child: Text('Add'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _timeController.dispose();
    _geopointController.dispose();
    _newTagController.dispose();
    super.dispose();
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
              SizedBox(height: 16),
              _buildTagsSelector(),
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

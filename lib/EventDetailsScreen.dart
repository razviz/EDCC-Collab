import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OpenMap.dart'; // Assuming OpenMap is already implemented
import 'EditEventScreen.dart'; // Assuming EditEventScreen is implemented

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final String eventId;

  EventDetailsScreen({required this.event, required this.eventId});

  // Function to delete the event
  Future<void> _deleteEvent(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('Events').doc(eventId).delete();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Event Title
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 25.0),
              child: Center(
                child: Text(
                  event['Name'] ?? 'Event Title',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Event Details
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 15.0),
              child: Center(
                child: Text(
                  event['details'] ?? 'Event details will be available soon. Please stay tuned!',
                  style: const TextStyle(fontSize: 25),
                  softWrap: true,
                ),
              ),
            ),
            // Event Date
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Center(
                child: Text(
                  event['Time']?.toDate().toString() ?? 'Date not available',
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            // Event Location
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
              child: Center(
                child: Text(
                  event['Location'] ?? 'Location not available',
                  style: const TextStyle(fontSize: 25),
                ),
              ),
            ),
            // Button to open map
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OpenMap()), // Assuming OpenMap is implemented
                  );
                },
                child: const Text(
                  'View Location on Map',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer for better layout

            // Button to edit the event
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditEventScreen(event: event, eventId: eventId),
                    ),
                  );
                },
                child: const Text(
                  'Edit Event',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer for better layout

            // Button to delete the event
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _deleteEvent(context); // Call the function to delete the event
                },
                child: const Text(
                  'Delete Event',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

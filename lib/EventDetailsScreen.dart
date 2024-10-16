import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OpenMap.dart'; // Import the OpenMap class

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final String eventId; // Add eventId to delete the event

  EventDetailsScreen({required this.event, required this.eventId});

  // Function to delete the event from Firestore
  Future<void> _deleteEvent(BuildContext context) async {
    try {
      // Delete the event from Firestore using the eventId
      await FirebaseFirestore.instance.collection('Events').doc(eventId).delete();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully')),
      );

      // Navigate back after deletion
      Navigator.pop(context);
    } catch (e) {
      // Show error message if something goes wrong
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
        title: const Text('EDCC'),
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
                  event['title'] ?? 'Event Title',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Event Details
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 25.0, bottom: 15.0),
              child: Center(
                child: Text(
                  event['details'] ?? 'Event details will be available soon. Please stay tuned!',
                  style: TextStyle(fontSize: 25),
                  softWrap: true,
                ),
              ),
            ),
            // Event Date
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Center(
                child: Text(
                  event['date'] ?? 'Date not available',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            // Event Location
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
              child: Center(
                child: Text(
                  event['location'] ?? 'Location not available',
                  style: TextStyle(fontSize: 25),
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
                    MaterialPageRoute(builder: (_) => OpenMap()),
                  );
                },
                child: const Text(
                  'View Location on Map',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(height: 20), // Spacer for better layout
            // Button to delete event
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () {
                  _deleteEvent(context); // Call the delete function
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'OpenMap.dart'; // Import the OpenMap class

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({required this.event});

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
          ],
        ),
      ),
    );
  }
}

// Function to fetch event data from Firestore and navigate to EventDetailsScreen
Future<void> fetchEventData(String eventId, BuildContext context) async {
  try {
    // Fetch the event data from Firestore
    DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
        .collection('events') // Ensure this matches the Firestore collection name
        .doc(eventId)
        .get();

    if (eventSnapshot.exists) {
      // Retrieve the entire document data
      Map<String, dynamic> eventData = eventSnapshot.data() as Map<String, dynamic>;

      // Now, navigate to the EventDetailsScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsScreen(event: eventData),
        ),
      );
    } else {
      print('Event not found');
    }
  } catch (e) {
    print('Error fetching event data: $e');
  }
}

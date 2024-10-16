import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

class CreateEvents extends StatelessWidget {
  CreateEvents({super.key});

  // Variables for input fields
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescribe = TextEditingController();
  TextEditingController eventDate = TextEditingController();
  TextEditingController eventTime = TextEditingController();
  TextEditingController eventLocation = TextEditingController();
  TextEditingController eventAddress = TextEditingController();

  // Function to create a new event in Firestore
  Future<void> _createEvent(BuildContext context) async {
    try {
      // Convert date and time to a DateTime object
      DateTime eventDateTime = DateTime.now(); // Default to now if date or time isn't specified
      if (eventDate.text.isNotEmpty && eventTime.text.isNotEmpty) {
        eventDateTime = DateTime.parse('${eventDate.text} ${eventTime.text}');
      }

      // Add the event to Firestore
      await FirebaseFirestore.instance.collection('Events').add({
        'Name': eventName.text.isNotEmpty ? eventName.text : 'Unknown Event',
        'description': eventDescribe.text.isNotEmpty ? eventDescribe.text : 'No description available',
        'Time': Timestamp.fromDate(eventDateTime),
        'Location': eventLocation.text.isNotEmpty ? eventLocation.text : 'Sheridan',
        'Address': eventAddress.text.isNotEmpty ? eventAddress.text : 'No address available',
        'geoPoint': const GeoPoint(0.0, 0.0), // Default geopoint value [0° N, 0° E]
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Event '${eventName.text}' created successfully!"),
      ));

      // Navigate to HomePage after creating the event
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomePage()));
    } catch (e) {
      print('Error creating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to create event.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text("EDCC"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text('Create New Event',
                    style: TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 25.0),
              child: Center(
                child: Text("Fill in the fields to create an event:",
                    style: TextStyle(fontSize: 25)),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name/Type of Event:',
                    hintText: 'Enter an event like Hockey Game'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventDescribe,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description of Event:',
                    hintText: 'Describe what will happen at the event'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventDate,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Event (yyyy-MM-dd):',
                    hintText: 'Enter date such as 2024-10-15'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventTime,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time of Event (HH:mm:ss):',
                    hintText: 'Enter time such as 19:26:36'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventLocation,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location of Event:',
                    hintText:
                    'Enter the location of the event, such as Sheridan'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address of Event:',
                    hintText: 'Enter the address, e.g., 123 Main St'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () => _createEvent(context), // Call the create event function
                child: const Text(
                  'Create New Event',
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

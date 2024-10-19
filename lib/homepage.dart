import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CreateEvents.dart';
import 'EventDetailsScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DocumentSnapshot> _events = []; // Use DocumentSnapshot to store the events

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirestore(); // Fetch events on page load
  }

  // Fetch events from Firestore and update the list
  Future<void> _fetchEventsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Events').get();
      setState(() {
        _events = snapshot.docs; // Store the list of DocumentSnapshots
      });
    } catch (e) {
      print('Error fetching events from Firestore: $e');
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
            const Padding(
              padding: EdgeInsets.only(top: 25.0),
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('assets/images/img.png'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: Center(
                child: Text(
                  'Upcoming Events',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _events.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            ) // Show a loading spinner while fetching data
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                final data = event.data() as Map<String, dynamic>;
                final eventId = event.id; // Get the event ID

                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  title: Text(data['name'] ?? 'Unknown Event'),
                  subtitle: Text(data['time']?.toDate().toString() ?? 'No Date Available'),
                  trailing: const Text("View Details"),
                  onTap: () {
                    // Navigate to EventDetailsScreen with the selected event's data and ID
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailsScreen(event: data, eventId: eventId),
                      ),
                    );
                  },
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
            ),
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
                    MaterialPageRoute(builder: (_) => CreateEvents()),
                  );
                },
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'CreateEvents.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEventsFromFirestore(); // Fetch events on page load
  }

  // Fetch events from Firestore and update the list
  Future<void> _fetchEventsFromFirestore() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Events').get();
      List<Map<String, dynamic>> events = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'title': data['name'] ?? 'No Title',
          'subtitle': data['date'] ?? 'No Date',
          'details': data['description'] ?? 'No Details Available',
          'location': data['location'] ?? 'No Location',
        };
      }).toList();

      setState(() {
        _events = events;
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
                  'My Upcoming Events',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _events.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Show a loading spinner while fetching data
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  title: Text(event['title'] ?? 'Unknown Event'),
                  subtitle: Text(event['subtitle'] ?? 'No Date Available'),
                  trailing: const Text("View Details"),
                  onTap: () {
                    // Navigate to details screen or login if needed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginDemo()), // Or another details screen
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

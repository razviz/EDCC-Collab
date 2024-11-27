import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package
import 'EventDetailsScreen.dart';

class AnalyticsScreen extends StatefulWidget {
  final String currentEventId; // Pass the event ID to AnalyticsScreen
  const AnalyticsScreen({Key? key, required this.currentEventId}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int maleCount = 0;
  int femaleCount = 0;
  int age18To23Count = 0;
  int age24To26Count = 0;
  int totalAttendees = 0;
  int totalLikes = 0;
  int userEventDetailViews = 0;

  // Function to calculate event attendance and related analytics
  bool isLoading = true; // Add a loading flag

  Future<void> calculateEventAttendance() async {
    try {
      print("Starting calculateEventAttendance...");
      CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
      QuerySnapshot userSnapshots = await usersRef.get();

      int eventAttendees = 0;
      int eventMales = 0;
      int eventFemales = 0;
      int eventAge18to23 = 0;
      int eventAge24to26 = 0;

      for (var userDoc in userSnapshots.docs) {
        // Safely access user data and check for missing fields
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        // Check if userData is not null and contains the required fields
        if (userData == null || !userData.containsKey('gender') || !userData.containsKey('age')) {
          // If any required field is missing, skip this user
          print("Skipping user: ${userDoc.id} because required fields are missing.");
          continue; // Skip this iteration and move to the next user
        }

        // Check if userData is not null before accessing fields
        String gender = userData?['gender'] ?? 'male';
        int age = userData?['age'] ?? 18;

        CollectionReference eventsRef = usersRef.doc(userDoc.id).collection('Events');
        QuerySnapshot eventsSnapshot = await eventsRef.get();

        for (var eventDoc in eventsSnapshot.docs) {
          // Safely access event data and check for missing eventId field
          Map<String, dynamic>? eventData = eventDoc.data() as Map<String, dynamic>?;

          // Check if eventData is not null before accessing fields
          String eventId = eventData?['eventId'] ?? '';

          // Debug log to track which event is being processed
          print("Processing Event ID: $eventId for user: ${userDoc.id}");

          if (eventId == widget.currentEventId) {
            eventAttendees++;
            if (gender.toLowerCase() == 'male') eventMales++;
            if (gender.toLowerCase() == 'female') eventFemales++;
            if (age >= 18 && age <= 23) eventAge18to23++;
            if (age >= 24 && age <= 26) eventAge24to26++;
          }
        }
      }


      // Update state after all calculations
      setState(() {
        totalAttendees = eventAttendees;
        maleCount = eventMales;
        femaleCount = eventFemales;
        age18To23Count = eventAge18to23;
        age24To26Count = eventAge24to26;
        isLoading = false; // Data fetching is complete
      });

      print("Event Attendance Calculation Complete");
    } catch (e) {
      print('Error calculating event attendance: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }



  // Fetch and calculate "viewCount" and "likes" for the current event
  Future<void> calculateUserEventDetailViewsAndLikes() async {
    try {
      // Use the current event ID passed to the screen
      String currentEventId = widget.currentEventId;

      // Reference to the 'Events' collection
      CollectionReference eventsRef = FirebaseFirestore.instance.collection('Events');

      // Fetch the specific event document by eventId
      DocumentSnapshot eventDoc = await eventsRef.doc(currentEventId).get();

      // Initialize variables for view count and likes
      int viewCount = 0;
      int likeCount = 0;

      if (eventDoc.exists) {
        // Extract viewCount and likes for the event
        viewCount = eventDoc['viewCount'] ?? 0;
        likeCount = eventDoc['likes'] ?? 0;
      }

      // Update the state with the calculated values
      setState(() {
        userEventDetailViews = viewCount;
        totalLikes = likeCount;
      });
    } catch (e) {
      print('Error calculating user event detail views and likes: $e');
    }
  }




  @override
  void initState() {
    super.initState();
    calculateEventAttendance(); // Calculate attendance for the selected event
    calculateUserEventDetailViewsAndLikes(); // Calculate total event detail views
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: const Text('Data Analytics'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
              child: Center(
                child: Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Text(
              'Age Demographics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              '18-23: $age18To23Count users',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            Text(
              '24-26: $age24To26Count users',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gender Demographics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Male: $maleCount users',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            Text(
              'Female: $femaleCount users',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            // PieChart to display gender data
            isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : SizedBox(
              height: 250, // Set the height of the pie chart
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: maleCount.toDouble(),
                      color: Colors.blue,
                      title: 'Male',
                      radius: 40,
                    ),
                    PieChartSectionData(
                      value: femaleCount.toDouble(),
                      color: Colors.pink,
                      title: 'Female',
                      radius: 40,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Event Attendance',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Total Attendees: $totalAttendees',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Engagement',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              'Number of users who viewed event details: $userEventDetailViews',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

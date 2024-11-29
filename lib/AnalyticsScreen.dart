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

  int positiveReviews = 0;
  int neutralReviews = 0;
  int negativeReviews = 0;
  bool isLoadingReviews = true;
  bool hasReviews = true;

  bool isLoading = true; // Add a loading flag

  // Function to calculate event attendance and related analytics
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


  /// Fetch and calculate sentiment percentages for reviews
  Future<void> calculateSentimentAnalysis() async {
    try {
      CollectionReference reviewsRef = FirebaseFirestore.instance
          .collection('Events')
          .doc(widget.currentEventId)
          .collection('Reviews');

      QuerySnapshot reviewsSnapshot = await reviewsRef.get();

      if (reviewsSnapshot.docs.isEmpty) {
        setState(() {
          hasReviews = false;
          isLoadingReviews = false;
        });
        return;
      }

      int positive = 0, neutral = 0, negative = 0;

      for (var reviewDoc in reviewsSnapshot.docs) {
        Map<String, dynamic>? reviewData = reviewDoc.data() as Map<String, dynamic>?;

        if (reviewData != null && reviewData.containsKey('sentimentScore')) {
          double sentimentScore = reviewData['sentimentScore'] ?? 0.0;

          if (sentimentScore >= 0.25 && sentimentScore <= 1.0) {
            positive++;
          } else if (sentimentScore > -0.25 && sentimentScore < 0.25) {
            neutral++;
          } else if (sentimentScore >= -1.0 && sentimentScore < -0.25) {
            negative++;
          }
        }
      }

      setState(() {
        positiveReviews = positive;
        neutralReviews = neutral;
        negativeReviews = negative;
        isLoadingReviews = false;
        hasReviews = positive + neutral + negative > 0;
      });
    } catch (e) {
      print('Error calculating sentiment analysis: $e');
      setState(() {
        isLoadingReviews = false;
        hasReviews = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    calculateEventAttendance(); // Calculate attendance for the selected event
    calculateUserEventDetailViewsAndLikes(); // Calculate total number of views for the selected event
    calculateSentimentAnalysis(); //Calculate sentiment analysis of reviews for selected event
  }

  @override
  Widget build(BuildContext context) {
    // Calculate percentages for reviews (sentiment analysis)
    int totalReviews = positiveReviews + neutralReviews + negativeReviews;
    double positivePercentage = totalReviews > 0 ? (positiveReviews / totalReviews) * 100 : 0;
    double neutralPercentage = totalReviews > 0 ? (neutralReviews / totalReviews) * 100 : 0;
    double negativePercentage = totalReviews > 0 ? (negativeReviews / totalReviews) * 100 : 0;

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
            const SizedBox(height: 20),
            const Text(
              'Sentiment Analysis',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),


            // Check if reviews exist and sentiment scores are available
            isLoadingReviews
                ? const Center(child: CircularProgressIndicator())
                : hasReviews
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Positive reviews: ${positivePercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                Text(
                  'Neutral reviews: ${neutralPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                Text(
                  'Negative reviews: ${negativePercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 20),
              ],
            )
                : const Center(
              child: Text(
                "There are currently no reviews yet",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

            // Pie Chart for sentiment analysis
            isLoadingReviews
                ? const Center(child: CircularProgressIndicator())
                : hasReviews
                ? SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: positiveReviews.toDouble(),
                      color: Colors.green,
                      title: 'Positive',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: neutralReviews.toDouble(),
                      color: Colors.yellow,
                      title: 'Neutral',
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: negativeReviews.toDouble(),
                      color: Colors.red,
                      title: 'Negative',
                      radius: 50,
                    ),
                  ],
                  sectionsSpace: 2,
                ),
              ),
            )
                : const Center(
              child: Text(
                "",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//for web scraping
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

import 'login.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}







//scrape the data
//Removed for now due to magdin request

class Scraping extends State<LoginDemo> {
  String scrapedData = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final url = 'http://quotes.toscrape.com'; // Updated URL
              final response = await http.get(Uri.parse(url));

              if (response.statusCode == 200) {
                // If the server returns a 200 OK response,
                // parse the HTML content
                final document = htmlParser.parse(response.body);
                // Extract the data you need from the parsed HTML
                final firstQuoteElement = document.querySelector('.text');
                final firstQuote = firstQuoteElement?.text ?? 'Quote not found';
                setState(() { //had to add state
                  scrapedData = firstQuote;
                });
              } else {
                // If the server did not return a 200 OK response,
                // throw an exception.
                throw Exception('Failed to load data');
              }
            },
            child: Text('Get Quote'),
          ),
          SizedBox(height: 20),
          Text('Scraped Quote: $scrapedData'),
        ],
      ),
    );
  }

}

//Create a map centered on Sydney, Australia.
class OpenMap extends StatelessWidget {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: {
              const Marker(
                markerId: MarkerId('Sydney'),
                position: LatLng(-33.86, 151.2),
                infoWindow: InfoWindow(
                  title: "Sydney",
                  snippet: "Event location",
                ),
              )
            },
          )
      ),
    );
  }


}

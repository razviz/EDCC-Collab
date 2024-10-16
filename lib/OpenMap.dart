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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CreateEvents.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//for web scraping
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

import 'login.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: const Text('EDCC'),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                    child: Text('Home',
                        style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/images/img.png')),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
                child: Center(
                    child: Text('My Upcoming Events',
                        style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
              ),
              ListView(
                shrinkWrap: true, children: [
                ListTile(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)), title: Text("Barbecue Party"), subtitle: Text("Friday, 2:00 - 4:00 pm"),
                    trailing: Text("View Details"),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => LoginDemo()));}),
                ListTile(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)), title: Text("Soccer game"), subtitle: Text("Saturday, 12:00 - 3:00 pm"),
                    trailing: Text("View Details"),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => LoginDemo()));}),
                ListTile(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)), title: Text("Talent Show"), subtitle: Text("Monday, 3:00 - 5:00 pm"),
                    trailing: Text("View Details"),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => LoginDemo()));}),
              ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => CreateEvents()));
                  },
                  child: const Text(
                    'Create New Event',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ]
            )
        )
    );

  }
}
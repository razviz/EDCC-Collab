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

import 'homepage.dart';
import 'login.dart';





class CreateEvents extends StatelessWidget {
  CreateEvents({super.key});

  //Variables
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDescribe = TextEditingController();
  TextEditingController eventDate = TextEditingController();
  TextEditingController eventTime = TextEditingController();
  TextEditingController eventLocation = TextEditingController();


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
                          fontSize: 45, fontWeight: FontWeight.bold))),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 40.0, bottom: 25.0),
                child: Center(
                    child: Text("Fill in the fields to create an event:",
                        style:
                        TextStyle(fontSize: 25)))
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name/Type of Event:',
                    hintText:
                    'Enter an event like Hockey Game'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventDescribe,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description of Event:',
                    hintText: 'Describe what will happen at the event'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventDate,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of Event:',
                    hintText: 'Enter date such as Friday, December 27'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                controller: eventTime,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Time of Event:',
                    hintText: 'Enter time such as 7:00 - 10:00 pm'),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: eventLocation,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Location of Event:',
                    hintText:
                    'Enter the location of the event, such as Cassie Campbell Community Center'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Event Name: ${eventName.text}, Event Time and Date: ${eventDate.text}, ${eventTime.text}, Location: ${eventLocation.text}")));
                },
                child: const Text(
                  'Create New Event',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            //const Text("Don't have an account? Sign up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
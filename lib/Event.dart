import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event{

  final String? id;
  final String name;
  final String description;
  final String location;
  final String date;
  final String time;


  Event({this.id, required this.name, required this.description, required this.location, required this.date, required this.time});

  toJson(){
    return{"name":name, "description":description, "date":date, "time":time};
  }


  factory Event.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){

    final data = document.data()!;


    return Event(
        id:document.id,
        name: data["name"],
        description: data["description"],
        location: data["location"],
        date: data["date"],
        time: data["time"]
    );
  }

}
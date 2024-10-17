import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Event.dart';


class EventRepository {

  final _db = FirebaseFirestore.instance;

  createEvent(Event event){
    _db.collection("Event").add(event.toJson()).whenComplete(() => log("successful add"));
  }




  Future<List<Event>> getAllEvents() async {
    final snapshot = await _db.collection("Events").get();
    try {
      final events = snapshot.docs.map((e) => Event.fromSnapshot(e))
          .toList();
      return events;
    } catch(e){
      log("$e");
      throw e;
    }
  }
}

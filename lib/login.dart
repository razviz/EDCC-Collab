import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edcc/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';
import 'main.dart';




class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
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
              padding: EdgeInsets.only(left: 70.0, top: 20.0),
              child: Center(
                  child: Text('Event Driven Community Collaboration',
                      style:
                      TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                      softWrap: true)),
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
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email/Username',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            const Padding(
              padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("You are now logged in!"),
                  ));
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RichText(
              text: TextSpan(children: [
                const TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Sign up Text Clicked');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const Register()));
                      }),
              ]),
            ),
            //const Text("Don't have an account? Sign up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
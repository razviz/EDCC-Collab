import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


//for web scraping
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;


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
                          context, MaterialPageRoute(builder: (_) => ViewDetailsBBQ()));}),
                  ListTile(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)), title: Text("Soccer game"), subtitle: Text("Saturday, 12:00 - 3:00 pm"),
                      trailing: Text("View Details"),
                      onTap: () {
                          Navigator.push(
                          context, MaterialPageRoute(builder: (_) => ViewDetailsSoccer()));}),
                  ListTile(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 2)), title: Text("Talent Show"), subtitle: Text("Monday, 3:00 - 5:00 pm"),
                      trailing: Text("View Details"),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => ViewDetailsTalentShow()));}),
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

//Details page for BBQ Party
class ViewDetailsBBQ extends StatelessWidget {
  const ViewDetailsBBQ({super.key});

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
                padding: EdgeInsets.only(left: 15.0, top: 25.0),
                child: Center(
                    child: Text('Barbeque Party',
                        style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 15.0),
                child: Center(
                    child: Text("Event Details: Get ready for an unforgettable barbecue experience! Join us as we fire up the grill for a variety of succulent meats, enjoy live entertainment, and savor the vibrant atmosphere with friends and family. It's an afternoon of delicious flavors, laughter, and delightful moments that you won't want to miss!",
                        style:
                        TextStyle(fontSize: 25),
                        softWrap: true))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Center(
                      child: Text("Date: Friday, 2:00 - 4:00 pm",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
                  child: Center(
                      child: Text("Location: Eldorado Park",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => OpenMap()));
                  },
                  child: const Text(
                    'View Location on Map',
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

//Details page for Soccer Game
class ViewDetailsSoccer extends StatelessWidget {
  const ViewDetailsSoccer({super.key});

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
                padding: EdgeInsets.only(left: 15.0, top: 25.0),
                child: Center(
                    child: Text('Soccer Game',
                        style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 15.0),
                  child: Center(
                      child: Text("Event Details: Embark on a soccer adventure at the Sheridan Better Bruins Gym – an open invitation for everyone to join in the excitement! Whether you're a seasoned player or just eager to kick the ball around, come and be part of the action.",
                          style:
                          TextStyle(fontSize: 25),
                          softWrap: true))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Center(
                      child: Text("Date: Saturday, 12:00 - 3:00 pm",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
                  child: Center(
                      child: Text("Location: Sheridan Bruins Gym",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => OpenMap()));
                  },
                  child: const Text(
                    'View Location on Map',
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


//Details page for Talent Show
class ViewDetailsTalentShow extends StatelessWidget {
  const ViewDetailsTalentShow({super.key});

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
                padding: EdgeInsets.only(left: 15.0, top: 25.0),
                child: Center(
                    child: Text('Talent Show',
                        style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.bold))),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 25.0, bottom: 15.0),
                  child: Center(
                      child: Text("Event Details: Discover a stage for all talents at the Talent Show – an event where everyone is welcome to shine! Whether you're a seasoned performer or stepping into the spotlight for the first time, come and share your talents in a celebration of creativity and community.",
                          style:
                          TextStyle(fontSize: 25),
                          softWrap: true))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Center(
                      child: Text("Date: Monday, 3:00 - 5:00 pm",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
                  child: Center(
                      child: Text("Location: Algoma University",
                          style:
                          TextStyle(fontSize: 25)))
              ),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => OpenMap()));
                  },
                  child: const Text(
                    'View Location on Map',
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

class Register extends StatelessWidget {
  const Register({super.key});

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
                  child: Text('Sign up',
                      style: TextStyle(
                          fontSize: 45, fontWeight: FontWeight.bold))),
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
                    labelText: 'Username',
                    hintText:
                        'Enter a valid username such as zarazvi2000'),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter a secure password'),
              ),
            ),
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id such as abc@gmail.com'),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number',
                    hintText:
                        'Enter a valid phone number such as 905-490-0456'),
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
                      content: Text("New account created!")));
                },
                child: const Text(
                  'Create Account',
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


//scrape the data
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

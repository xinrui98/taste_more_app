import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'main_screen.dart';
import 'package:geolocator/geolocator.dart';



class UploadDataPage extends StatefulWidget {
  @override
  _UploadDataPageState createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  String _currentLocation;
  var _locationTextFormFieldController = TextEditingController();
  File sampleImage;
  String _title;
  String _location;
  String _comment;
  final formKey = new GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {}

  void uploadStatusFeedback() async {
    if (validateAndSave()) {
      saveToDatabase();
      goToHomePage();
    }
  }

  void saveToDatabase() {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child("food_feedbacks");

    var feedback = {
      "title": _title,
      "location": _location,
      "comment": _comment,
      "date": date,
      "time": time,
    };

    databaseReference.push().set(feedback);
  }

  void goToHomePage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.green,
        title: new Text("Your Feedback"),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            //for displaying snackbar outside of scaffold
            builder: (context) => IconButton(
                icon: new Icon(
                  Icons.location_on,
                  size: 35.0,
                ),
                onPressed: () async {

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Getting current location, Please wait...'),
                    duration: Duration(seconds: 10),
                  ));
                  
                  print("hello world");

                  //check permissions
//                  Geolocator _geolocator;
//                  _geolocator = Geolocator();
//                  _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
//                  _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
//                  _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });


                  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
                  GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
                  print(geolocationStatus);


                  //get lat and long
                  Position position = await Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.best);
                  print("current position = $position");

                  //get actual address
                  List<Placemark> placemark = await Geolocator()
                      .placemarkFromCoordinates(
                          position.latitude, position.longitude);

                  print(
                      '''address:  ${placemark.first.name} ${placemark.first.administrativeArea} ${placemark.first.postalCode}''');
                  print(
                      '''${placemark.first.name} ${placemark.first.thoroughfare} ${placemark.first.country} ${placemark.first.postalCode}''');

                  print('''address first name: ${placemark.first.name} first country: ${placemark.first.country} first admin: ${placemark.first.administrativeArea} first thoroughfare: ${placemark.first.thoroughfare} 
                  first subThroughfare: ${placemark.first.subThoroughfare} first locality: ${placemark.first.locality} first postal code: ${placemark.first.postalCode}
                  last postal code: ${placemark.last.postalCode} first iosCountryCode: ${placemark.first.isoCountryCode}
                  
                  ''');
                  //ios
                  (Platform.isIOS) ?
                  setState(() {
                    _locationTextFormFieldController.text =
                        "${placemark.first.name} ${placemark.first.administrativeArea} ${placemark.first.postalCode}";
                  }):
                      //android
                  setState(() {
                    _locationTextFormFieldController.text =
                    "${placemark.first.name} ${placemark.first.thoroughfare} ${placemark.first.country} ${placemark.first.postalCode}";
                  });



                }),
          ),
        ],
      ),
      body: new Center(child: enableUpload()),
    );
  }

  Widget enableUpload() {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white70,
        image: DecorationImage(
          image: AssetImage("assets/background_cake.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autofocus: true,
                  decoration:
                      new InputDecoration(labelText: "Restaurant Title"),
                  validator: (value) {
                    return value.isEmpty ? "Title is required" : null;
                  },
                  onSaved: (value) {
                    return _title = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration:
                      new InputDecoration(labelText: "Restaurant Location"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    return value.isEmpty ? "Location is required" : null;
                  },
                  onSaved: (value) {
                    return _location = value;
                  },
                  controller: _locationTextFormFieldController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Restaurant Comments",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    return value.isEmpty ? "Comment is required" : null;
                  },
                  onSaved: (value) {
                    return _comment = value;
                  },
                ),
              ),
//              SizedBox(
//                height: 3.0,
//              ),
              RaisedButton(
                elevation: 1.0,
                child: Text("Submit Feedback"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: uploadStatusFeedback,
              )
            ],
          )),
    );
  }
}

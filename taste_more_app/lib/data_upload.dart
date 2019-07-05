import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'main_screen.dart';

class UploadDataPage extends StatefulWidget {
  @override
  _UploadDataPageState createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
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

  void uploadStatusFeedback()async{
    if(validateAndSave()){
      saveToDatabase();
      goToHomePage();
    }
  }

  void saveToDatabase(){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference databaseReference = FirebaseDatabase.instance.reference().child("food_feedbacks");

    var feedback={
      "title" : _title,
      "location": _location,
      "comment": _comment,
      "date": date,
      "time": time,
    };

    databaseReference.push().set(feedback);
  }

  void goToHomePage(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Feedback"),
        centerTitle: true,
      ),
      body: new Center(child: enableUpload()),
    );
  }

  Widget enableUpload() {
    return Container(
      decoration: new BoxDecoration(color: Colors.white70),
      child: new Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: new InputDecoration(labelText: "Restaurant Title"),
                validator: (value) {
                  return value.isEmpty ? "Title is required" : null;
                },
                onSaved: (value) {
                  return _title = value;
                },
              ),
              TextFormField(
                decoration:
                    new InputDecoration(labelText: "Restaurant Location"),
                validator: (value) {
                  return value.isEmpty ? "Location is required" : null;
                },
                onSaved: (value) {
                  return _location = value;
                },
              ),
              TextFormField(
                decoration: new InputDecoration(
                  labelText: "Restaurant Comments",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                validator: (value) {
                  return value.isEmpty ? "Comment is required" : null;
                },
                onSaved: (value) {
                  return _comment = value;
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              RaisedButton(
                elevation: 10.0,
                child: Text("Submit Feedback"),
                textColor: Colors.white70,
                color: Colors.pink,
                onPressed: uploadStatusFeedback,
              )
            ],
          )),
    );
  }
}

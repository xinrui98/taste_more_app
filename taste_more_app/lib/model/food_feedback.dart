import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class FoodFeedback {
  String key;
  String title;
  String location;
  String comment;


  FoodFeedback(this.title, this.location, this.comment);

  FoodFeedback.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value['title'],
        location = snapshot.value['location'],
        comment = snapshot.value['comment'];

  toJson() {
    return {
      "title": title,
      "location": location,
      "comment": comment,
    };
  }

}
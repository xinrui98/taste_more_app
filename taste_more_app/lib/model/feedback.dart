import 'package:firebase_database/firebase_database.dart';

class Feedback {
  String key;
  String title;
  String location;
  String comment;


  Feedback(this.title, this.location, this.comment);

  Feedback.fromSnapshot(DataSnapshot snapshot)
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

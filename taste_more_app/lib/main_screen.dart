import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'model/food_feedback.dart';
import 'package:flutter/services.dart';
import 'data_upload.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<FoodFeedback> foodFeedBackMessages = List();

  FoodFeedback foodFeedback;
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    databaseReference = database.reference().child("food_feedbacks");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildRemoved.listen(_onEntryRemoved);

    databaseReference.once().then((DataSnapshot snapshot) {
      var KEYS = snapshot.value.key;
      var DATA = snapshot.value;

      foodFeedBackMessages.clear();

      for (var individualKey in KEYS) {
        FoodFeedback foodFeedback =
            new FoodFeedback(DATA['title'], DATA['location'], DATA['comment']);
        print(foodFeedback.title);

        foodFeedBackMessages.add(foodFeedback);
      }
      setState(() {
        print("Length : ${foodFeedBackMessages.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Taste More, Waste Less!"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add_comment),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return new UploadDataPage();
                }));
              }),
        ],
      ),
      key: _scaffoldKey,
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/main_screen.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),

        Container(
          child: foodFeedBackMessages.length == 0
              ? new Text("No Feedbacks Available")
              : new ListView.builder(
                  reverse: false,
                  itemCount: foodFeedBackMessages.length,
                  itemBuilder: (_, index) {
                    return feedbackMessagesUI(
                        foodFeedBackMessages[
                                foodFeedBackMessages.length - index - 1]
                            .title,
                        foodFeedBackMessages[
                                foodFeedBackMessages.length - index - 1]
                            .location,
                        foodFeedBackMessages[
                                foodFeedBackMessages.length - index - 1]
                            .comment,
                        index);
                  }),
        ),

//        Container(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
////              FloatingActionButton(
////                child: new Icon(Icons.add),
////                onPressed: () {
//////                  _showFormDialog();
////                  Navigator.push(context, MaterialPageRoute(builder: (context) {
////                    return new UploadDataPage();
////                  }));
////                },
////              ),
//              Flexible(
//                child: FirebaseAnimatedList(
//                  query: databaseReference,
//                  itemBuilder: (_, DataSnapshot snapshot,
//                      Animation<double> animation, int index) {
//                    return new Card(
//                      child: ListTile(
//                        leading: CircleAvatar(
//                          child: Text(foodFeedBackMessages[index]
//                              .title
//                              .substring(0, 1)),
//                          backgroundColor: Colors.red,
//                        ),
//                        title: ListTile(
//                            title: Text("Title  : " +
//                                foodFeedBackMessages[index].title),
//                            subtitle: Text("Location  : " +
//                                foodFeedBackMessages[index].location)),
//                        subtitle: Text("Comments  : " +
//                            foodFeedBackMessages[index].comment),
//                        trailing: Listener(
//                          key: Key(foodFeedBackMessages[index].key),
//                          child: Icon(
//                            Icons.remove_circle,
//                            color: Colors.redAccent,
//                          ),
//                          onPointerDown: (pointerEvent) => handleRemove(
//                              foodFeedBackMessages[index].key, index),
//                        ),
//                      ),
//                    );
//                  },
//                ),
//              ),
//            ],
//          ),
//        ),
      ]),
    );
  }

  Widget feedbackMessagesUI(
      String title, String location, String comment, int index) {
    return new Card(
      elevation: 3.0,
      margin: EdgeInsets.all(5.0),
      child: new Container(
        padding: new EdgeInsets.all(5.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new Text("Title: $title",
                  style: Theme.of(context).textTheme.title),
              subtitle: new Text("Location: $location",
                  style: Theme.of(context).textTheme.subhead),
              trailing: Listener(
                key: Key(foodFeedBackMessages[index].key),
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.redAccent,
                ),
                onPointerDown: (pointerEvent) => handleRemove(
                    foodFeedBackMessages[
                            foodFeedBackMessages.length - index - 1].key,
                    foodFeedBackMessages.length - index - 1),
              ),
            ),
            new Text(
              "Comment: $comment",
              style: Theme.of(context).textTheme.subtitle,
            ),
          ],
        ),
      ),
    );
  }

  bool handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      //save form data to database
      databaseReference.push().set(foodFeedback.toJson());
      final snackBar = SnackBar(
        content: Text('Thank you for your post!'),
        duration: Duration(seconds: 1),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      return true;
    } else {
      return false;
    }
  }

  void _onEntryAdded(Event event) {
    setState(() {
      foodFeedBackMessages.add(FoodFeedback.fromSnapshot(event.snapshot));
    });
  }

  void handleRemove(String key, int index) {
    setState(() {
      databaseReference.child(key).remove();
//      foodFeedBackMessages.removeAt(index);
    });
  }

  void _onEntryRemoved(Event event) {
    var deletedPost = foodFeedBackMessages.singleWhere((post) {
      return post.key == event.snapshot.key;
    });

    setState(() {
      foodFeedBackMessages.removeAt(foodFeedBackMessages.indexOf(deletedPost));
    });
  }

//  List<FoodFeedback> getData() {
//    foodFeedBackMessages.forEach((item) => debugPrint(item.title));
//    return foodFeedBackMessages;
//  }

//  void _addFeedback() {
//    var route = new MaterialPageRoute(
//      builder: (context) => new AddFeeback(),
//    );
//    Navigator.of(context).push(route);
//  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: Column(
        children: <Widget>[
          Center(
            child: Form(
              key: formKey,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      autofocus: true,
                      decoration:
                          InputDecoration(hintText: "Title of Restaurant"),
                      keyboardType: TextInputType.multiline,
                      initialValue: "",
                      onSaved: (val) => foodFeedback.title = val,
                      validator: (val) => val == ""
                          ? "please input the restaurant's title"
                          : null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: TextFormField(
                      autofocus: true,
                      initialValue: "",
                      decoration: InputDecoration(
                        hintText: "Location of Restaurant",
                      ),
                      keyboardType: TextInputType.multiline,
                      onSaved: (val) => foodFeedback.location = val,
                      validator: (val) => val == ""
                          ? "please input the restaurant's location"
                          : null,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.feedback),
                    title: TextFormField(
                      autofocus: true,
                      initialValue: "",
                      decoration: InputDecoration(hintText: "Your Comments"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      onSaved: (val) => foodFeedback.comment = val,
                      validator: (val) =>
                          val == "" ? "please leave a comment" : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              if (handleSubmit()) {
                Navigator.pop(context);
              } else {}
            },
            child: Text("save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}

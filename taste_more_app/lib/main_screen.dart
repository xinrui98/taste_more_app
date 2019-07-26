import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  var _searchTitleTextController = new TextEditingController();
  var _searchLocationTextController = new TextEditingController();
  bool _firstSearchTitle = true;
  bool _firstSearchLocation = true;
  String _queryTitle = "";
  String _queryLocation = "";
  List<FoodFeedback> _filterList;

  MainScreenState() {
    //search title
//Register a closure to be called when the object changes.
    _searchTitleTextController.addListener(() {
      if (_searchTitleTextController.text.isEmpty) {
//Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearchTitle = true;
          _queryTitle = "";
        });
      } else {
        setState(() {
          _firstSearchTitle = false;
          _queryTitle = _searchTitleTextController.text;
        });
      }
    });

    //search location
    //Register a closure to be called when the object changes.
    _searchLocationTextController.addListener(() {
      if (_searchLocationTextController.text.isEmpty) {
//Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearchLocation = true;
          _queryLocation = "";
        });
      } else {
        setState(() {
          _firstSearchLocation = false;
          _queryLocation = _searchLocationTextController.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    databaseReference = database.reference().child("food_feedbacks");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildRemoved.listen(_onEntryRemoved);

//    databaseReference.once().then((DataSnapshot snapshot) {
//      var KEYS = snapshot.value.key;
//      var DATA = snapshot.value;
//
//      foodFeedBackMessages.clear();
//
//      for (var individualKey in KEYS) {
//        FoodFeedback foodFeedback =
//            new FoodFeedback(DATA['title'], DATA['location'], DATA['comment']);
//        print(foodFeedback.title);
//
//        foodFeedBackMessages.add(foodFeedback);
//      }
//      setState(() {
//        print("Length : ${foodFeedBackMessages.length}");
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: (_firstSearchTitle == true && _firstSearchLocation == true)
          ?
          //when user has NOT searched
          new AppBar(
              backgroundColor: Colors.green,
              title: new Text("Taste More, Waste Less!"),
              centerTitle: true,
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.add_comment,
                    size: 35.0,),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new UploadDataPage();
                      }));
                      for (foodFeedback in foodFeedBackMessages) {
                        print(foodFeedback.title);
                      }
                    }),
              ],
            )
          :
          //when user has searched
          new AppBar(
              backgroundColor: Colors.green,
              title: new Text("Taste More, Waste Less!"),
              centerTitle: true,
              actions: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      _searchTitleTextController.clear();
                      _searchLocationTextController.clear();
                      //dismiss keyboard after returning to main screen
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    }),
              ],
            ),
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_strawberry.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            //search title
            Flexible(
              flex: 0,
              child: Center(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.fastfood, color: Colors.black87,),
                      title: TextField(
                        controller: _searchTitleTextController,
                        decoration: InputDecoration(
                          hintText: "Restaurant Title",
                          hintStyle: new TextStyle(color: Colors.black54),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.search, color: Colors.black87,),
                    ),
                  ],
                ),
              ),
            ),
            //search location
            Flexible(
              flex: 0,
              child: Center(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.black87,),
                      title: TextField(
                        controller: _searchLocationTextController,
                        decoration: InputDecoration(
                          hintText: "Restaurant Location",
                          hintStyle: new TextStyle(color: Colors.black54),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.search, color: Colors.black87,),
                    ),
                  ],
                ),
              ),
            ),
            (_firstSearchTitle == true && _firstSearchLocation == true)
                ? Flexible(
                    child: foodFeedBackMessages.length == 0
                        ? new Text("No Feedbacks Available")
                        : new ListView.builder(
                            reverse: false,
                            itemCount: foodFeedBackMessages.length,
                            itemBuilder: (_, index) {
                              return feedbackMessagesUI(
                                  foodFeedBackMessages[
                                          foodFeedBackMessages.length -
                                              index -
                                              1]
                                      .title,
                                  foodFeedBackMessages[
                                          foodFeedBackMessages.length -
                                              index -
                                              1]
                                      .location,
                                  foodFeedBackMessages[
                                          foodFeedBackMessages.length -
                                              index -
                                              1]
                                      .comment,
                                  index);
                            }),
                  )
                : _performSearch(),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget feedbackMessagesUI(
      String title, String location, String comment, int index) {
    return new Card(
//      elevation: 1.0,
      margin: EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
      child: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/card_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
//        padding: new EdgeInsets.all(3.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new Text("Title: $title",
                  style: Theme.of(context).textTheme.title),
              subtitle: new Text("Location: $location",
                  style: Theme.of(context).textTheme.subhead),
              trailing: Listener(
//                key: Key(foodFeedBackMessages[index].key),
                child: Icon(
                  Icons.remove_circle,
                  size: 30.0,
                  color: Colors.redAccent,
                ),
                onPointerDown: (pointerEvent) => handleRemove(
                    foodFeedBackMessages[
                            foodFeedBackMessages.length - index - 1]
                        .key),
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

  //Perform actual search
  Widget _performSearch() {
    _filterList = new List<FoodFeedback>();
    //only search title
    if (_firstSearchTitle == false && _firstSearchLocation == true) {
      for (int i = 0; i < foodFeedBackMessages.length; i++) {
        var foodFeedbackTitle = foodFeedBackMessages[i].title;
        var foodFeedback = foodFeedBackMessages[i];
        if (foodFeedbackTitle
            .toLowerCase()
            .contains(_queryTitle.toLowerCase())) {
          _filterList.add(foodFeedback);
        }
      }
      return _createFilteredListView();
    }
    //only search location
    if (_firstSearchLocation == false && _firstSearchTitle == true) {
      for (int i = 0; i < foodFeedBackMessages.length; i++) {
        var foodFeedbackLocation = foodFeedBackMessages[i].location;
        var foodFeedback = foodFeedBackMessages[i];
        if (foodFeedbackLocation
            .toLowerCase()
            .contains(_queryLocation.toLowerCase())) {
          _filterList.add(foodFeedback);
        }
      }
      return _createFilteredListView();
    }

    //search both title and location
    if (_firstSearchTitle == false && _firstSearchLocation == false) {
      for (int i = 0; i < foodFeedBackMessages.length; i++) {
        var foodFeedbackLocation = foodFeedBackMessages[i].location;
        var foodFeedbackTitle = foodFeedBackMessages[i].title;
        var foodFeedback = foodFeedBackMessages[i];
        if (foodFeedbackTitle
                .toLowerCase()
                .contains(_queryTitle.toLowerCase()) &&
            foodFeedbackLocation
                .toLowerCase()
                .contains(_queryLocation.toLowerCase())) {
          _filterList.add(foodFeedback);
        }
      }
      return _createFilteredListView();
    }
  }

  //Create the Filtered ListView
  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
//              elevation: 1.0,
              margin: EdgeInsets.fromLTRB(12.0, 2.0, 12.0, 2.0),
              child: new Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/card_background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
//                padding: new EdgeInsets.all(3.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ListTile(
                      title: new Text("Title: ${_filterList[index].title}",
                          style: Theme.of(context).textTheme.title),
                      subtitle: new Text(
                          "Location: ${_filterList[index].location}",
                          style: Theme.of(context).textTheme.subhead),
//                      trailing: Listener(
////                key: Key(foodFeedBackMessages[index].key),
//                        child: Icon(
//                          Icons.remove_circle,
//                          color: Colors.redAccent,
//                        ),
//                        onPointerDown: (pointerEvent) => handleRemove(
//                            foodFeedBackMessages[
//                            foodFeedBackMessages.length - index - 1].key,
//                            foodFeedBackMessages.length - index - 1),
//                      ),
                    ),
                    new Text(
                      "Comment: ${_filterList[index].comment}",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  void handleRemove(String key) {
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

  //not used
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

  //not used
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

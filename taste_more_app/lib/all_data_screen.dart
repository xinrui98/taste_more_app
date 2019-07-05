import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'main_screen.dart';
import 'model/food_feedback.dart';

class AllDataScreen extends StatefulWidget {
  @override
  AllDataScreenState createState() => AllDataScreenState();
}

class AllDataScreenState extends State<AllDataScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("assets/main_screen.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
//              query: MainScreenState.databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(""),
                      backgroundColor: Colors.red,
                    ),
                    title: ListTile(
                        title: Text("Title  : "
                           ),
                        subtitle: Text("Location  : " )),
                    subtitle: Text( "Comments  : "),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

//  void taskFinished(int index) {
//    _listTasks.removeAt(index);
//    _listTasksDescription.removeAt(index);
//    setState(() {});
//  }
}

class AddTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> _listTasksTitleDescription = [];
    var _taskTitleController = new TextEditingController();
    var _taskDescriptionController = new TextEditingController();
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Add Task'),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'assets/add_task.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(hintText: 'Enter Task'),
                  controller: _taskTitleController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new TextField(
                  decoration:
                      new InputDecoration(hintText: 'Enter Task Description'),
                  controller: _taskDescriptionController =
                      new TextEditingController(),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      _listTasksTitleDescription.add(_taskTitleController.text);
                      _listTasksTitleDescription
                          .add(_taskDescriptionController.text);
                      Navigator.pop(
                        context,
                        {'enter': _listTasksTitleDescription},
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    child: Text('Add Task')),
              )
            ],
          )
        ],
      ),
    );
  }
}

class EditTask extends StatelessWidget {
  String _initialTitle;
  String _initialDescription;

  EditTask(this._initialTitle, this._initialDescription);

  @override
  Widget build(BuildContext context) {
    List<String> _listTasksTitleDescription = [];
    var _editTaskTitleController =
        new TextEditingController(text: _initialTitle);
    var _editTaskDescriptionController =
        new TextEditingController(text: _initialDescription);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Edit Task'),
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'assets/edit_task.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(hintText: 'Edit Task'),
                  controller: _editTaskTitleController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new TextField(
                  decoration:
                      new InputDecoration(hintText: 'Edit Task Description'),
                  controller: _editTaskDescriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      _listTasksTitleDescription
                          .add(_editTaskTitleController.text);
                      _listTasksTitleDescription
                          .add(_editTaskDescriptionController.text);
                      Navigator.pop(
                        context,
                        {'enter': _listTasksTitleDescription},
                      );
                    },
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    child: Text('Confirm Edit Task')),
              )
            ],
          )
        ],
      ),
    );
  }
}

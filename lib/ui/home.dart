import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterfirebase/model/board.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Board> bmessage = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();
    board = Board("", "");
    databaseReference = database.reference().child("communitymessage");
    databaseReference.onChildAdded.listen(_entrydata);
    databaseReference.onChildAdded.listen(_entryadded);
    databaseReference.onChildAdded.listen(_entrychanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("firebase"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
              flex: 0,
              child: Center(
                child: Form(
                  key: formkey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.subject),
                        title: new TextFormField(
                          initialValue: "",
                          onSaved: (val) => board.subject = val,
                          validator: (val) => val == "" ? val : null,
                          decoration:InputDecoration(
                            hintText: "subject"
                          ) ,

                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.message),
                        title: new TextFormField(
                          initialValue: "",
                          onSaved: (val) => board.body = val,
                          validator: (val) => val == "" ? val : null,
                          decoration:InputDecoration(
                              hintText: "body"
                          ) ,
                        ),


                      ),
                      FlatButton(
                        child: new Text("post"),
                        color: Colors.redAccent,
                        onPressed: () {
                          handelsubmit();
                        },
                      )
                    ],
                  ),
                ),
              )),
          new Flexible(
            flex: 1,
            child: FirebaseAnimatedList(
                query: databaseReference,
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (_, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new Card(
                    child: ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: new Text(bmessage[index].subject.substring(0,1).toUpperCase().toString()),

                      ),
                      title: Text(bmessage[index].subject.toString()),
                      subtitle: Text(bmessage[index].body.toString()),
                    ),

                  );
                }),
          )
        ],
      ),
    );
  }

  void _entrydata(Event event) {
    setState(() {
      bmessage.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handelsubmit() {
    final FormState form = formkey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      databaseReference.push().set(board.toJSON());
    }
  }

  void _entryadded(Event event) {
  }

  void _entrychanged(Event event) {
    var oldentry = bmessage.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });
    setState(() {
      bmessage[bmessage.indexOf(oldentry)]=Board.fromSnapshot(event.snapshot);
    });

  }
}


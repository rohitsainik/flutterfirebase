import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Board {
  String key;
  String body;
  String subject;

  Board(this.subject, this.body);

  Board.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    subject = snapshot.value["subject"];
    body = snapshot.value["body"];
  }


  toJSON(){
    return {
      "subject": subject,
      "body": body
  };
}


}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Clipboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('clipboard').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
              snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['category']),
                  subtitle: new Text(document['url']),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';

class ClipboardScreen extends StatelessWidget {
  final UserProfile userProfile;

  const ClipboardScreen({Key key, this.userProfile}) : super(key: key);

  static Route<dynamic> route(userProfile) {
    return MaterialPageRoute(
      builder: (context) => ClipboardScreen(
            userProfile: userProfile,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: firebaseCalls.handleLogOut,
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: userProfile.photoUrl == null
                      ? NetworkImage(
                          'https://graph.facebook.com/${userProfile.id}/picture?type=normal')
                        : NetworkImage(userProfile.photoUrl),
                ),
              ),
            ),
            Text(
              userProfile.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('clipboard').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return ListTile(
                    title: Text(document['category']),
                    subtitle: Text(document['url']),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}

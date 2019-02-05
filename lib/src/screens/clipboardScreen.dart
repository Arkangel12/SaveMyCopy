import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';
import 'package:savemycopy/src/screens/webViewScreen.dart';
import 'package:savemycopy/src/widgets/addClipboard.dart';

class ClipboardScreen extends StatelessWidget {
  final UserProfile userProfile;

  ClipboardScreen({Key key, this.userProfile}) : super(key: key);

  static Route<dynamic> route(userProfile) {
    return MaterialPageRoute(
      builder: (context) => ClipboardScreen(
            userProfile: userProfile,
          ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PersistentBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    return ListTile(
                      onTap: () => Navigator.of(context).push(
                            WebViewScreen.route(
                              document['url'],
                            ),
                          ),
                      title: Text(document['category']),
                      subtitle: Text(document['url']),
                    );
                  },
                ).toList(),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller = _scaffoldKey.currentState
              .showBottomSheet<Null>((BuildContext context) {
            return AddClipboard(controller: controller);
          });
        },
        icon: Icon(Icons.bookmark),
        label: Text('Add Clipboard'),
      ),
    );
  }
}


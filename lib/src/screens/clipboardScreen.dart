import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savemycopy/src/api/backend.dart';
import 'package:savemycopy/src/screens/webViewScreen.dart';
import 'package:savemycopy/src/widgets/addClipboard.dart';
import 'package:clipboard_plugin/clipboard_plugin.dart';

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
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red),
        title: Text('Your Saved Links', style: TextStyle(color: Colors.red)),
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
              '${userProfile.name}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseCalls.getMyClipboards,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading...');
            default:
              return ListView(
                children: snapshot.data.documents.map(
                  (DocumentSnapshot document) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                            WebViewScreen.route(
                              document['url'],
                            ),
                          ),
                      onLongPress: () {
                        ClipboardPlugin.copyToClipBoard(document['url'])
                            .then((result) {
                          final snackBar = SnackBar(
                            content: Text('Copied to Clipboard'),
                            duration: Duration(milliseconds: 1500),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                ClipboardPlugin.copyToClipBoard('');
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              document['category'].toString().toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              document['url'],
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                      ),
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
            return AddClipboard(
              controller: controller,
            );
          });
        },
        icon: Icon(Icons.bookmark),
        label: Text('Add Clipboard'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savemycopy/src/models/userProfile.dart';

class AddClipboard extends StatefulWidget {
  final PersistentBottomSheetController controller;
  final UserProfile userProfile;

  const AddClipboard({Key key, this.controller, this.userProfile})
      : super(key: key);

  @override
  _AddBookmarkState createState() => _AddBookmarkState();
}

class _AddBookmarkState extends State<AddClipboard> {
  var _description;
  var _url;
  double _opacity = 0;

  // TODO: debe pasarse a clipboardBloc
  void saveClipboard() {
    if (_description != null &&
        _url != null &&
        _description.toString().trim() != '' &&
        _url.toString().trim() != '') {
      Firestore.instance.collection('clipboard').document().setData({
        'category': _description,
        'url': _url,
        'uid': widget.userProfile.id
      });
      widget.controller.close();
      setState(() {
        _opacity = 0;
      });
    } else {
      setState(() {
        _opacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 220,
      margin: EdgeInsets.only(top: 20, bottom: 30, left: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  splashColor: Colors.redAccent,
                  icon: Icon(
                    Icons.close,
                    color: Colors.blueGrey,
                  ),
                  onPressed: () => widget.controller.close(),
                )
              ],
            ),
            TextField(
              onChanged: (val) => _description = val,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Description',
              ),
            ),
            TextField(
              onChanged: (val) => _url = val,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Website Url',
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 1500),
              opacity: _opacity,
              child: Text(
                'Invalid Values',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                InkWell(
                  onTap: saveClipboard,
                  child: Container(
                    width: 45,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red,
                          offset: Offset(-1, -1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.save,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

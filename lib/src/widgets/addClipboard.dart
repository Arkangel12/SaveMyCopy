import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClipboard extends StatefulWidget {
  final PersistentBottomSheetController controller;

  const AddClipboard({Key key, this.controller}) : super(key: key);

  @override
  _AddBookmarkState createState() => _AddBookmarkState();
}

class _AddBookmarkState extends State<AddClipboard> {
  var _description;
  var _url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 150,
      margin: EdgeInsets.only(top: 20, bottom: 30, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (_description != '' && _url != '') {
                    Firestore.instance
                        .collection('clipboard')
                        .document()
                        .setData({'category': _description, 'url': _url});
                    widget.controller.close();
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        offset: Offset(-1, -2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

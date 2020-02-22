import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold (body:
    new Container(child: new Center(
      child: new Column(
        children: <Widget>[
          Photo(),
        ],
      ),
    )
    )
    );
  }
}

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: FlatButton(
        onPressed: null,
      ),
    );
  }

}

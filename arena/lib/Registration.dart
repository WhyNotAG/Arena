import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
        appBar: new AppBar(
            title: new Text('Flutter.su'),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.blue),
        ),
        body: new Container(child: new Center(
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

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(sourcePath: image.path,
    maxHeight: 512, maxWidth: 512, cropStyle: CropStyle.circle);
    setState(() {
      _image = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: FlatButton(child:
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)),color: Colors.grey,),
          height: 167,
          width: 167,
          child: _image == null ? new Align(child: new Text("Добавьте фотографии",style: TextStyle(
              fontSize: 14.0,
              fontFamily: "Montserrat-Bold",
              fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
          ), alignment: Alignment.center,) :
          Container(
            child: Container(padding: EdgeInsets.all(7.0),decoration: BoxDecoration(color: Colors.grey.withAlpha(10),), child: Container(
              padding: EdgeInsets.only(left:15.0, right:15.0),
              decoration: BoxDecoration(color:Color.fromARGB(120 , 141, 141, 141),
                image: DecorationImage(image: FileImage(_image),
                  fit: BoxFit.contain),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(100.0),
                    topRight: const Radius.circular(100.0),
                    bottomLeft: const Radius.circular(100.0),
                    bottomRight:const Radius.circular(100.0)),),
            ),),
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                    image: FileImage(_image),
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                    fit: BoxFit.contain)
            ),
            //padding: const EdgeInsets.all(20.0),
            ),
        ),
        onPressed:  (){
            getImage();
          },
      ),
    );
  }

}



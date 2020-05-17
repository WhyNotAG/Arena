import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';

import 'Place.dart';


class PhotoGrid extends StatelessWidget {
  Place place;


  PhotoGrid(this.place);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(crossAxisCount: 3,
          padding: EdgeInsets.only(top: 16.0),
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          children: List.generate(place.customImages.length, (index){
            return InkWell(
              child: Container(
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: place.customImages[index].fullImage,
                  fit: BoxFit.fill,),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return  DetailScreen(place.customImages[index].fullImage);
                }));
              },
            );
          })
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  String img;

  DetailScreen(this.img);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
          children: [
        Container(
        child: PhotoView(imageProvider: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: img,).image,
          backgroundDecoration: BoxDecoration(color: Colors.white.withAlpha(120)), minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 1.1,)),
            InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 16, top: 60),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40)
                ),
                width: 40,
                height: 40,
                child:  Tab(
                    icon: new Image.asset("assets/images/arrowWithBack.png")
                ),
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ],
      ),
    );
  }
}
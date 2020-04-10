import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
            return Container(
              child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: place.customImages[index].thumbImage,
            fit: BoxFit.fill,),);
          })
      ),
    );
  }
}

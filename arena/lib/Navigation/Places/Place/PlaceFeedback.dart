import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:flutter/material.dart';

import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FeedBackPlace extends StatefulWidget {
  int id;

  FeedBackPlace(this.id);

  @override
  _FeedBackPlaceState createState() => _FeedBackPlaceState(id);
}

class _FeedBackPlaceState extends State<FeedBackPlace> {
  int id;
  String result;
  String name;
  var response;
  double rating;
  bool isRecommend;


  _FeedBackPlaceState(this.id);


  @override
  void initState() {
    rating = 0;
    isRecommend = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      onHorizontalDragCancel: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 16, top: 35, right: 16),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Text("Написать отзыв", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                      fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 79, 79, 79)),),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Ваша оценка", textAlign: TextAlign.left, style: TextStyle(fontFamily: "Montserrat-Regular",
                          fontSize: 16, color: Color.fromARGB(255, 79, 79, 79)),),
                      SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: rating,
                          onRatingChanged: (value) {
                            setState(() {
                              rating = value;
                            });
                          },
                          size: 20.0,
                          filledIconData: CustomIcons.fill_star,
                          defaultIconData: CustomIcons.star,
                          halfFilledIconData: CustomIcons.fill_star,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0.0),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    style: TextStyle(fontFamily: "Montserrat-Regular",
                        fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                    minLines: 1,
                    decoration: InputDecoration(border: OutlineInputBorder(
                      borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 1.0),
                    ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 1.0),),
                        hintText: "Имя",
                        hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                            fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                    onChanged: (value){
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontFamily: "Montserrat-Regular",
                        fontWeight: FontWeight.bold, fontSize: 14, color: Color.fromARGB(255, 79, 79, 79)),
                    minLines: 4,
                    decoration: InputDecoration(border: OutlineInputBorder(
                      borderSide: new BorderSide(color: Color.fromARGB(255, 79, 79, 79), width: 2.0),
                    ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(color: Color.fromARGB(255, 47, 128, 237), width: 2.0),),
                        hintText: "Расскажите о ваших впечатлениях",
                        hintStyle:  TextStyle(fontFamily: "Montserrat-Regular",
                            fontSize: 14, color: Color.fromARGB(255, 130, 130, 130))),
                    onChanged: (value){
                      setState(() {
                        result = value;
                      });
                    },
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(isRecommend ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent, size: 14,),
                        Container(margin: EdgeInsets.only(left: 8), child: Text("Рекомендую", style: TextStyle(fontFamily: "Montserrat-Regular",
                            fontSize: 12, color: Color.fromARGB(255, 130, 130, 130)),),)
                      ],),),
                  onTap: (){
                    setState(() {
                      isRecommend = !isRecommend;
                    });
                  },
                ),
                Expanded(child:SizedBox(height: 400,)),
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomCenter,
                  height: 56,
                  margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(border:
                  Border.all(color: Color.fromARGB(255, 47, 128, 237),width: 2),
                      borderRadius: BorderRadius.circular(30)),
                  child: FlatButton(child: Text("Отправить отзыв",
                    style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                        color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),
                    onPressed: () async{
                      var token = await getStringValuesSF("accessToken");
                      if (token != null) {
                        response = await postWithToken("${server}feedback/${id}", {"feedback" : result, "authorName": name,
                          "date": DateTime.now().millisecondsSinceEpoch, "isRecommended": isRecommend, "rating": rating});
                      } else{
                        Navigator.pop(context);
                      }

                      if(response.statusCode == 200) {
                        Navigator.pop(context);
                      }
                    },),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


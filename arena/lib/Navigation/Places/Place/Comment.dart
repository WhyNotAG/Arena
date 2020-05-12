import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:arena/Navigation/Places/Place/PlaceFeedback.dart';
import 'package:http/http.dart' as http;
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'Place.dart';

class Comment {
  String author;
  int date;
  String feedback;
  int id;
  bool isRecommended;
  double rating;

  Comment(
      {this.author,
      this.date,
      this.feedback,
      this.id,
      this.isRecommended,
      this.rating});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        author: json["authorName"] as String,
        date: json["date"] as int,
        feedback: json["feedback"] as String,
        id: json["id"] as int,
        isRecommended: json["isRecommended"] as bool,
        rating: json["rating"] as double);
  }
}

class Content {
  List<Comment> comments;

  Content({this.comments});

  factory Content.fromJson(Map<String, dynamic> json) {
    var contentList = json["content"] as List;
    List<Comment> comments =
        contentList.map((i) => Comment.fromJson(i)).toList();
    return Content(comments: comments);
  }
}

Future<Content> fetchContent(int id) async {
  Content content = new Content();
  var response;

  var token = await getStringValuesSF("accessToken");
  if (token != null) {
    response = await getWithToken("${server}feedback/${id}/?page=0");
  } else {
    response = await http.get('${server}feedback/${id}/?page=0',
        headers: {"Content-type": "application/json"});
  }


  Map<String, dynamic> responseJson =
      json.decode(utf8.decode(response.bodyBytes));

  if (response.statusCode == 200) {
    content = Content.fromJson(responseJson);
    return content;
  } else {
    throw Exception('Failed to load album');
  }
}

class CommentWidget extends StatelessWidget {
  Comment comment;

  CommentWidget(this.comment);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 22, top: 16, bottom: 30),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(comment.author != null ? comment.author : "",
                  style: TextStyle(
                    fontFamily: "Montserrat-Regular",
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 79, 79, 79),
                    fontSize: 14,
                  )),
              Text(
               DateFormat("dd MMMM y").format(DateTime.fromMillisecondsSinceEpoch(comment.date * 1000)),
                style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 47, 128, 237),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                comment.isRecommended
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: Color.fromARGB(255, 235, 87, 87),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 4),
                            child: Text("Рекомендую",
                                style: TextStyle(
                                  fontFamily: "Montserrat-Regular",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 130, 130, 130),
                                  fontSize: 12,
                                )),
                          )
                        ],
                      )
                    : Container(),
                SmoothStarRating(
                    allowHalfRating: false,
                    starCount: 5,
                    rating: comment.rating != null ? comment.rating : 0,
                    size: 14.0,
                    filledIconData: CustomIcons.fill_star,
                    defaultIconData: CustomIcons.star,
                    halfFilledIconData: CustomIcons.fill_star,
                    color: Colors.orangeAccent,
                    borderColor: Colors.orangeAccent,
                    spacing: 0.0),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10),
            child: Text(comment.feedback == null ? "" : comment.feedback,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Montserrat-Regular",
                  color: Colors.black87,
                  fontSize: 12,
                )),
          )
        ],
      ),
    );
  }
}


class CommentList extends StatefulWidget {
  int id;
  bool inBook;
  CommentList(this.id, this.inBook);

  @override
  _CommentListState createState() => _CommentListState(id, inBook);
}

class _CommentListState extends State<CommentList> {
  int id;
  bool inBook;
  _CommentListState(this.id, inBook);

  Future content;
  List<CommentWidget> commentWidgets = List();

  @override
  void initState() {
    if(inBook == null){
      inBook = true;
    }
    print(inBook);

    content = fetchContent(id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(
      child: FutureBuilder<Content>(
        future: content,
        builder: (context, snapshot){
      switch(snapshot.connectionState) {
        case ConnectionState.none:
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 16),
            child: Text("Отсутсвует соединение с интернетом"),
          );
        case ConnectionState.waiting:
          return Center(
              child: CircularProgressIndicator()
          );
        default:
          if (snapshot.hasData && snapshot.data.comments.length >= 1) {
            for (Comment comment in snapshot.data.comments) {
              if (commentWidgets.length < snapshot.data.comments.length) {
                commentWidgets.add(CommentWidget(comment));
              }
            }
            return Column(children: <Widget>[
              Column(children: commentWidgets,),
              inBook ? Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 12),

                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(30.0),
                  color: Color.fromARGB(255, 47, 128, 237),),

                width: double.infinity,
                height: 56,

                child: FlatButton(child: Text("Написать отзыв",
                  style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
                      color: Colors.white, fontWeight: FontWeight.bold),),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedBackPlace(id)),
                      );
                      content = fetchContent(id);
                    });
                  },),) : Container(),
              SizedBox(height: 30,)
            ],);
          }
          else {
            return Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Text("Нет отзывов", style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 12,
                    color: Color.fromARGB(255, 130, 130, 130), fontWeight: FontWeight.bold),), alignment: Alignment.topCenter,),
              inBook ? Container(
                child: FlatButton(child: Text("Написать отзыв",
                  style: TextStyle(
                  decoration: TextDecoration.underline, fontSize: 14.0,
                  fontFamily: "Montserrat-Regular",
                  color:Color.fromARGB(255, 130, 130, 130))
                  ),
                  color: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Color.fromARGB(255, 130, 130, 130),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedBackPlace(id)),
                      );
                      content = fetchContent(id);
                    });
                  },),) : Container(),
              SizedBox(height: 8, width: 8,)
            ],);
          }
          }
        },
      ),
    ));
  }
}

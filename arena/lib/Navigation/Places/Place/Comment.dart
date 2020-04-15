import 'dart:convert';

import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:http/http.dart' as http;
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
    response = await getWithToken("http://217.12.209.180:8080/api/v1/feedback/${id}/");
  } else {
    response = await http.get('http://217.12.209.180:8080/api/v1/feedback/${id}/',
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
            child: Text(comment.feedback,
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

  CommentList(this.id);

  @override
  _CommentListState createState() => _CommentListState(id);
}

class _CommentListState extends State<CommentList> {
  int id;

  _CommentListState(this.id);

  Future content;
  List<CommentWidget> commentWidgets = List();

  @override
  void initState() {
    content = fetchContent(id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(
      child: FutureBuilder<Content>(
        future: content,
        builder: (context, snapshot){
          if (snapshot.hasData && snapshot.data.comments.length >= 1){
            for(Comment comment in snapshot.data.comments) {
              commentWidgets.add(CommentWidget(comment));
            }
            return Column(children: commentWidgets,);
          }
          else if(snapshot.hasData) {
            return Container(child: Text("Нет отзывов"), alignment: Alignment.topCenter,);
          }
          else { return Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 30,
                    height: 30),
              ));}
        },
      ),
    ));
  }
}

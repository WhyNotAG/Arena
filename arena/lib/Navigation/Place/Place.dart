import 'package:arena/Icons/custom_icons_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaceInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(
                        CustomIcons.star,
                        size: 28,
                        color: Colors.amber,
                      ),
                      padding: EdgeInsets.only(right: 21.0),
                    )
                  ],
                  leading: IconButton(
                    icon: Icon(
                      CustomIcons.arrowBack,
                      size: 16,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  expandedHeight: 264.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(child: Stack(
                            children: <Widget>[
                              new Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/login.jpeg"),
                                        fit: BoxFit.cover)
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 160),
                                  height: 100,
                                  color: Colors.black.withAlpha(50),
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text("\nteasfsfst sdasfa", textAlign: TextAlign.center, maxLines: 2, style: TextStyle(fontSize: 16,color: Colors.white),)
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 130),
                                height: 48,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/LOGO.png"), fit: BoxFit.fitHeight, ),
                                ),
                              ),
                            ],
                          ))),),
                  bottom: PreferredSize(
                    child: Container(
                      height: 56,
                      color: Colors.white,
                      child: Container(
                        child: TabBar(
                          labelColor: Color.fromARGB(255, 47, 128, 237),
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            new Tab(text: "Информация"),
                            new Tab(text: "Фотографии"),
                            new Tab(text: "Отзывы"),
                          ],
                        ),
                      ),
                    ),
                  ))
            ];
          },
          body: Center(
            child: Text("Sample text"),
          ),
        ),
      ),
    );
  }
}

class CustomSilverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight = 262;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          width: 262,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login.jpeg"),
                  fit: BoxFit.cover)),
          child: IconButton(
            icon: Icon(CustomIcons.star),
          ),
        ),
        TabBar(
          tabs: <Widget>[],
        )
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

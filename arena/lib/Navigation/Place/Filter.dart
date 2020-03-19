import 'package:arena/Other/CircleThumbShape.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;


class Filter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(112.0), child: TabBar(),),
      body:Container(color: Colors.white,child: SingleChildScrollView(child:Column(children: <Widget>[
        FilterWidget(name:"Вид спорта", value:["Все виды","sdd"].toList()),
        FilterWidget(name:"Метро", value:["Все виды","sdd"].toList()),
        SwitchWidget(name: "Открытая"),
        Container(
          margin: EdgeInsets.only(top: 28, left: 16, right: 20),
          child: Column(children: <Widget>[
            Container(width: double.infinity, child: Text("Дополнительно",
              style: TextStyle(
                fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,
                fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)
                ),
              ),
            ),
            Container(child: SwitchWidgetExtra(name: "Парковка")),
            Container(child: SwitchWidgetExtra(name: "Инвентарь")),
            Container(child: SwitchWidgetExtra(name: "Раздевалки")),
            Container(child: SwitchWidgetExtra(name: "Душевые")),
          ],),
        ),
        RangeSliderWidget(minValue: 0, maxValue: 15000),
        ButtonsWidget(),
      ],),
        )
      )
    );
  }
}



class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 60),
        width: double.infinity,
        height: 112,
        decoration: BoxDecoration(

            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0, // has the effect of softening the shadow
                spreadRadius: 0.0, // has the effect of extending the shadow
                offset: Offset(
                  10.0, // horizontal, move right 10
                  0.0, // vertical, move down 10
                ),
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Text("Фильтр", style: TextStyle(fontSize: 28, fontFamily: "Montserrat-Bold", color: Color.fromARGB(255, 79, 79, 79)),textAlign: TextAlign.left,),
              margin: EdgeInsets.only(left: 20.0), width: 120,
                height: 32,),
            Container(child: IconButton(icon: Icon(Icons.close), iconSize: 25, color: Color.fromARGB(255, 47, 128, 237), onPressed: (){Navigator.pop(context);},),padding: EdgeInsets.only(right:16), )
            //Container(child: IconButton(icon: Icon(CustomIcons.exit),),)
          ],
        ));
  }
}




class FilterWidget extends StatefulWidget {
  String name;
  List<String> value;

  FilterWidget({Key key, @required this.name, @required this.value,}) : super(key: key);
  @override
  _FilterWidgetState createState() => _FilterWidgetState(name, value);
}

class _FilterWidgetState extends State<FilterWidget> {
  String name;
  List<String> value;
  String input;

  _FilterWidgetState(var name, var value){
    this.name = name;
    this.value = value;
    input = value.first;

  }

  @override
    Widget build(BuildContext context) {
      return Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Column(children: <Widget>[
            Container(child: Text(name, textAlign: TextAlign.left, style: TextStyle(color: Color.fromARGB(255, 47, 128, 237)),),
            width: double.infinity, margin: EdgeInsets.only(bottom: 8.0),),
            Container(
              decoration: BoxDecoration(color:Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey,
                  blurRadius: 2.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    0.0, // vertical, move down 10
                  ),)
              ]),
              width: double.infinity,

                child: Stack(children: <Widget>[
                  Container(width: double.infinity,
                    margin: EdgeInsets.only(left: 16, right: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                      iconSize: 24,
                        style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                      //elevation: 22,
                      icon: Icon(Icons.close, color: Colors.red.withAlpha(0),),
                      value: input,
                      onChanged: (String newValue) {
                        setState(() {
                          input = newValue;
                        });
                      },
                      items: value.map<DropdownMenuItem<String>>((String valuer) {
                        return DropdownMenuItem<String>(
                          value: valuer,
                          child: Text(valuer),
                        );
                      }).toList()),),),
                   Align(child: Container(child: IconButton(icon: Icon(Icons.arrow_drop_down),),margin: EdgeInsets.only(right: 8.0),),alignment: Alignment.centerRight,)
                ],),
            )
          ],)
      );
  }
}


class SwitchWidget extends StatefulWidget {
  String name;

 SwitchWidget({Key key, @required this.name,}) : super(key: key);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState(name);
}

class _SwitchWidgetState extends State<SwitchWidget> {
  String name;
  bool isSwitched = true;
  bool isSwitched2 = true;

  _SwitchWidgetState(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //height: 30,
      margin: EdgeInsets.only(left: 16, right: 20, top: 28),
      child:  new Column(children: <Widget>[
        Container(
          width: double.infinity,
          child:new Text("Тип площадки", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)), textAlign: TextAlign.left,),),
        Container(
          margin: EdgeInsets.only(top: 8),
          child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(child: Text(name, style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
            Container(child: CupertinoSwitch(value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                  if(!isSwitched){
                    isSwitched2 = true;
                  }
                });
              },
              activeColor: Color.fromARGB(255, 47, 128, 237),),)
          ],
        ),),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(child: Text("Крытая", style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),),),
            Container(child: CupertinoSwitch(value: isSwitched2,
              onChanged: (value) {
                setState(() {
                  isSwitched2 = value;
                  if(!isSwitched2){
                    isSwitched = true;
                  }
                });
              },
              activeColor: Color.fromARGB(255, 47, 128, 237),),)
          ],
        ),
        Container(margin: EdgeInsets.only(top: 23, left: 8, right: 8), height: 1, color: Color.fromARGB(100, 47, 128, 237) )
      ],));
  }
}

class SwitchWidgetExtra extends StatefulWidget {
  String name;
  SwitchWidgetExtra({Key key, @required this.name,}) : super(key: key);

  @override
  _SwitchWidgetExtraState createState() => _SwitchWidgetExtraState(name);
}

class _SwitchWidgetExtraState extends State<SwitchWidgetExtra> {
  bool isSwitched = false;
  String name;


  _SwitchWidgetExtraState(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(child: new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(child: Text(name, style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),)),
        Container(child: CupertinoSwitch(value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          },
          activeColor: Color.fromARGB(255, 47, 128, 237),),)
      ],
    ),);
  }
}

class RangeSliderWidget extends StatefulWidget {
  int minValue;
  int maxValue;

  RangeSliderWidget({Key key, @required this.minValue, @required this.maxValue}) : super(key: key);
  @override
  _RangeSliderWidgetState createState() => _RangeSliderWidgetState(minValue, maxValue);
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  int minValue;
  int maxValue;
  RangeValues _values = new RangeValues(0, 12000.0);
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  _RangeSliderWidgetState(this.minValue, this.maxValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 28),
      child: Column(children: <Widget>[
        Container(width: double.infinity, child: Text("Стоиомость, RUB",
          style: TextStyle(
              fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold,
              fontSize: 12, color: Color.fromARGB(255, 47, 128, 237)
          ),
        ),
        ),
        Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 17),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              new Container(child: new Column(children: <Widget>[
                Container(child:new Text("От", style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 12, fontWeight: FontWeight.bold)), width: 96, alignment: Alignment.topLeft,),
                Container(
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.withAlpha(75), width: 2),),
                    width: 96,
                    height: 40,
                    child: new TextField(style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)),
                        decoration: InputDecoration(border: InputBorder.none, contentPadding: new EdgeInsets.fromLTRB(
                        10.0, 0.0, 10.0, 10.0),),
                      controller: firstController,
                    onChanged: (value) {
                  setState(() {
                    if (int.parse(firstController.text) <= 100000) {minValue = int.parse(firstController.text); firstController.text = minValue.toString();}
                    if (minValue >= maxValue) { maxValue = minValue; secondController.text = maxValue.toString();}
                    firstController.text = minValue.toString();
                  });
                }, keyboardType: TextInputType.number))
              ],),),
              new Container(child:  new Column(children: <Widget>[
                Container(child: new Text("До",
                  style: TextStyle(fontFamily: "Montserrat-Regular", fontSize: 12, fontWeight: FontWeight.bold), ), width: 96,),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.withAlpha(75), width: 2),),
                  width: 96,
                  height: 40,
                  child: new TextField(style: TextStyle(fontFamily: "Montserrat-Regular", fontWeight: FontWeight.bold, color: Color.fromARGB(255, 130, 130, 130)), decoration: InputDecoration(border: InputBorder.none, contentPadding: new EdgeInsets.fromLTRB(
                      10.0, 0.0, 10.0, 10.0),), controller: secondController,onChanged: (value) {
                setState(() {
                  if(int.parse(secondController.text) <= 100000) {maxValue = int.parse(secondController.text); secondController.text = maxValue.toString();}
                  if (minValue >= maxValue) { minValue = maxValue; firstController.text = minValue.toString();}
                  secondController.text = maxValue.toString();
                  });
                }, keyboardType: TextInputType.number),)
            ],))
            ],),
    ),
       Container(
         margin: EdgeInsets.only(top: 31),
         child:SliderTheme(
         data: SliderTheme.of(context).copyWith(
           activeTrackColor: Color.fromARGB(255, 47, 128, 237),
           thumbColor: Colors.grey,
           overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
           thumbShape: CircleThumbShape(thumbRadius: 15),
         ),
         child: frs.RangeSlider(
           min: 0.0,
           max: 100000.0,
           lowerValue: minValue.toDouble(),
           upperValue: maxValue.toDouble(),
           showValueIndicator: true,
           valueIndicatorMaxDecimals: 1,
           divisions: 500,
           onChanged: (double newLowerValue, double newUpperValue) {
             setState(() {
               minValue = newLowerValue.toInt();
               firstController.text = minValue.toString();
               maxValue = newUpperValue.toInt();
               secondController.text = maxValue.toString();
             });
           },
         ),
       ),),


      ])
    );
  }
}


class ButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 16),
      decoration: BoxDecoration(color: Colors.white,boxShadow: [
      BoxShadow(
        color: Colors.grey.withAlpha(50),
        blurRadius: 1.0, // has the effect of softening the shadow
        spreadRadius: -1.5, // has the effect of extending the shadow
        offset: Offset(
          0.0, // horizontal, move right 10
          -4, // vertical, move down 10
        ),
      )
    ],),
      child: Column(children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 32),
            width: double.infinity,
            child: Text("Найдено мест",
              style: TextStyle(fontFamily: "Montserrat-Regular",
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),),),
      Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 12),
        decoration: BoxDecoration(borderRadius: new BorderRadius.circular(30.0),
          color: Color.fromARGB(255, 47, 128, 237),),
        width: double.infinity, height: 56,
        child: FlatButton(child: Text("ПОКАЗАТЬ",
          style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
          color: Colors.white, fontWeight: FontWeight.bold),),
          color: Color.fromARGB(255, 47, 128, 237),),),

      Container(
        width: double.infinity,
        height: 56,
        margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 35),
        decoration: BoxDecoration(border: 
          Border.all(color: Color.fromARGB(255, 47, 128, 237),width: 2),
            borderRadius: BorderRadius.circular(30)),
        child: FlatButton(child: Text("СБРОСИТЬ",
          style: TextStyle(fontFamily: "Montserrat-Bold", fontSize: 12,
              color: Color.fromARGB(255, 47, 128, 237), fontWeight: FontWeight.bold),),),)
    ],),);
  }
}







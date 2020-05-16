import 'package:app_settings/app_settings.dart';
import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:arena/Other/Request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  String test;
  String result;
  int hour;
  Future future;
  List<String> tester = ["Включить за 1ч.", "Включить за 6ч.", "Включить за 12ч.", "Включить за 24ч."];

  Future fetchInfo() async {
   result = await getStringValuesSF("timeSTR");
   hour = await getIntValuesSF("time");
   setState(() {
     test = result;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Настройки", textAlign: TextAlign.center,
        style: TextStyle(fontFamily: "Montserrat-Bold",
            fontSize: 24, color: Color.fromARGB(
                255, 47, 128, 237)),),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 130, 130, 130), //change your color here
        ),
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                  child: CircularProgressIndicator()
              );
            default:
              return SafeArea(
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 30),
                        child: Text("Напомнить о брони", textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Montserrat-Regular",
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 47, 128, 237))),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(color: Colors.white,
                            border: Border.all(color: Colors.black.withAlpha(
                                100))),
                        child: Theme(
                          data: ThemeData(
                              canvasColor:
                              Colors.white),
                          child:
                          DropdownButtonHideUnderline(
                            child: DropdownButton(
                                isExpanded: true,
                                focusColor:
                                Colors.white,
                                iconSize: 24,
                                style: TextStyle(
                                    fontFamily:
                                    "Montserrat-Regular",
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    color: Color
                                        .fromARGB(255, 130, 130, 130)),
                                value: test,
                                onChanged: (String newValue) {
                                  setState(() {
                                    test =
                                        newValue;
                                    addStringToSF("timeSTR", test);
                                    print(test);
                                    switch (test) {
                                      case "Включить за 1ч.":
                                        addIntToSF("time", 1);
                                        break;
                                      case "Включить за 6ч.":
                                        addIntToSF("time", 6);
                                        break;
                                      case "Включить за 12ч.":
                                        addIntToSF("time", 12);
                                        break;
                                      case "Включить за 24ч.":
                                        addIntToSF("time", 24);
                                    }
                                  });
                                  return null;
                                },
                                items: tester.map<DropdownMenuItem<String>>(
                                        (String valuer) {
                                      return DropdownMenuItem<
                                          String>(
                                          value: valuer,
                                          child: Text(valuer));
                                    }).toList(),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          margin: EdgeInsets.only(top: 32),
                          color: Color.fromARGB(255, 47, 128, 237),
                          padding: EdgeInsets.all(10),
                          child: Text(
                              " Передача геоданных", textAlign: TextAlign
                              .center, style: TextStyle(
                              fontFamily: "Montserrat-Regular",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                        ),
                        onTap: () {
                          AppSettings.openAppSettings();
                        },
                      ),
                    ],
                  ),
                ),
              );
          }
        })
    );
  }
}

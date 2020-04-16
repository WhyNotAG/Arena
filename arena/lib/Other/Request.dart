import 'dart:convert';

import 'package:arena/Other/CustomSharedPreferences.dart';
import 'package:http/http.dart' as http;

import 'CustomSharedPreferences.dart';

Future refresh() async {
  var token = await getStringValuesSF("accessToken");
  var refToken = await getStringValuesSF("refreshToken");

  Map jsonFile = {
    "refreshToken": refToken.toString()
  };

  var response = await http.post('http://217.12.209.180:8080/api/v1/auth/refreshToken',
      body: json.encode(jsonFile),
      headers: {"Content-type": "application/json", "Authorization": "Bearer_${token}"});

  var decode = jsonDecode(response.body);
  await addStringToSF("accessToken", decode["accessToken"]);
  await addStringToSF("refreshToken", decode["refreshToken"]);
  await addIntToSF("expiredIn", decode["expiredIn"]);
  return await decode["accessToken"];
}

Future postWithToken(String url, [Map map]) async {
  var token = await getStringValuesSF("accessToken");
  var expIn = await getIntValuesSF("expiredIn");

  if( DateTime.fromMillisecondsSinceEpoch(expIn * 1000).isBefore(DateTime.now()))  {
    token = await refresh();
  }
  var response = await http.post(url,
      body: json.encode(map),
      headers: {"Content-type": "application/json", "Authorization": "Bearer ${token}"});

  if (response.statusCode != 200) {
    token = await refresh();
    response = await http.post(url,
        body: json.encode(map),
        headers: {"Content-type": "application/json", "Authorization": "Bearer ${token}"});
  }

  return response.body;
}


Future getWithToken(String url) async {
  var token = await getStringValuesSF("accessToken");
  var expIn = await getIntValuesSF("expiredIn");

  if( DateTime.fromMillisecondsSinceEpoch(expIn * 1000).isBefore(DateTime.now()))  {
    token = await refresh();
  }

  var response = await http.get(url,
      headers: {"Content-type": "application/json", "Authorization": "Bearer ${token}"});

  if (response.statusCode != 200) {
    token = await refresh();
    response = await http.get(url,
        headers: {"Content-type": "application/json", "Authorization": "Bearer ${token}"});
  }

  return response;
}
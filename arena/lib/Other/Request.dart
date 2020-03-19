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
  return await decode["accessToken"];
}
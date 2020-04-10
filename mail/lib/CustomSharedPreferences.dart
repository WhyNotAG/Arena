import 'package:shared_preferences/shared_preferences.dart';

getStringValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString(key);
  return stringValue;
}
getBoolValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = prefs.getBool(key);
  return boolValue;
}
getIntValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int intValue = prefs.getInt(key);
  return intValue;
}
getDoubleValuesSF(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double doubleValue = prefs.getDouble(key);
  return doubleValue;
}

addStringToSF(String name, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name, value);
}

addIntToSF(String name, int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(name, value);
}
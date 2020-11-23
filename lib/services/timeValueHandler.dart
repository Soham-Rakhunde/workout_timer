//import 'package:shared_preferences/shared_preferences.dart';

class TimeClass {
  int sec,x;
  String name;
  TimeClass({this.name,this.sec});
}

// class SavedWorkout{
//   String name;
//   int pMin;
//   int pSec;
//   int bMin;
//   int bSec;
//   int setsCount;
//   SavedWorkout({this.name,this.bMin,this.bSec,this.pMin,this.pSec,this.setsCount});
//
//   Map toJson() => {
//     'name' : name,
//     'pMin' : pMin,
//     'pSec' : pSec,
//     'bMin' : bMin,
//     'bSec' : bSec,
//     'setsCount' : setsCount,
//   };
//
//   SavedWorkout.fromJson(Map<String, dynamic> json):
//         name = json['name'],
//         pMin = json['pMin'],
//         pSec = json['pSec'],
//         bMin = json['bMin'],
//         bSec = json['bSec'],
//         setsCount = json['setsCount']
//   ;
// }
//
// class SharedPref {
//   read(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(key);
//   }
//
//   save(String key, List value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setStringList("key", value);
//     // prefs.setString(key, json.encode(value));
//   }
//
//   remove(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(key);
//   }
//}
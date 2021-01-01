import 'package:shared_preferences/shared_preferences.dart';

class TimeClass {
  int sec, x;
  String name;

  TimeClass({this.name, this.sec});
}

class SavedWorkout {
  String name;
  int pMin;
  int pSec;
  int bMin;
  int bSec;
  int setsCount;

  SavedWorkout(
      {this.name, this.bMin, this.bSec, this.pMin, this.pSec, this.setsCount});

  Map toMap() => {
        'name': name,
        'pMin': pMin,
        'pSec': pSec,
        'bMin': bMin,
        'bSec': bSec,
        'setsCount': setsCount,
      };

  SavedWorkout.fromMap(Map map)
      : name = map['name'],
        pMin = map['pMin'],
        pSec = map['pSec'],
        bMin = map['bMin'],
        bSec = map['bSec'],
        setsCount = map['setsCount'];
}

class SharedPref {
  Future<List<String>> read() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('List') == null) {
      return [];
    } else {
      return prefs.getStringList('List');
    }
  }

  Future<String> readString(String str) async {
    //Voice
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(str) == null) {
      return 'amy';
    } else {
      return prefs.getString(str);
    }
  }

  Future<bool> readBool(String str) async {
    //isVoice
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(str) == null) {
      if (str == 'isDark' || str == 'isContrast')
        return false;
      else
        return true;
    } else {
      print('$str   ${prefs.getBool(str)}');
      return prefs.getBool(str);
    }
  }

  reset(String key, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("List", []);
    // prefs.setString(key, json.encode(value));
  }

  save(List value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("List", value);
    // prefs.setString(key, json.encode(value));
  }

  saveString(String prefName, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefName, val);
    print('$prefName   $val');
  }

  saveBool(String prefName, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefName, val);
  }

  remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'timeValueHandler.g.dart';

@JsonSerializable(explicitToJson: true)
class SetClass {
  List<TimeClass>? timeList;
  int? sets;

  @JsonKey(ignore: true)
  double height = 300;
  String? grpName = 'Group';

  @JsonKey(ignore: true)
  TextEditingController nameController = TextEditingController(text: 'Group');

  @JsonKey(ignore: true)
  TextEditingController textController = TextEditingController(text: '01');

  @JsonKey(ignore: true)
  String retain = '-1';

  factory SetClass.fromJson(Map<String, dynamic> json) =>
      _$SetClassFromJson(json);

  Map<String, dynamic> toJson() => _$SetClassToJson(this);

  // Map<String, dynamic> toJson() {
  //   List<Map> timeList = this.timeList != null
  //       ? this.timeList.map((i) => i.toJson()).toList()
  //       : null;
  //   return {
  //     "grpName": this.grpName,
  //     "sets": this.sets,
  //     "timeList": timeList,
  //   };
  // }
  //
  SetClass.fromMap(Map map)
      : grpName = map['grpName'],
        sets = map['sets'],
        timeList = map['timeList'].map<TimeClass>((ele) {
          print('\nele $ele');
          return TimeClass.fromMap(ele);
        }).toList();

  void addRemove(bool flag) {
    int intValue = int.parse(textController.text);
    intValue = intValue - (flag ? -1 : 1);
    if (intValue <= 0) {
      intValue = 1;
    } else if (intValue >= 100) {
      intValue = 99;
    }
    String v = '$intValue';
    sets = intValue;
    v = v.length == 1 ? '0$v' : v;
    textController.text = v;
  }

  void listenerMaker() {
    if (retain == '-1') {
      retain = '01';
      textController.text = '01';
      sets = 1;
    } else {
      textController.text = retain;
      sets = int.parse(retain);
    }

    if (grpName == 'Group') {
      grpName = 'Group';
      nameController.text = 'Group';
    } else {
      nameController.text = grpName!;
    }

    textController.addListener(() {
      textController.selection = TextSelection(
        baseOffset: textController.text.length,
        extentOffset: textController.text.length,
      );
    });
    nameController.addListener(() {
      nameController.selection = TextSelection(
        baseOffset: nameController.text.length,
        extentOffset: nameController.text.length,
      );
    });
  }

  SetClass({this.timeList, this.sets, this.grpName}) {
    nameController = TextEditingController(text: grpName);
  }
}

@JsonSerializable(explicitToJson: true)
class TimeClass {
  int? sec = 30;
  bool? isWork = true;
  String? name = 'Work';

  @JsonKey(ignore: true)
  Map controllers = {
    'name': TextEditingController(text: 'Work'),
    'min': TextEditingController(text: '00'),
    'sec': TextEditingController(text: '30'),
  };

  @JsonKey(ignore: true)
  Map retained = {
    'name': '-1',
    'min': '-1',
    'sec': '-1',
  };

  TimeClass({this.isWork, this.sec, this.name}) {
    controllers['name'] = TextEditingController(text: name);
  }

  void initListenerMaker() {
    retained.forEach((key, value) {
      if (retained[key] == '-1') {
        if (key == 'sec') {
          retained[key] = '30';
          controllers[key].text = '30';
        } else if (key == 'name') {
          retained[key] = name;
          controllers[key].text = name;
        } else {
          retained[key] = '00';
          controllers[key].text = '00';
        }
      } else {
        controllers[key].text = retained[key];
      }
      controllers[key].addListener(() {
        controllers[key].selection = TextSelection(
          baseOffset: controllers[key].text.length,
          extentOffset: controllers[key].text.length,
        );
      });
    });
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "name": this.name,
  //     "sec": this.sec,
  //     "isWork": this.isWork,
  //   };
  // }
  //
  TimeClass.fromMap(Map map)
      : name = map['name'],
        sec = map['sec'],
        isWork = map['isWork'];

  factory TimeClass.fromJson(Map<String, dynamic> json) =>
      _$TimeClassFromJson(json);

  Map<String, dynamic> toJson() => _$TimeClassToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SavedAdvanced {
  String? name;
  List<SetClass>? groups;
  int? totalTime = 0;

  SavedAdvanced({this.name, this.groups, required this.totalTime});

  factory SavedAdvanced.fromJson(Map<String, dynamic> json) =>
      _$SavedAdvancedFromJson(json);

  Map<String, dynamic> toJson() => _$SavedAdvancedToJson(this);

// Map toMap() {
//   List<Map> groups = this.groups != null
//       ? this.groups.map((i) => i.toJson()).toList()
//       : null;
//   return {'name': name, 'groups': groups};
// }

// SavedAdvanced.fromJson(Map json) {
//   if (json['groups'] != null) {
//     var groupsJson = json['groups'] as List;
//     List<SetClass> _groups = groupsJson
//
//     return SavedAdvanced(
//       name: json['name'],
//       groups: _groups,
//     );
//   } else {
//     return SavedAdvanced(
//         json['name'] as String,
//     );
//   }
// }
//
  SavedAdvanced.fromMap(Map map)
      : name = map['name'],
        groups = map['groups'].map<SetClass>((tagJson) {
          print('tagJson $tagJson');
          return SetClass.fromMap(tagJson);
        }).toList();
}

class SavedWorkout {
  String? name;
  int? pMin;
  int? pSec;
  int? bMin;
  int? bSec;
  int? setsCount;

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
  Future<List<String>?> read(String str) async {
    //List , Adv
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList(str) == null) {
      return [];
    } else {
      return prefs.getStringList(str);
    }
  }

  Future<int?> readInt(String str) async {
    //deviceModeId,TotalWorkoutSessions,TotalDays
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (str == 'deviceModeId') {
      if (prefs.getInt(str) == null) {
        return 1;
      }
    } else {
      return prefs.getInt(str);
    }
  }

  Future<String?> readString(String str) async {
    //Voice,LastWorkout,TotalWorkoutHours,ReleaseDateOfDatabase
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (str == 'Voice') {
      if (prefs.getString(str) == null) {
        return 'amy';
      } else {
        return prefs.getString(str);
      }
    } else {
      return prefs.getString(str);
    }
  }

  Future<bool?> readBool(String str) async {
    //isVoice
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(str) == null) {
      if (str == 'isDark' || str == 'isContrast')
        return false;
      else
        return true;
    } else {
      return prefs.getBool(str);
    }
  }

  reset(String key, List value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, []);
    // prefs.setString(key, json.encode(value));
  }

  save(String str, List value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(str, value as List<String>);
    // prefs.setString(key, json.encode(value));
  }

  saveInt(String prefName, int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(prefName, val);
  }

  saveString(String prefName, String val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefName, val);
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

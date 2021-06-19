 import 'dart:async';
import 'dart:io';

import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_timer/services/timeValueHandler.dart';

//singleton class
class DbHelper {
  static final _dbName = 'workoutLogs.db';
  static final _version = 1;
  static final _tableName = 'workout';
  static final cId = '_id';
  static final cJiffy = 'jiffy';
  static final cDay = 'day';
  static final cWeek = 'week';
  static final cMonth = 'month';
  static final cYear = 'year';

  static Database? _database;

  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);
    SharedPref sp = SharedPref();
    Jiffy j = Jiffy();
    await sp.saveString('ReleaseDateOfDatabase', j.format());
    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
      $cId INTEGER PRIMARY KEY,
      $cJiffy INTEGER NOT NULL,
      $cDay INTEGER NOT NULL,
      $cWeek INTEGER NOT NULL,
      $cMonth INTEGER NOT NULL,
      $cYear INTEGER NOT NULL
      )''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await (instance.database as FutureOr<Database>);
    List today;
    today = await db.query(_tableName,
        where: '$cDay = ? AND $cWeek = ? AND $cMonth = ? AND $cYear = ?',
        whereArgs: [row[cDay], row[cWeek], row[cMonth], row[cYear]]);
    if (today.isEmpty) {
      return await db.insert(_tableName, row);
    } else {
      row[cJiffy] += today.first[cJiffy];
      return await db.update(_tableName, row,
          where: '$cDay = ? AND $cWeek = ? AND $cMonth = ? AND $cYear = ?',
          whereArgs: [row[cDay], row[cWeek], row[cMonth], row[cYear]]);
    }
  }

  Future<List<List>> queryWeek(int curWeek, int curYear) async {
    Database db = await (instance.database as FutureOr<Database>);
    List<List> result = [];
    List<Map<String, dynamic>> temp;
    Jiffy j, weekName;
    for (int day = 1; day <= 7; day++) {
      temp = await db.query(_tableName,
          columns: [cJiffy],
          where: '$cDay = ? AND $cWeek = ? AND $cYear = ?',
          whereArgs: [day, curWeek, curYear]);
      j = Jiffy('0001-01-01T00:00:00.000');
      if (temp.isNotEmpty) j.add(seconds: temp.first[cJiffy]);
      weekName = Jiffy()
        ..startOf(Units.WEEK)
        ..add(days: day - 1);
      result.add([
        weekName.format('EEEE'),
        temp.isNotEmpty ? temp.first[cJiffy].toDouble() : 0.0,
        '${j.format('H') == '00' ? '' : '${j.format('H').length} Hr '}${j.format('m')} Min',
      ]);
    }
    List<Map<String, dynamic>> total = await db.rawQuery('''
    SELECT Sum($cJiffy) FROM $_tableName WHERE $cWeek = $curWeek AND $cYear = $curYear GROUP BY $cWeek
    ''');
    j = Jiffy('0001-01-01T00:00:00.000');
    if (total.isNotEmpty) {
      j.add(seconds: total.first['Sum($cJiffy)']);
      result.add([
        '${j.format('H') == '00' ? '' : '${j.format('H').length} Hr '}${j.format('m')} Min',
      ]);
    } else {
      result.add([
        '00 Hrs  0 Min',
      ]);
    }
    return result;
  }

  Future<List<List>> queryMonth(int curMonth, int curYear) async {
    Database db = await (instance.database as FutureOr<Database>);
    List<List> result = [];
    List<Map<String, dynamic>> temp, total;
    Jiffy j;
    temp = await db.rawQuery('''
      SELECT $cWeek, Sum($cJiffy) 
      FROM $_tableName 
      WHERE $cMonth = $curMonth AND $cYear = $curYear 
      GROUP BY $cWeek
      ORDER BY $cWeek ASC
    ''');
    Jiffy startJ = Jiffy()..startOf(Units.MONTH);
    Jiffy endJ = Jiffy()..endOf(Units.MONTH);
    int foundIndex = 0;
    for (int i = startJ.week; i <= endJ.week; i++) {
      Iterable<Map<String, dynamic>> e = temp.where((element) {
        return element[cWeek] == i;
      });
      if (e.isNotEmpty) {
        j = Jiffy('0001-01-01T00:00:00.000');
        j.add(seconds: temp[foundIndex]["Sum($cJiffy)"]);
        result.add([
          'Week ${temp[foundIndex][cWeek]}',
          temp[foundIndex]['Sum($cJiffy)'].toDouble(),
          '${j.format('H') == '00' ? '' : '${getHour(j)} Hr '}${j.format('m')} Min',
        ]);
        foundIndex++;
      } else {
        result.add([
          'Week $i',
          0.0,
          '0 Minutes',
        ]);
      }
    }
    total = await db.rawQuery('''
      SELECT Sum($cJiffy)
      FROM $_tableName
      WHERE $cMonth = $curMonth AND $cYear = $curYear
      GROUP BY $cMonth
    ''');

    j = Jiffy('0001-01-01T00:00:00.000');
    if (total.isNotEmpty) {
      j.add(seconds: total.first['Sum($cJiffy)']);
      result.add([
        '${j.format('d') == '1' ? '${j.format('H')} Hr ${j.format('H')} Min' : '${getDay(j)} Days ${j.format('H')} Hr'}',
      ]);
    } else {
      result.add([
        '00 Hrs  0 Min',
      ]);
    }
    return result;
  }

  Future<List<List>> queryYear(int curYear) async {
    Database db = await (instance.database as FutureOr<Database>);
    List<List> result = [];
    List<Map<String, dynamic>> temp, total;
    Jiffy j, monthName;
    temp = await db.rawQuery('''
      SELECT $cMonth, Sum($cJiffy) 
      FROM $_tableName 
      WHERE $cYear = $curYear 
      GROUP BY $cMonth
      ORDER BY $cMonth ASC
    ''');
    int foundIndex = 0;
    for (int month = 1; month <= 12; month++) {
      Iterable<Map<String, dynamic>> e = temp.where((element) {
        return element[cMonth] == month;
      });
      monthName = Jiffy()
        ..startOf(Units.YEAR)
        ..add(months: month - 1);
      if (e.isNotEmpty) {
        j = Jiffy('0001-01-01T00:00:00.000');
        j.add(seconds: temp[foundIndex]["Sum($cJiffy)"]);
        result.add([
          monthName.format('MMMM'),
          temp[foundIndex]["Sum($cJiffy)"].toDouble(),
          '${j.format('d') == '1' ? '${j.format('H')} Hr ${j.format('H')} Min' : '${getDay(j)} Days ${j.format('H')} Hr'}',
        ]);
        foundIndex++;
      } else {
        result.add([
          monthName.format('MMMM'),
          0.0,
          '00 Hr 0 Min',
        ]);
      }
    }
    total = await db.rawQuery('''
      SELECT Sum($cJiffy)
      FROM $_tableName
      WHERE $cYear = $curYear
      GROUP BY $cYear
    ''');

    j = Jiffy('0001-01-01T00:00:00.000');
    if (total.isNotEmpty) {
      j.add(seconds: total.first['Sum($cJiffy)']);
      result.add([
        '${j.format('d') == '1' ? '${j.format('H')} Hr ${j.format('H')} Min' : '${getDay(j)} Days ${j.format('H')} Hr'}',
      ]);
    } else {
      result.add([
        '00 Hrs  0 Min',
      ]);
    }

    return result;
  }

  int getDay(Jiffy j) {
    Jiffy zeroDate = Jiffy({
      "year": 1,
      "month": 1,
      "day": 1,
      "hour": j.hour,
      "minute": j.minute,
      "second": j.second,
      "millisecond": j.millisecond,
    });
    return j.diff(zeroDate, Units.DAY) as int;
  }

  int getHour(Jiffy j) {
    Jiffy zeroDate = Jiffy({
      "year": 1,
      "month": 1,
      "day": 1,
      "hour": 0,
      "minute": j.minute,
      "second": j.second,
      "millisecond": j.millisecond,
    });
    return j.diff(zeroDate, Units.HOUR) as int;
  }
}

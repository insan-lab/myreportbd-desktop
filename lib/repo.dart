import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';

class UserRow {
  final int id;
  final String name;
  const UserRow(this.id, this.name);
}

class Repo {
  static Future<List<UserRow>> listUsers() async {
    final db = await AppDb.instance.db;
    final rows = await db.query('users', orderBy: 'name');
    return rows.map((r) => UserRow(r['id'] as int, r['name'] as String)).toList();
  }

  static Future<int> createUser(String name, {String? mobile, String? branch, String? responsibility}) async {
    final db = await AppDb.instance.db;
    return db.insert('users', {
      'name': name,
      'mobile_number': mobile,
      'branch': branch,
      'responsibility': responsibility,
    });
  }

  static Future<void> deleteUser(int id) async {
    final db = await AppDb.instance.db;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  /// report_data: one upsert per column for a given user/date.
  static Future<void> saveDailyValue(int userId, int columnId, String date, String value) async {
    final db = await AppDb.instance.db;
    if (value.trim().isEmpty) {
      await db.delete(
        'report_data',
        where: 'user_id = ? AND column_id = ? AND date = ?',
        whereArgs: [userId, columnId, date],
      );
      return;
    }
    await db.insert(
      'report_data',
      {'user_id': userId, 'column_id': columnId, 'date': date, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<int, String>> dailyValuesFor(int userId, String date) async {
    final db = await AppDb.instance.db;
    final rows = await db.query(
      'report_data',
      where: 'user_id = ? AND date = ?',
      whereArgs: [userId, date],
    );
    return {for (final r in rows) r['column_id'] as int: (r['value'] ?? '').toString()};
  }

  static Future<List<Map<String, Object?>>> reportColumnTreeRows() async {
    final db = await AppDb.instance.db;
    return db.query('report_columns', orderBy: 'id');
  }

  /// Manual monthly_reports fields.
  static Future<Map<String, Object?>?> monthlyReportManual(int userId, String month) async {
    final db = await AppDb.instance.db;
    final rows = await db.query(
      'monthly_reports',
      where: 'user_id = ? AND month = ?',
      whereArgs: [userId, month],
    );
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> saveMonthlyReportManual(int userId, String month, Map<String, Object?> values) async {
    final db = await AppDb.instance.db;
    final existing = await monthlyReportManual(userId, month);
    final data = {...values, 'user_id': userId, 'month': month};
    if (existing == null) {
      await db.insert('monthly_reports', data);
    } else {
      await db.update('monthly_reports', data, where: 'id = ?', whereArgs: [existing['id']]);
    }
  }

  /// Generic plan entry CRUD, shared by monthly_plans and yearly_plans.
  static Future<List<Map<String, Object?>>> listPlanEntries(String table, int userId) async {
    final db = await AppDb.instance.db;
    return db.query(table, where: 'user_id = ?', whereArgs: [userId], orderBy: 'id DESC');
  }

  static Future<Map<String, Object?>?> getPlanEntry(String table, int id) async {
    final db = await AppDb.instance.db;
    final rows = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : rows.first;
  }

  static Future<void> deletePlanEntry(String table, int id) async {
    final db = await AppDb.instance.db;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> savePlanEntry(String table, int? id, Map<String, Object?> values) async {
    final db = await AppDb.instance.db;
    if (id == null) {
      return db.insert(table, values);
    }
    await db.update(table, values, where: 'id = ?', whereArgs: [id]);
    return id;
  }
}

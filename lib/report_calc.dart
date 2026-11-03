import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';
import 'utils.dart';

/// Reimplements ReportController::get_monthly_report()'s aggregation:
/// for each tracked column, sum(value) and count(value > 0) for the month;
/// averages are sum/count (0 when count is 0), matching the PHP exactly.
class MonthlyAggregates {
  final Map<String, num> sums;
  final Map<String, int> counts;
  MonthlyAggregates(this.sums, this.counts);

  num sum(String path) => sums[path] ?? 0;
  int count(String path) => counts[path] ?? 0;
  double avg(String path) => count(path) > 0 ? sum(path) / count(path) : 0;
}

String secToHour(num seconds) {
  final total = seconds.round();
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  return '$h:${m.toString().padLeft(2, '0')}';
}

class ReportCalc {
  /// Loads column ids by "parent.child" or "leaf" path, keyed once per call
  /// (the tree is tiny — 13 categories, <40 columns).
  static Future<Map<String, int>> _columnIdsByPath(Database db) async {
    final rows = await db.query('report_columns');
    final byId = {for (final r in rows) r['id'] as int: r};
    final result = <String, int>{};
    for (final r in rows) {
      final parent = r['parent'] as int;
      final en = r['en_name'] as String;
      if (parent == 0) {
        result[en] = r['id'] as int;
      } else {
        final parentEn = byId[parent]!['en_name'] as String;
        result['$parentEn.$en'] = r['id'] as int;
      }
    }
    return result;
  }

  static Future<MonthlyAggregates> compute(int userId, String month) async {
    final db = await AppDb.instance.db;
    final colIds = await _columnIdsByPath(db);
    final sums = <String, num>{};
    final counts = <String, int>{};

    for (final entry in colIds.entries) {
      final rows = await db.query(
        'report_data',
        columns: ['value'],
        where: 'user_id = ? AND column_id = ? AND date LIKE ?',
        whereArgs: [userId, entry.value, '$month%'],
      );
      num sum = 0;
      int count = 0;
      for (final r in rows) {
        final v = parseLocaleNum((r['value'] ?? '').toString()) ?? 0;
        sum += v;
        if (v > 0) count++;
      }
      sums[entry.key] = sum;
      counts[entry.key] = count;
    }
    return MonthlyAggregates(sums, counts);
  }

  /// The ~41 live-computed monthly_reports fields, exactly as
  /// ReportController::get_monthly_report() builds $modified_report.
  /// contact_vip / contact_teacher are always 0: the live app references
  /// contact2.vip / contact2.shikkhok, columns that were never actually
  /// seeded (a pre-existing bug in the Laravel app), so there's nothing to sum.
  static Map<String, String> fields(MonthlyAggregates a) {
    return {
      'quran_days': a.count('quran.ayat').toString(),
      'quran_ayat': a.sum('quran.memorise').toString(),
      'quran_avg_ayat': a.avg('quran.ayat').toStringAsFixed(2),
      'hadith_days': a.count('hadith.quantity').toString(),
      'hadith_memorize': a.sum('hadith.memorise').toString(),
      'hadith_avg': a.avg('hadith.quantity').toStringAsFixed(2),
      'literature_pages': (a.sum('literature.islamic') + a.sum('literature.book') + a.sum('literature.others')).toString(),
      'literature_islamic': a.sum('literature.islamic').toString(),
      'literature_others': a.sum('literature.others').toString(),
      'literature_book_note': a.sum('literature.book_note').toString(),
      'literature_book': a.sum('literature.book').toString(),
      'literature_discussion': a.sum('literature.alocona_note').toString(),
      'general_book_days': a.count('reading_time').toString(),
      'general_book_total_hours': secToHour(a.sum('reading_time')),
      'general_book_avg': a.count('reading_time') > 0 ? secToHour(a.sum('reading_time') / a.count('reading_time')) : '0',
      'class_attendance': a.sum('class.class_present').toString(),
      'attendance_total_days': a.count('class.class_present').toString(),
      'jamayat_namaz': a.sum('salat.jamat').toString(),
      'salat_kaja': a.sum('salat.kaja').toString(),
      'dawat_days': a.count('sangothonik_dayitto_palon.dawati_kaj').toString(),
      'dawat_total_hours': secToHour(a.sum('sangothonik_dayitto_palon.dawati_kaj')),
      'org_work_days': a.count('sangothonik_dayitto_palon.sangothonik_kaj').toString(),
      'org_work_avg_hours': a.count('sangothonik_dayitto_palon.sangothonik_kaj') > 0
          ? secToHour(a.sum('sangothonik_dayitto_palon.sangothonik_kaj') / a.count('sangothonik_dayitto_palon.sangothonik_kaj'))
          : '0',
      'contact_member': a.sum('contact1.sodossho').toString(),
      'contact_supporter': a.sum('contact1.somorthok').toString(),
      'school_student': a.sum('contact2.medhabi_chatro').toString(),
      'contact_vip': '0',
      'contact_associate': a.sum('contact1.sathi').toString(),
      'contact_friend': a.sum('contact2.bondhu').toString(),
      'contact_talent': a.sum('contact2.medhabi_chatro').toString(),
      'contact_worker': a.sum('contact1.kormi').toString(),
      'contact_wellwisher': a.sum('contact2.suvakankhi').toString(),
      'contact_teacher': '0',
      'distribution_islamic_literature': a.sum('bitoron.sahitto').toString(),
      'distribution_kishor_paper': a.sum('bitoron.megazine').toString(),
      'sticker_card': a.sum('bitoron.stikar_card').toString(),
      'gift_sms_email': a.sum('bitoron.upohar').toString(),
      'self_criticism': a.count('atto_somalocona').toString(),
      'muharama_contact': a.count('contact2.muharramah').toString(),
      'physical_exercise': a.count('exercise').toString(),
      'manifold_newspaper': a.count('newspaper').toString(),
    };
  }
}

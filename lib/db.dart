import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// report_columns category tree, exactly as seeded by the Laravel app's
/// ReportColumnSeeder (database/seeders/ReportColumnSeeder.php). `hidden`
/// children are kept (so sums stay correct if ever written) but excluded
/// from the daily-entry UI, matching that seeder's $hidden_cols.
const List<Map<String, dynamic>> reportColumnTree = [
  {
    'en': 'quran',
    'bn': 'কুরআন অধ্যয়ন',
    'children': [
      {'en': 'surah', 'bn': 'সূরা'},
      {'en': 'ayat', 'bn': 'আয়াত'},
      {'en': 'dars', 'bn': 'দারস', 'hidden': true},
      {'en': 'memorise', 'bn': 'মুখস্ত : আয়াত'},
      {'en': 'surah_with_meaning', 'bn': 'অর্থসহ সূরা', 'hidden': true},
    ],
  },
  {
    'en': 'hadith',
    'bn': 'হাদিস অধ্যয়ন',
    'children': [
      {'en': 'grontho', 'bn': 'গ্রন্থ', 'hidden': true},
      {'en': 'bisoy', 'bn': 'বিষয়', 'hidden': true},
      {'en': 'dars', 'bn': 'দারস', 'hidden': true},
      {'en': 'quantity', 'bn': 'সংখ্যা'},
      {'en': 'memorise', 'bn': 'মুখস্ত'},
    ],
  },
  {
    'en': 'literature',
    'bn': 'সাহিত্য অধ্যয়ন',
    'children': [
      {'en': 'book', 'bn': 'বই'},
      {'en': 'islamic', 'bn': 'ইসলামী'},
      {'en': 'others', 'bn': 'অন্যান্য'},
      {'en': 'book_note', 'bn': 'বই নোট', 'hidden': true},
      {'en': 'alocona_note', 'bn': 'আলোচনা নোট', 'hidden': true},
    ],
  },
  {
    'en': 'reading_time',
    'bn': 'পাঠ্যপুস্তক অধ্যয়ন',
    'type': 'time',
    'children': <Map<String, dynamic>>[],
  },
  {
    'en': 'class',
    'bn': 'ক্লাস',
    'children': [
      {'en': 'class_no', 'bn': 'সংখ্যা'},
      {'en': 'class_present', 'bn': 'উপস্থিতি'},
    ],
  },
  {
    'en': 'salat',
    'bn': 'নামাজ',
    'children': [
      {'en': 'jamat', 'bn': 'জামাত'},
      {'en': 'kaja', 'bn': 'কাজা'},
      {'en': 'kaja_howar_karon', 'bn': 'কাজা হওয়ার কারণ', 'hidden': true, 'type': 'text'},
    ],
  },
  {
    'en': 'contact1',
    'bn': 'যোগাযোগ ১',
    'children': [
      {'en': 'sodossho', 'bn': 'সদস্য'},
      {'en': 'sathi', 'bn': 'সাথী'},
      {'en': 'kormi', 'bn': 'কর্মী'},
      {'en': 'somorthok', 'bn': 'সমর্থক'},
    ],
  },
  {
    'en': 'contact2',
    'bn': 'যোগাযোগ ২',
    'children': [
      {'en': 'bondhu', 'bn': 'বন্ধু'},
      {'en': 'medhabi_chatro', 'bn': 'মেধাবী ছাত্র'},
      {'en': 'suvakankhi', 'bn': 'শুভাকাংখী'},
      {'en': 'muharramah', 'bn': 'মুহাররমা'},
    ],
  },
  {
    'en': 'bitoron',
    'bn': 'বিতরণ',
    'children': [
      {'en': 'sahitto', 'bn': 'সাহিত্য'},
      {'en': 'megazine', 'bn': 'ম্যাগাজিন'},
      {'en': 'stikar_card', 'bn': 'স্টিকার/কার্ড'},
      {'en': 'upohar', 'bn': 'উপহার'},
    ],
  },
  {
    'en': 'sangothonik_dayitto_palon',
    'bn': 'সাংগঠনিক দায়িত্ব পালন',
    'type': 'time',
    'children': [
      {'en': 'dawati_kaj', 'bn': 'দাওয়াতী কাজ', 'type': 'time'},
      {'en': 'sangothonik_kaj', 'bn': 'অন্যান্য সাংগঠনিক কাজ', 'type': 'time'},
    ],
  },
  {'en': 'newspaper', 'bn': 'পত্র পত্রিকা', 'type': 'boolean', 'children': <Map<String, dynamic>>[]},
  {'en': 'exercise', 'bn': 'শরীর চর্চা', 'type': 'boolean', 'children': <Map<String, dynamic>>[]},
  {'en': 'atto_somalocona', 'bn': 'আত্ন সমালোচনা', 'type': 'boolean', 'children': <Map<String, dynamic>>[]},
];

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = join(await databaseFactory.getDatabasesPath(), 'myreportbd.db');
    _db = await databaseFactory.openDatabase(path);
    await _migrate(_db!);
    await _seedReportColumns(_db!);
    return _db!;
  }

  Future<void> _migrate(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        mobile_number TEXT,
        branch TEXT,
        responsibility TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS report_columns (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent INTEGER NOT NULL DEFAULT 0,
        en_name TEXT NOT NULL,
        bn_name TEXT NOT NULL,
        visibility INTEGER NOT NULL DEFAULT 1,
        value_type TEXT NOT NULL DEFAULT 'number'
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS report_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        column_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        value TEXT,
        UNIQUE(user_id, column_id, date)
      )
    ''');

    // Only the manual fields of monthly_reports are stored; the ~41
    // aggregated fields are computed live from report_data, same as Laravel.
    await db.execute('''
      CREATE TABLE IF NOT EXISTS monthly_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        month TEXT NOT NULL,
        surah_name TEXT, quran_darz INTEGER, surah_meaning INTEGER,
        hadith_topics TEXT, hadith_darz INTEGER, hadith_subjects TEXT,
        literature_book_name TEXT,
        nafal_namaz TEXT, dawat_person INTEGER,
        distribution_chhatrasangbad INTEGER, class_routine INTEGER,
        distribution_perspective INTEGER, distribution_english_paper INTEGER,
        distribution_porichiti INTEGER,
        increase_member1 INTEGER, increase_member2 TEXT,
        activist1 INTEGER, activist2 TEXT,
        member_elect1 INTEGER, member_elect2 TEXT,
        supporter1 INTEGER, supporter2 TEXT,
        increase_sathi1 INTEGER, increase_sathi2 TEXT,
        increase_friend1 INTEGER, increase_friend2 TEXT,
        sathi_elect1 INTEGER, sathi_elect2 TEXT,
        card_wisher1 INTEGER, card_wisher2 TEXT,
        bm_given_date TEXT,
        personal_increase INTEGER, student_welfare INTEGER, kolsi_hari INTEGER,
        baitulmal_total INTEGER, table_bank REAL, baitulmal_others INTEGER,
        dawat_email INTEGER, computer_learning INTEGER, language_learning INTEGER,
        group_dawat INTEGER, nonmuslim_contact INTEGER, dawat_sms INTEGER,
        contact_organization INTEGER,
        manifold_others TEXT, opinion TEXT, report_checking TEXT,
        UNIQUE(user_id, month)
      )
    ''');

    // monthly_plans / yearly_plans: plain manual forms, unrelated to daily
    // tracking. Same ~85-field shape as the original web schema.
    const planFieldsSql = '''
      quran_days REAL, surah_name TEXT, quran_ayat REAL, quran_avg_ayat REAL, quran_darz REAL, surah_meaning REAL,
      hadith_days REAL, hadith_topics TEXT, hadith_memorize TEXT, hadith_avg REAL, hadith_darz REAL, hadith_subjects TEXT,
      literature_pages REAL, literature_islamic REAL, literature_others REAL, literature_book_name TEXT, literature_book_note TEXT, literature_book TEXT, literature_discussion TEXT, general_book_days REAL,
      class_attendance REAL, attendance_total_days REAL, jamayat_namaz TEXT, nafal_namaz TEXT,
      dawat_days REAL, dawat_total_hours REAL, dawat_person REAL,
      org_work_days REAL, org_work_avg_hours REAL,
      contact_member REAL, contact_supporter REAL, school_student REAL, contact_vip REAL, contact_associate REAL, contact_friend REAL, contact_talent REAL, contact_worker REAL, contact_wellwisher REAL, contact_teacher REAL,
      distribution_islamic_literature REAL, distribution_chhatrasangbad REAL, class_routine REAL, distribution_kishor_paper REAL, distribution_perspective REAL, sticker_card REAL, distribution_english_paper REAL, distribution_porichiti REAL, gift_sms_email REAL,
      increase_member1 REAL, increase_member2 TEXT, activist1 REAL, activist2 TEXT, member_elect1 REAL, member_elect2 TEXT, supporter1 REAL, supporter2 TEXT, increase_sathi1 REAL, increase_sathi2 TEXT, increase_friend1 REAL, increase_friend2 TEXT, sathi_elect1 REAL, sathi_elect2 TEXT, card_wisher1 REAL, card_wisher2 TEXT, bm_given_date TEXT, personal_increase REAL,
      student_welfare REAL, kolsi_hari REAL, baitulmal_total REAL, table_bank REAL, baitulmal_others REAL,
      self_criticism REAL, muharama_contact REAL, dawat_email REAL, computer_learning REAL, language_learning REAL, physical_exercise REAL, group_dawat REAL, nonmuslim_contact REAL, manifold_newspaper REAL, dawat_sms REAL, contact_organization REAL, manifold_others TEXT,
      opinion TEXT, report_checking TEXT
    ''';
    await db.execute('''
      CREATE TABLE IF NOT EXISTS monthly_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL, month TEXT NOT NULL,
        $planFieldsSql, report_checking_date TEXT,
        UNIQUE(user_id, month)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS yearly_plans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL, year TEXT NOT NULL,
        $planFieldsSql,
        UNIQUE(user_id, year)
      )
    ''');
  }

  Future<void> _seedReportColumns(Database db) async {
    final rows = await db.rawQuery('SELECT COUNT(*) AS c FROM report_columns');
    final count = rows.first['c'] as int;
    if (count > 0) return;

    for (final top in reportColumnTree) {
      final parentId = await db.insert('report_columns', {
        'parent': 0,
        'en_name': top['en'],
        'bn_name': top['bn'],
        'visibility': 1,
        'value_type': top['type'] ?? 'number',
      });
      for (final child in (top['children'] as List<Map<String, dynamic>>)) {
        await db.insert('report_columns', {
          'parent': parentId,
          'en_name': child['en'],
          'bn_name': child['bn'],
          'visibility': (child['hidden'] == true) ? 0 : 1,
          'value_type': child['type'] ?? 'number',
        });
      }
    }
  }
}

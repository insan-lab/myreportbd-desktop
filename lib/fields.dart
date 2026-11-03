/// Field metadata for the manual forms. Labels are Bangla, matching the
/// Daily Entry screen's bn_name labels (which come straight from the
/// Laravel seeder); these ones are hand-translated since the web app's
/// monthly_reports/monthly_plans/yearly_plans schema has no bn_name source.
enum FieldType { number, text, date }

class FieldDef {
  final String key;
  final String label;
  final FieldType type;
  const FieldDef(this.key, this.label, [this.type = FieldType.number]);
}

/// Manual (directly-entered) fields of monthly_reports, grouped by section.
const Map<String, List<FieldDef>> monthlyReportManualSections = {
  'কুরআন ও হাদিস': [
    FieldDef('surah_name', 'সূরার নাম', FieldType.text),
    FieldDef('quran_darz', 'কুরআন দারস'),
    FieldDef('surah_meaning', 'অর্থসহ সূরা'),
    FieldDef('hadith_topics', 'হাদিসের বিষয়', FieldType.text),
    FieldDef('hadith_darz', 'হাদিস দারস'),
    FieldDef('hadith_subjects', 'হাদিসের গ্রন্থ', FieldType.text),
  ],
  'অধ্যয়ন': [
    FieldDef('literature_book_name', 'বইয়ের নাম', FieldType.text),
    FieldDef('nafal_namaz', 'নফল নামাজ', FieldType.text),
  ],
  'দাওয়াত ও সাংগঠনিক কাজ': [
    FieldDef('dawat_person', 'দাওয়াতপ্রাপ্ত ব্যক্তি'),
    FieldDef('group_dawat', 'গ্রুপ দাওয়াত'),
    FieldDef('dawat_sms', 'দাওয়াতী এসএমএস'),
    FieldDef('dawat_email', 'দাওয়াতী ইমেইল'),
    FieldDef('nonmuslim_contact', 'অমুসলিম যোগাযোগ'),
    FieldDef('contact_organization', 'প্রাতিষ্ঠানিক যোগাযোগ'),
    FieldDef('computer_learning', 'কম্পিউটার শিক্ষা'),
    FieldDef('language_learning', 'ভাষা শিক্ষা'),
    FieldDef('class_routine', 'ক্লাস রুটিন'),
  ],
  'বিতরণ': [
    FieldDef('distribution_chhatrasangbad', 'ছাত্রসংবাদ'),
    FieldDef('distribution_perspective', 'পার্সপেক্টিভ'),
    FieldDef('distribution_english_paper', 'ইংরেজি পত্রিকা'),
    FieldDef('distribution_porichiti', 'পরিচিতি'),
    FieldDef('manifold_others', 'অন্যান্য বিতরণ', FieldType.text),
  ],
  'প্রবৃদ্ধি ও নির্বাচন': [
    FieldDef('increase_member1', 'নতুন সদস্য (সংখ্যা)'),
    FieldDef('increase_member2', 'নতুন সদস্য (নাম)', FieldType.text),
    FieldDef('activist1', 'সক্রিয় কর্মী (সংখ্যা)'),
    FieldDef('activist2', 'সক্রিয় কর্মী (নাম)', FieldType.text),
    FieldDef('member_elect1', 'সদস্য নির্বাচন (সংখ্যা)'),
    FieldDef('member_elect2', 'সদস্য নির্বাচন (নাম)', FieldType.text),
    FieldDef('supporter1', 'সমর্থক (সংখ্যা)'),
    FieldDef('supporter2', 'সমর্থক (নাম)', FieldType.text),
    FieldDef('increase_sathi1', 'নতুন সাথী (সংখ্যা)'),
    FieldDef('increase_sathi2', 'নতুন সাথী (নাম)', FieldType.text),
    FieldDef('increase_friend1', 'নতুন বন্ধু (সংখ্যা)'),
    FieldDef('increase_friend2', 'নতুন বন্ধু (নাম)', FieldType.text),
    FieldDef('sathi_elect1', 'সাথী নির্বাচন (সংখ্যা)'),
    FieldDef('sathi_elect2', 'সাথী নির্বাচন (নাম)', FieldType.text),
    FieldDef('card_wisher1', 'কার্ড শুভেচ্ছাদাতা (সংখ্যা)'),
    FieldDef('card_wisher2', 'কার্ড শুভেচ্ছাদাতা (নাম)', FieldType.text),
    FieldDef('bm_given_date', 'বিএম প্রদানের তারিখ', FieldType.text),
    FieldDef('personal_increase', 'ব্যক্তিগত অগ্রগতি'),
  ],
  'কল্যাণ ও অর্থ': [
    FieldDef('student_welfare', 'ছাত্র কল্যাণ'),
    FieldDef('kolsi_hari', 'কলসি হাঁড়ি'),
    FieldDef('baitulmal_total', 'বায়তুলমাল মোট'),
    FieldDef('table_bank', 'টেবিল ব্যাংক'),
    FieldDef('baitulmal_others', 'বায়তুলমাল অন্যান্য'),
  ],
  'পর্যালোচনা': [
    FieldDef('opinion', 'মতামত', FieldType.text),
    FieldDef('report_checking', 'রিপোর্ট যাচাই', FieldType.text),
  ],
};

/// The live-computed fields, for read-only display, grouped to mirror the
/// manual sections above so both halves of a category sit together.
const Map<String, List<FieldDef>> monthlyReportComputedSections = {
  'কুরআন ও হাদিস': [
    FieldDef('quran_days', 'কুরআন দিন'),
    FieldDef('quran_ayat', 'মুখস্ত আয়াত'),
    FieldDef('quran_avg_ayat', 'দৈনিক গড় আয়াত'),
    FieldDef('hadith_days', 'হাদিস দিন'),
    FieldDef('hadith_memorize', 'মুখস্ত হাদিস'),
    FieldDef('hadith_avg', 'দৈনিক গড় হাদিস'),
  ],
  'অধ্যয়ন': [
    FieldDef('literature_pages', 'সাহিত্য মোট'),
    FieldDef('literature_islamic', 'ইসলামী সাহিত্য'),
    FieldDef('literature_others', 'অন্যান্য সাহিত্য'),
    FieldDef('literature_book_note', 'বই নোট'),
    FieldDef('literature_book', 'বই'),
    FieldDef('literature_discussion', 'আলোচনা নোট'),
    FieldDef('general_book_days', 'পাঠ্যপুস্তক দিন'),
    FieldDef('general_book_total_hours', 'মোট পাঠ সময়'),
    FieldDef('general_book_avg', 'দৈনিক গড় পাঠ সময়'),
    FieldDef('class_attendance', 'ক্লাস উপস্থিতি'),
    FieldDef('attendance_total_days', 'উপস্থিতি মোট দিন'),
  ],
  'নামাজ': [
    FieldDef('jamayat_namaz', 'জামাত নামাজ'),
    FieldDef('salat_kaja', 'কাজা নামাজ'),
  ],
  'দাওয়াত ও সাংগঠনিক কাজ': [
    FieldDef('dawat_days', 'দাওয়াতী দিন'),
    FieldDef('dawat_total_hours', 'দাওয়াতী মোট সময়'),
    FieldDef('org_work_days', 'সাংগঠনিক কাজের দিন'),
    FieldDef('org_work_avg_hours', 'দৈনিক গড় সাংগঠনিক সময়'),
    FieldDef('self_criticism', 'আত্ন সমালোচনা দিন'),
    FieldDef('physical_exercise', 'শরীর চর্চা দিন'),
    FieldDef('manifold_newspaper', 'পত্র পত্রিকা দিন'),
  ],
  'যোগাযোগ': [
    FieldDef('contact_member', 'সদস্য'),
    FieldDef('contact_supporter', 'সমর্থক'),
    FieldDef('school_student', 'মেধাবী ছাত্র'),
    FieldDef('contact_vip', 'ভিআইপি'),
    FieldDef('contact_associate', 'সাথী'),
    FieldDef('contact_friend', 'বন্ধু'),
    FieldDef('contact_talent', 'মেধাবী (প্রতিভাবান)'),
    FieldDef('contact_worker', 'কর্মী'),
    FieldDef('contact_wellwisher', 'শুভাকাংখী'),
    FieldDef('contact_teacher', 'শিক্ষক'),
    FieldDef('muharama_contact', 'মুহাররমা যোগাযোগ'),
  ],
  'বিতরণ': [
    FieldDef('distribution_islamic_literature', 'ইসলামী সাহিত্য বিতরণ'),
    FieldDef('distribution_kishor_paper', 'কিশোর পত্রিকা বিতরণ'),
    FieldDef('sticker_card', 'স্টিকার/কার্ড'),
    FieldDef('gift_sms_email', 'উপহার/এসএমএস/ইমেইল'),
  ],
};

/// monthly_plans / yearly_plans share the same fixed field set, grouped for
/// this app's own forms.
const Map<String, List<FieldDef>> planSections = {
  'কুরআন': [
    FieldDef('quran_days', 'কুরআন দিন'),
    FieldDef('surah_name', 'সূরার নাম', FieldType.text),
    FieldDef('quran_ayat', 'আয়াত'),
    FieldDef('quran_avg_ayat', 'দৈনিক গড় আয়াত'),
    FieldDef('quran_darz', 'কুরআন দারস'),
    FieldDef('surah_meaning', 'অর্থসহ সূরা'),
  ],
  'হাদিস': [
    FieldDef('hadith_days', 'হাদিস দিন'),
    FieldDef('hadith_topics', 'হাদিসের বিষয়', FieldType.text),
    FieldDef('hadith_memorize', 'মুখস্ত হাদিস', FieldType.text),
    FieldDef('hadith_avg', 'দৈনিক গড় হাদিস'),
    FieldDef('hadith_darz', 'হাদিস দারস'),
    FieldDef('hadith_subjects', 'হাদিসের গ্রন্থ', FieldType.text),
  ],
  'সাহিত্য ও অধ্যয়ন': [
    FieldDef('literature_pages', 'সাহিত্য পৃষ্ঠা'),
    FieldDef('literature_islamic', 'ইসলামী সাহিত্য'),
    FieldDef('literature_others', 'অন্যান্য সাহিত্য'),
    FieldDef('literature_book_name', 'বইয়ের নাম', FieldType.text),
    FieldDef('literature_book_note', 'বই নোট', FieldType.text),
    FieldDef('literature_book', 'বই', FieldType.text),
    FieldDef('literature_discussion', 'আলোচনা নোট', FieldType.text),
    FieldDef('general_book_days', 'পাঠ্যপুস্তক দিন'),
  ],
  'নামাজ ও উপস্থিতি': [
    FieldDef('class_attendance', 'ক্লাস উপস্থিতি'),
    FieldDef('attendance_total_days', 'উপস্থিতি মোট দিন'),
    FieldDef('jamayat_namaz', 'জামাত নামাজ', FieldType.text),
    FieldDef('nafal_namaz', 'নফল নামাজ', FieldType.text),
  ],
  'দাওয়াত': [
    FieldDef('dawat_days', 'দাওয়াতী দিন'),
    FieldDef('dawat_total_hours', 'দাওয়াতী মোট সময়'),
    FieldDef('dawat_person', 'দাওয়াতপ্রাপ্ত ব্যক্তি'),
    FieldDef('dawat_email', 'দাওয়াতী ইমেইল'),
    FieldDef('dawat_sms', 'দাওয়াতী এসএমএস'),
    FieldDef('group_dawat', 'গ্রুপ দাওয়াত'),
    FieldDef('nonmuslim_contact', 'অমুসলিম যোগাযোগ'),
    FieldDef('muharama_contact', 'মুহাররমা যোগাযোগ'),
  ],
  'সাংগঠনিক কাজ': [
    FieldDef('org_work_days', 'সাংগঠনিক কাজের দিন'),
    FieldDef('org_work_avg_hours', 'দৈনিক গড় সাংগঠনিক সময়'),
    FieldDef('contact_organization', 'প্রাতিষ্ঠানিক যোগাযোগ'),
    FieldDef('class_routine', 'ক্লাস রুটিন'),
    FieldDef('self_criticism', 'আত্ন সমালোচনা'),
    FieldDef('computer_learning', 'কম্পিউটার শিক্ষা'),
    FieldDef('language_learning', 'ভাষা শিক্ষা'),
    FieldDef('physical_exercise', 'শরীর চর্চা'),
  ],
  'যোগাযোগ': [
    FieldDef('contact_member', 'সদস্য'),
    FieldDef('contact_supporter', 'সমর্থক'),
    FieldDef('school_student', 'মেধাবী ছাত্র'),
    FieldDef('contact_vip', 'ভিআইপি'),
    FieldDef('contact_associate', 'সাথী'),
    FieldDef('contact_friend', 'বন্ধু'),
    FieldDef('contact_talent', 'মেধাবী (প্রতিভাবান)'),
    FieldDef('contact_worker', 'কর্মী'),
    FieldDef('contact_wellwisher', 'শুভাকাংখী'),
    FieldDef('contact_teacher', 'শিক্ষক'),
  ],
  'বিতরণ ও মিডিয়া': [
    FieldDef('distribution_islamic_literature', 'ইসলামী সাহিত্য বিতরণ'),
    FieldDef('distribution_chhatrasangbad', 'ছাত্রসংবাদ'),
    FieldDef('distribution_kishor_paper', 'কিশোর পত্রিকা'),
    FieldDef('distribution_perspective', 'পার্সপেক্টিভ'),
    FieldDef('sticker_card', 'স্টিকার/কার্ড'),
    FieldDef('distribution_english_paper', 'ইংরেজি পত্রিকা'),
    FieldDef('distribution_porichiti', 'পরিচিতি'),
    FieldDef('gift_sms_email', 'উপহার/এসএমএস/ইমেইল'),
    FieldDef('manifold_newspaper', 'পত্র পত্রিকা'),
    FieldDef('manifold_others', 'অন্যান্য বিতরণ', FieldType.text),
  ],
  'প্রবৃদ্ধি ও নির্বাচন': [
    FieldDef('increase_member1', 'নতুন সদস্য (সংখ্যা)'),
    FieldDef('increase_member2', 'নতুন সদস্য (নাম)', FieldType.text),
    FieldDef('activist1', 'সক্রিয় কর্মী (সংখ্যা)'),
    FieldDef('activist2', 'সক্রিয় কর্মী (নাম)', FieldType.text),
    FieldDef('member_elect1', 'সদস্য নির্বাচন (সংখ্যা)'),
    FieldDef('member_elect2', 'সদস্য নির্বাচন (নাম)', FieldType.text),
    FieldDef('supporter1', 'সমর্থক (সংখ্যা)'),
    FieldDef('supporter2', 'সমর্থক (নাম)', FieldType.text),
    FieldDef('increase_sathi1', 'নতুন সাথী (সংখ্যা)'),
    FieldDef('increase_sathi2', 'নতুন সাথী (নাম)', FieldType.text),
    FieldDef('increase_friend1', 'নতুন বন্ধু (সংখ্যা)'),
    FieldDef('increase_friend2', 'নতুন বন্ধু (নাম)', FieldType.text),
    FieldDef('sathi_elect1', 'সাথী নির্বাচন (সংখ্যা)'),
    FieldDef('sathi_elect2', 'সাথী নির্বাচন (নাম)', FieldType.text),
    FieldDef('card_wisher1', 'কার্ড শুভেচ্ছাদাতা (সংখ্যা)'),
    FieldDef('card_wisher2', 'কার্ড শুভেচ্ছাদাতা (নাম)', FieldType.text),
    FieldDef('bm_given_date', 'বিএম প্রদানের তারিখ', FieldType.text),
    FieldDef('personal_increase', 'ব্যক্তিগত অগ্রগতি'),
  ],
  'কল্যাণ ও অর্থ': [
    FieldDef('student_welfare', 'ছাত্র কল্যাণ'),
    FieldDef('kolsi_hari', 'কলসি হাঁড়ি'),
    FieldDef('baitulmal_total', 'বায়তুলমাল মোট'),
    FieldDef('table_bank', 'টেবিল ব্যাংক'),
    FieldDef('baitulmal_others', 'বায়তুলমাল অন্যান্য'),
  ],
  'পর্যালোচনা': [
    FieldDef('opinion', 'মতামত', FieldType.text),
    FieldDef('report_checking', 'রিপোর্ট যাচাই', FieldType.text),
  ],
};

/// yearly_plans has no report_checking_date column; monthly_plans does.
const FieldDef reportCheckingDateField = FieldDef('report_checking_date', 'রিপোর্ট যাচাইয়ের তারিখ', FieldType.date);
const String reportCheckingDateSection = 'রিপোর্ট যাচাইয়ের তারিখ';

/// Field key -> type, flattened from planSections, for display-time lookups.
final Map<String, FieldType> planFieldTypes = {
  for (final section in planSections.values)
    for (final f in section) f.key: f.type,
  reportCheckingDateField.key: reportCheckingDateField.type,
};

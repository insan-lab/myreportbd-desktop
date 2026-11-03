import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fields.dart';
import '../report_calc.dart';
import '../repo.dart';
import '../utils.dart';

const Map<String, IconData> _sectionIcons = {
  'কুরআন ও হাদিস': Icons.menu_book_rounded,
  'অধ্যয়ন': Icons.local_library_rounded,
  'নামাজ': Icons.mosque_rounded,
  'দাওয়াত ও সাংগঠনিক কাজ': Icons.volunteer_activism_rounded,
  'যোগাযোগ': Icons.diversity_3_rounded,
  'বিতরণ': Icons.card_giftcard_rounded,
  'প্রবৃদ্ধি ও নির্বাচন': Icons.trending_up_rounded,
  'কল্যাণ ও অর্থ': Icons.savings_rounded,
  'পর্যালোচনা': Icons.rate_review_rounded,
};

class MonthlyReportScreen extends StatefulWidget {
  final int userId;
  const MonthlyReportScreen({super.key, required this.userId});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  Map<String, String> _computed = {};
  final Map<String, TextEditingController> _manual = {};
  bool _loading = true;
  bool _editing = false;

  /// Manual section keys first, then any computed-only sections (e.g.
  /// prayer/contacts have no manual fields) appended after.
  List<String> get _allSections => [
        ...monthlyReportManualSections.keys,
        for (final k in monthlyReportComputedSections.keys)
          if (!monthlyReportManualSections.containsKey(k)) k,
      ];

  String get _monthStr => DateFormat('yyyy-MM').format(_month);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final agg = await ReportCalc.compute(widget.userId, _monthStr);
    final manualRow = await Repo.monthlyReportManual(widget.userId, _monthStr);
    for (final section in monthlyReportManualSections.values) {
      for (final f in section) {
        final c = _manual.putIfAbsent(f.key, () => TextEditingController());
        final raw = (manualRow?[f.key] ?? '').toString();
        c.text = f.type == FieldType.number ? toBanglaDigits(raw) : raw;
      }
    }
    setState(() {
      _computed = ReportCalc.fields(agg);
      _loading = false;
    });
  }

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _month,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked == null) return;
    setState(() => _month = DateTime(picked.year, picked.month));
    await _load();
  }

  Future<void> _saveManual() async {
    final values = <String, Object?>{};
    for (final section in monthlyReportManualSections.values) {
      for (final f in section) {
        final text = _manual[f.key]!.text;
        values[f.key] = text.isEmpty ? null : (f.type == FieldType.number ? parseLocaleNum(text) : text);
      }
    }
    await Repo.saveMonthlyReportManual(widget.userId, _monthStr, values);
    if (mounted) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          color: scheme.surface,
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: _pickMonth,
                icon: const Icon(Icons.calendar_month_rounded, size: 18),
                label: Text(toBanglaDigits(DateFormat('MMMM yyyy', 'bn').format(_month))),
              ),
              const Spacer(),
              if (!_editing)
                FilledButton.icon(
                  onPressed: _loading ? null : () => setState(() => _editing = true),
                  icon: const Icon(Icons.edit_rounded, size: 18),
                  label: const Text('রিপোর্ট রাখুন'),
                )
              else ...[
                OutlinedButton(
                  onPressed: () async {
                    setState(() => _editing = false);
                    await _load();
                  },
                  child: const Text('বাতিল করুন'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _loading ? null : _saveManual,
                  icon: const Icon(Icons.save_rounded, size: 18),
                  label: const Text('রিপোর্ট সেভ করুন'),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final section in _allSections) _sectionCard(section, scheme),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _sectionCard(String section, ColorScheme scheme) {
    final manualFields = monthlyReportManualSections[section] ?? const [];
    final computedFields = monthlyReportComputedSections[section] ?? const [];
    final icon = _sectionIcons[section] ?? Icons.category_rounded;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, size: 18, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 10),
                Text(section, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            if (computedFields.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 14, color: scheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'দৈনিক তথ্য থেকে (স্বয়ংক্রিয়)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: scheme.primary, letterSpacing: 0.4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        for (final f in computedFields)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.6)),
                            ),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(text: '${f.label}  ', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                                TextSpan(
                                  text: toBanglaDigits(_computed[f.key] ?? '0'),
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface),
                                ),
                              ]),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (manualFields.isNotEmpty) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.edit_note_rounded, size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text(
                    'ম্যানুয়ালি প্রদত্ত',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (final f in manualFields)
                    SizedBox(
                      width: 220,
                      child: _editing
                          ? TextField(
                              controller: _manual[f.key],
                              decoration: InputDecoration(labelText: f.label),
                              keyboardType: f.type == FieldType.number ? TextInputType.number : TextInputType.text,
                            )
                          : _readOnlyField(f.label, _manual[f.key]?.text ?? '', scheme),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '—' : value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: value.isEmpty ? scheme.outline : scheme.onSurface),
          ),
        ],
      ),
    );
  }
}

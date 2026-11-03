import 'package:flutter/material.dart';

import '../fields.dart';
import '../repo.dart';
import '../utils.dart';

const Map<String, IconData> _planSectionIcons = {
  'কুরআন': Icons.menu_book_rounded,
  'হাদিস': Icons.import_contacts_rounded,
  'সাহিত্য ও অধ্যয়ন': Icons.local_library_rounded,
  'নামাজ ও উপস্থিতি': Icons.mosque_rounded,
  'দাওয়াত': Icons.volunteer_activism_rounded,
  'সাংগঠনিক কাজ': Icons.corporate_fare_rounded,
  'যোগাযোগ': Icons.diversity_3_rounded,
  'বিতরণ ও মিডিয়া': Icons.card_giftcard_rounded,
  'প্রবৃদ্ধি ও নির্বাচন': Icons.trending_up_rounded,
  'কল্যাণ ও অর্থ': Icons.savings_rounded,
  'পর্যালোচনা': Icons.rate_review_rounded,
  'রিপোর্ট যাচাইয়ের তারিখ': Icons.event_available_rounded,
};

class PlanFormScreen extends StatefulWidget {
  final int userId;
  final String table; // monthly_plans | yearly_plans
  final String periodColumn; // month | year
  final String periodLabel;
  final int? entryId;

  const PlanFormScreen({
    super.key,
    required this.userId,
    required this.table,
    required this.periodColumn,
    required this.periodLabel,
    this.entryId,
  });

  @override
  State<PlanFormScreen> createState() => _PlanFormScreenState();
}

class _PlanFormScreenState extends State<PlanFormScreen> {
  final _periodController = TextEditingController();
  final Map<String, TextEditingController> _fields = {};
  bool _loading = true;
  int? _entryId;
  late bool _editing;

  bool get _isMonthly => widget.table == 'monthly_plans';

  @override
  void initState() {
    super.initState();
    _entryId = widget.entryId;
    _editing = widget.entryId == null; // new entry starts in edit mode
    for (final section in planSections.values) {
      for (final f in section) {
        _fields[f.key] = TextEditingController();
      }
    }
    if (_isMonthly) _fields[reportCheckingDateField.key] = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    if (_entryId != null) {
      final row = await Repo.getPlanEntry(widget.table, _entryId!);
      if (row != null) {
        _periodController.text = (row[widget.periodColumn] ?? '').toString();
        for (final entry in _fields.entries) {
          final raw = (row[entry.key] ?? '').toString();
          entry.value.text = planFieldTypes[entry.key] == FieldType.number ? toBanglaDigits(raw) : raw;
        }
      }
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (_periodController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.periodLabel} is required')));
      return;
    }
    final values = <String, Object?>{
      'user_id': widget.userId,
      widget.periodColumn: _periodController.text.trim(),
    };
    for (final entry in _fields.entries) {
      final text = entry.value.text;
      if (text.isEmpty) {
        values[entry.key] = null;
        continue;
      }
      final isNumberField = planSections.values
          .expand((s) => s)
          .any((f) => f.key == entry.key && f.type == FieldType.number);
      values[entry.key] = isNumberField ? parseLocaleNum(text) : text;
    }
    final id = await Repo.savePlanEntry(widget.table, _entryId, values);
    if (mounted) {
      setState(() {
        _entryId = id;
        _editing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_entryId == null ? 'New entry' : (_editing ? 'Edit entry' : 'View entry')),
        actions: [
          if (!_loading && _entryId != null && !_editing)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'রিপোর্ট রাখুন',
              onPressed: () => setState(() => _editing = true),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: 220,
                      child: _editing
                          ? TextField(
                              controller: _periodController,
                              decoration: InputDecoration(
                                labelText: '${widget.periodLabel} *',
                                hintText: _isMonthly ? 'YYYY-MM' : 'YYYY',
                                prefixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                              ),
                            )
                          : _readOnlyField(widget.periodLabel, toBanglaDigits(_periodController.text), scheme),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                for (final section in planSections.entries) _sectionCard(section.key, section.value, scheme),
                if (_isMonthly) _sectionCard(reportCheckingDateSection, [reportCheckingDateField], scheme),
                const SizedBox(height: 8),
                if (_editing)
                  Row(
                    children: [
                      if (_entryId != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              setState(() => _editing = false);
                              await _load();
                            },
                            child: const Text('বাতিল করুন'),
                          ),
                        ),
                      if (_entryId != null) const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save_rounded),
                          label: const Text('সেভ করুন'),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _sectionCard(String title, List<FieldDef> defs, ColorScheme scheme) {
    final icon = _planSectionIcons[title] ?? Icons.category_rounded;
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
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                for (final f in defs)
                  SizedBox(
                    width: 220,
                    child: _editing
                        ? TextField(
                            controller: _fields[f.key],
                            decoration: InputDecoration(labelText: f.label),
                            keyboardType: f.type == FieldType.number ? TextInputType.number : TextInputType.text,
                          )
                        : _readOnlyField(f.label, _fields[f.key]?.text ?? '', scheme),
                  ),
              ],
            ),
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

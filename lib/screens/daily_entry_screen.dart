import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../report_calc.dart' show secToHour;
import '../repo.dart';
import '../utils.dart';

/// "H:MM" (or plain minutes) typed by the user -> total seconds stored,
/// matching how the Laravel app sums time-type daily values. Accepts
/// Bengali numerals the same as ASCII ones.
int? _parseHm(String text) {
  final t = toAsciiDigits(text.trim());
  if (t.isEmpty) return null;
  if (t.contains(':')) {
    final parts = t.split(':');
    final h = int.tryParse(parts[0].trim()) ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1].trim() : '0') ?? 0;
    return h * 3600 + m * 60;
  }
  final minutes = num.tryParse(t);
  return minutes == null ? null : (minutes * 60).round();
}

const Map<String, IconData> _categoryIcons = {
  'quran': Icons.menu_book_rounded,
  'hadith': Icons.import_contacts_rounded,
  'literature': Icons.local_library_rounded,
  'reading_time': Icons.schedule_rounded,
  'class': Icons.school_rounded,
  'salat': Icons.mosque_rounded,
  'contact1': Icons.groups_rounded,
  'contact2': Icons.diversity_3_rounded,
  'bitoron': Icons.card_giftcard_rounded,
  'sangothonik_dayitto_palon': Icons.volunteer_activism_rounded,
  'newspaper': Icons.newspaper_rounded,
  'exercise': Icons.fitness_center_rounded,
  'atto_somalocona': Icons.self_improvement_rounded,
};

class _Col {
  final int id;
  final int parent;
  final String enName;
  final String bnName;
  final String valueType; // number | text | time | boolean
  _Col(this.id, this.parent, this.enName, this.bnName, this.valueType);
}

class DailyEntryScreen extends StatefulWidget {
  final int userId;
  const DailyEntryScreen({super.key, required this.userId});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  DateTime _date = DateTime.now();
  List<_Col> _tops = [];
  Map<int, List<_Col>> _childrenOf = {};
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _boolValues = {};
  bool _loading = true;
  bool _editing = false;

  String get _dateStr => DateFormat('yyyy-MM-dd').format(_date);

  @override
  void initState() {
    super.initState();
    _loadTree();
  }

  Future<void> _loadTree() async {
    final rows = await Repo.reportColumnTreeRows();
    final cols = rows
        .where((r) => (r['visibility'] as int) == 1)
        .map((r) => _Col(
              r['id'] as int,
              r['parent'] as int,
              r['en_name'] as String,
              r['bn_name'] as String,
              (r['value_type'] as String?) ?? 'number',
            ))
        .toList();
    final tops = cols.where((c) => c.parent == 0).toList();
    final childrenOf = <int, List<_Col>>{};
    for (final c in cols.where((c) => c.parent != 0)) {
      childrenOf.putIfAbsent(c.parent, () => []).add(c);
    }
    setState(() {
      _tops = tops;
      _childrenOf = childrenOf;
    });
    await _loadValuesForDate();
  }

  Future<void> _loadValuesForDate() async {
    setState(() => _loading = true);
    final values = await Repo.dailyValuesFor(widget.userId, _dateStr);
    for (final top in _tops) {
      _applyValue(top, values[top.id] ?? '');
      for (final child in _childrenOf[top.id] ?? const <_Col>[]) {
        _applyValue(child, values[child.id] ?? '');
      }
    }
    setState(() => _loading = false);
  }

  void _applyValue(_Col col, String raw) {
    if (col.valueType == 'boolean') {
      _boolValues[col.id] = raw == '1';
    } else if (col.valueType == 'time') {
      final seconds = num.tryParse(raw) ?? 0;
      _controllerFor(col.id).text = seconds == 0 ? '' : toBanglaDigits(secToHour(seconds));
    } else if (col.valueType == 'number') {
      _controllerFor(col.id).text = toBanglaDigits(raw);
    } else {
      _controllerFor(col.id).text = raw;
    }
  }

  TextEditingController _controllerFor(int columnId) {
    return _controllers.putIfAbsent(columnId, () => TextEditingController());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked == null) return;
    setState(() => _date = picked);
    await _loadValuesForDate();
  }

  Future<void> _save() async {
    for (final top in _tops) {
      await _saveOne(top);
      for (final child in _childrenOf[top.id] ?? const <_Col>[]) {
        await _saveOne(child);
      }
    }
    if (mounted) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  Future<void> _saveOne(_Col col) async {
    String raw;
    if (col.valueType == 'boolean') {
      raw = (_boolValues[col.id] ?? false) ? '1' : '';
    } else if (col.valueType == 'time') {
      final seconds = _parseHm(_controllerFor(col.id).text);
      raw = seconds == null ? '' : seconds.toString();
    } else if (col.valueType == 'number') {
      raw = toAsciiDigits(_controllerFor(col.id).text);
    } else {
      raw = _controllerFor(col.id).text;
    }
    await Repo.saveDailyValue(widget.userId, col.id, _dateStr, raw);
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
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(toBanglaDigits(DateFormat('EEEE, d MMMM yyyy', 'bn').format(_date))),
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
                    await _loadValuesForDate();
                  },
                  child: const Text('বাতিল করুন'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _loading ? null : _save,
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
                    for (var i = 0; i < _tops.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _categoryCard(_tops[i], scheme)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: i + 1 < _tops.length ? _categoryCard(_tops[i + 1], scheme) : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _categoryCard(_Col top, ColorScheme scheme) {
    final children = _childrenOf[top.id] ?? const <_Col>[];
    final icon = _categoryIcons[top.enName] ?? Icons.category_rounded;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 10),
                Text(top.bnName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            if (children.isEmpty)
              SizedBox(width: 220, child: _fieldDisplay(top, scheme))
            else
              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: [for (final c in children) SizedBox(width: 220, child: _fieldDisplay(c, scheme))],
              ),
          ],
        ),
      ),
    );
  }

  Widget _fieldDisplay(_Col col, ColorScheme scheme) {
    if (col.valueType == 'boolean') {
      final checked = _boolValues[col.id] ?? false;
      if (_editing) {
        return CheckboxListTile(
          value: checked,
          onChanged: (v) => setState(() => _boolValues[col.id] = v ?? false),
          title: Text(col.bnName, style: const TextStyle(fontSize: 14)),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(color: scheme.surfaceContainerHighest.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(checked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                size: 18, color: checked ? scheme.primary : scheme.outline),
            const SizedBox(width: 8),
            Text(col.bnName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    if (_editing) {
      return TextField(
        controller: _controllerFor(col.id),
        decoration: InputDecoration(
          labelText: col.bnName,
          hintText: col.valueType == 'time' ? 'H:MM' : null,
          prefixIcon: col.valueType == 'time' ? const Icon(Icons.schedule_rounded, size: 18) : null,
        ),
        keyboardType: col.valueType == 'number'
            ? const TextInputType.numberWithOptions(decimal: true)
            : col.valueType == 'time'
                ? TextInputType.datetime
                : TextInputType.text,
      );
    }
    final value = _controllerFor(col.id).text;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(col.bnName, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
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

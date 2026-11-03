import 'package:flutter/material.dart';

import '../repo.dart';
import '../utils.dart';
import 'plan_form_screen.dart';

class PlanListScreen extends StatefulWidget {
  final int userId;
  const PlanListScreen({super.key, required this.userId});

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(controller: _tab, tabs: const [Tab(text: 'মাসিক পরিকল্পনা'), Tab(text: 'বার্ষিক পরিকল্পনা')]),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              _PlanTable(userId: widget.userId, table: 'monthly_plans', periodColumn: 'month', periodLabel: 'Month'),
              _PlanTable(userId: widget.userId, table: 'yearly_plans', periodColumn: 'year', periodLabel: 'Year'),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanTable extends StatefulWidget {
  final int userId;
  final String table;
  final String periodColumn;
  final String periodLabel;
  const _PlanTable({required this.userId, required this.table, required this.periodColumn, required this.periodLabel});

  @override
  State<_PlanTable> createState() => _PlanTableState();
}

class _PlanTableState extends State<_PlanTable> {
  List<Map<String, Object?>> _entries = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final rows = await Repo.listPlanEntries(widget.table, widget.userId);
    setState(() => _entries = rows);
  }

  Future<void> _open({int? id}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlanFormScreen(
          userId: widget.userId,
          table: widget.table,
          periodColumn: widget.periodColumn,
          periodLabel: widget.periodLabel,
          entryId: id,
        ),
      ),
    );
    await _refresh();
  }

  Future<void> _delete(int id) async {
    await Repo.deletePlanEntry(widget.table, id);
    await _refresh();
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
              Icon(Icons.event_note_rounded, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                '${widget.periodLabel} entries',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              FilledButton.icon(onPressed: () => _open(), icon: const Icon(Icons.add, size: 18), label: const Text('New')),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _entries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_rounded, size: 48, color: scheme.outline),
                      const SizedBox(height: 12),
                      Text('No entries yet.', style: TextStyle(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final e in _entries)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: scheme.primaryContainer,
                            foregroundColor: scheme.onPrimaryContainer,
                            child: const Icon(Icons.calendar_today_rounded, size: 18),
                          ),
                          title: Text(
                            toBanglaDigits((e[widget.periodColumn] ?? '').toString()),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit_rounded), onPressed: () => _open(id: e['id'] as int)),
                              IconButton(icon: const Icon(Icons.delete_rounded), onPressed: () => _delete(e['id'] as int)),
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
}

import 'package:flutter/material.dart';

import '../repo.dart';
import 'daily_entry_screen.dart';
import 'monthly_report_screen.dart';
import 'plan_list_screen.dart';

/// The app shell once a profile is open: title bar with a profile-switcher
/// dropdown, and the Daily Entry / Monthly Report / Plans tabs.
class WorkspaceScreen extends StatelessWidget {
  final UserRow user;
  final List<UserRow> allUsers;
  final ValueChanged<UserRow> onSwitchProfile;
  final VoidCallback onManageProfiles;

  const WorkspaceScreen({
    super.key,
    required this.user,
    required this.allUsers,
    required this.onSwitchProfile,
    required this.onManageProfiles,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.menu_book_rounded, color: scheme.primary),
            const SizedBox(width: 10),
            const Text('MyReportBD'),
          ],
        ),
        actions: [
          _profileDropdown(context, scheme),
          const SizedBox(width: 12),
        ],
      ),
      body: _Workspace(user: user),
    );
  }

  Widget _profileDropdown(BuildContext context, ColorScheme scheme) {
    return PopupMenuButton<Object>(
      offset: const Offset(0, 48),
      itemBuilder: (context) => [
        for (final u in allUsers)
          CheckedPopupMenuItem(value: u, checked: u.id == user.id, child: Text(u.name)),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'manage', child: Text('Manage profiles…')),
      ],
      onSelected: (value) {
        if (value == 'manage') {
          onManageProfiles();
        } else if (value is UserRow) {
          onSwitchProfile(value);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 11,
              backgroundColor: scheme.primary,
              child: Text(
                user.name.isEmpty ? '?' : user.name.characters.first.toUpperCase(),
                style: TextStyle(fontSize: 11, color: scheme.onPrimary),
              ),
            ),
            const SizedBox(width: 8),
            Text(user.name, style: TextStyle(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down_rounded, color: scheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }
}

class _Workspace extends StatefulWidget {
  final UserRow user;
  const _Workspace({required this.user});

  @override
  State<_Workspace> createState() => _WorkspaceState();
}

class _WorkspaceState extends State<_Workspace> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'দৈনন্দিন রিপোর্ট'),
            Tab(text: 'মাসিক রিপোর্ট'),
            Tab(text: 'পরিকল্পনা'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            children: [
              DailyEntryScreen(userId: widget.user.id),
              MonthlyReportScreen(userId: widget.user.id),
              PlanListScreen(userId: widget.user.id),
            ],
          ),
        ),
      ],
    );
  }
}

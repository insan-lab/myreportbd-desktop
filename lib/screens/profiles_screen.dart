import 'package:flutter/material.dart';

import '../repo.dart';

/// Full-screen profile manager: list, create, delete (with confirmation).
/// Tapping a profile calls [onSelected] — the caller decides whether that
/// means "open it" (root usage) or "pop back with it" (pushed from a
/// workspace's profile switcher).
class ProfilesScreen extends StatefulWidget {
  final ValueChanged<UserRow> onSelected;
  const ProfilesScreen({super.key, required this.onSelected});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  List<UserRow> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final users = await Repo.listUsers();
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  Future<void> _addProfile() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New reporter profile'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Save')),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty) return;
    await Repo.createUser(name.trim());
    await _refresh();
  }

  Future<void> _deleteProfile(UserRow u) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete profile?'),
        content: Text('This removes "${u.name}" and all its daily entries, reports and plans. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await Repo.deleteUser(u.id);
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporter profiles'),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded), tooltip: 'New profile', onPressed: _addProfile),
          const SizedBox(width: 8),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add_alt_1_rounded, size: 48, color: scheme.outline),
                      const SizedBox(height: 12),
                      Text('No profiles yet.', style: TextStyle(color: scheme.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _addProfile,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('New profile'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
                    final u = _users[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: scheme.primaryContainer,
                          foregroundColor: scheme.onPrimaryContainer,
                          child: Text(u.name.isEmpty ? '?' : u.name.characters.first.toUpperCase()),
                        ),
                        title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_rounded),
                          onPressed: () => _deleteProfile(u),
                        ),
                        onTap: () => widget.onSelected(u),
                      ),
                    );
                  },
                ),
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(title: const Text('Reporter profiles')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 96),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final u in _users) _ProfileTile(user: u, onTap: () => widget.onSelected(u), onDelete: () => _deleteProfile(u)),
                        _NewProfileTile(onTap: _addProfile),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// Small rectangular tile for a single profile.
class _ProfileTile extends StatelessWidget {
  final UserRow user;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _ProfileTile({required this.user, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 110,
      height: 96,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: scheme.primaryContainer,
                      foregroundColor: scheme.onPrimaryContainer,
                      child: Text(user.name.isEmpty ? '?' : user.name.characters.first.toUpperCase()),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  iconSize: 16,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Delete',
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small rectangular tile that opens the "add profile" dialog.
class _NewProfileTile extends StatelessWidget {
  final VoidCallback onTap;
  const _NewProfileTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 110,
      height: 96,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline, style: BorderStyle.solid),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: scheme.primary, size: 28),
              const SizedBox(height: 8),
              Text('New profile', style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

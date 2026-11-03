import 'package:flutter/material.dart';

import '../repo.dart';
import 'profiles_screen.dart';
import 'workspace_screen.dart';

/// App root: shows the Profiles screen first; once a profile is opened,
/// shows the Workspace (which can switch/manage profiles from its app bar).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRow? _user;
  List<UserRow> _users = [];

  Future<void> _refreshUsers() async {
    final users = await Repo.listUsers();
    setState(() {
      _users = users;
      if (_user != null && !users.any((u) => u.id == _user!.id)) {
        _user = null;
      }
    });
  }

  Future<void> _manageProfiles() async {
    final picked = await Navigator.of(context).push<UserRow>(
      MaterialPageRoute(
        builder: (_) => ProfilesScreen(onSelected: (u) => Navigator.of(context).pop(u)),
      ),
    );
    await _refreshUsers();
    if (picked != null) setState(() => _user = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return ProfilesScreen(
        onSelected: (u) async {
          setState(() => _user = u);
          await _refreshUsers();
        },
      );
    }
    return WorkspaceScreen(
      user: _user!,
      allUsers: _users,
      onSwitchProfile: (u) => setState(() => _user = u),
      onManageProfiles: _manageProfiles,
    );
  }
}

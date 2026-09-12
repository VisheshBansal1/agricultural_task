import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class _MockUserRow {
  final String name;
  final String phone;
  final String location;
  bool blocked;
  _MockUserRow(this.name, this.phone, this.location, {this.blocked = false});
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<_MockUserRow> _users = [
    _MockUserRow('Vishesh Sharma', '+91 98765 43210', 'Karnal, Haryana'),
    _MockUserRow('Meena Kumari', '+91 91234 11122', 'Panipat, Haryana'),
    _MockUserRow('Ravi Chauhan', '+91 99887 66554', 'Kurukshetra, Haryana'),
    _MockUserRow('Simran Kaur', '+91 98123 45678', 'Panipat, Haryana'),
    _MockUserRow('Anita Devi', '+91 90000 11223', 'Karnal, Haryana', blocked: true),
  ];
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filtered = _users.where((u) => u.name.toLowerCase().contains(_search.text.toLowerCase())).toList();

    return AdminScaffold(
      title: 'User Management',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'Search users...', prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final u = filtered[i];
                return StaggeredFadeIn(
                  index: i,
                  child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.secondary.withOpacity(0.18),
                        child: Text(u.name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.name, style: Theme.of(context).textTheme.titleSmall),
                            Text('${u.phone} · ${u.location}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => u.blocked = !u.blocked),
                        child: Text(u.blocked ? 'Unblock' : 'Block', style: TextStyle(color: u.blocked ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

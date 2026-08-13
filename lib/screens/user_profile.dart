import 'package:flutter/material.dart';
import 'package:ubatku/data/mock_data.dart';
import 'package:ubatku/models/user.dart';
import 'package:ubatku/theme/app_theme.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User user = MockData.currentUser;

    return Scaffold(
      backgroundColor: UbatKuTheme.surface,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: UbatKuTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: UbatKuTheme.primaryContainer.withAlpha(
                (0.25 * 255).toInt(),
              ),
              child: Icon(
                Icons.person,
                size: 48,
                color: UbatKuTheme.primary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              user.fullName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 4),
            Text(
              '@${user.username}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: UbatKuTheme.onSurfaceVariant),
            ),
            SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  _ProfileInfoTile(
                    icon: Icons.badge_outlined,
                    label: 'Full Name',
                    value: user.fullName,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoTile(
                    icon: Icons.alternate_email,
                    label: 'Username',
                    value: user.username,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoTile(
                    icon: Icons.mail_outline,
                    label: 'Email',
                    value: user.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: UbatKuTheme.primary),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      subtitle: Text(value, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

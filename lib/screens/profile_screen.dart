import 'package:flutter/material.dart';
import 'package:ubatku/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final String? email;
  final VoidCallback onLogout;

  const ProfileScreen({Key? key, this.email, required this.onLogout})
    : super(key: key);

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLogout();
            },
            child: Text('Log Out', style: TextStyle(color: UbatKuTheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = email == null || email!.isEmpty ? 'Guest User' : email!;

    return Scaffold(
      backgroundColor: UbatKuTheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: UbatKuTheme.surface,
        elevation: 0,
        title: Text('Profile'),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
        children: [
          // Avatar & Identity
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: UbatKuTheme.primaryContainer.withAlpha(
                      (0.25 * 255).toInt(),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 44,
                    color: UbatKuTheme.primary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  displayEmail,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Account Section
          _SectionLabel('Account'),
          _ProfileTile(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () => _showComingSoon(context),
          ),
          _ProfileTile(
            icon: Icons.notifications_outlined,
            label: 'Notification Settings',
            onTap: () => _showComingSoon(context),
          ),
          _ProfileTile(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () => _showComingSoon(context),
          ),
          SizedBox(height: 24),

          // Support Section
          _SectionLabel('Support'),
          _ProfileTile(
            icon: Icons.help_outline,
            label: 'Help & Support',
            onTap: () => _showComingSoon(context),
          ),
          _ProfileTile(
            icon: Icons.info_outline,
            label: 'About UbatKu',
            onTap: () => _showComingSoon(context),
          ),
          SizedBox(height: 24),

          // Logout
          _ProfileTile(
            icon: Icons.logout,
            label: 'Log Out',
            color: UbatKuTheme.error,
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coming soon'), duration: Duration(seconds: 1)),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: UbatKuTheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? UbatKuTheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: UbatKuTheme.surfaceLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: tileColor),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: tileColor,
          ),
        ),
        trailing: color == null
            ? Icon(Icons.chevron_right, color: UbatKuTheme.outline)
            : null,
        onTap: onTap,
      ),
    );
  }
}

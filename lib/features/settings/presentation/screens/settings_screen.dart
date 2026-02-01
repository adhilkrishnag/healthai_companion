import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app.dart';
import '../../../../core/theme/app_colors.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _SectionHeader(title: 'Appearance'),
          _SettingCard(
            children: [
              _SettingItem(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                trailing: DropdownButton<ThemeMode>(
                  value: themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(themeModeProvider.notifier).state = value;
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // AI Settings section
          _SectionHeader(title: 'AI Settings'),
          _SettingCard(
            children: [
              _SettingItem(
                icon: Icons.key_outlined,
                title: 'Gemini API Key',
                subtitle: 'Configure your API key for AI features',
                onTap: () => _showApiKeyDialog(context),
              ),
              _SettingItem(
                icon: Icons.cached,
                title: 'Clear AI Cache',
                subtitle: 'Remove cached AI responses',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data & Privacy section
          _SectionHeader(title: 'Data & Privacy'),
          _SettingCard(
            children: [
              _SwitchSettingItem(
                icon: Icons.cloud_upload_outlined,
                title: 'Cloud Sync',
                subtitle: 'Sync data with Firebase',
                value: true,
                onChanged: (value) {},
              ),
              _SwitchSettingItem(
                icon: Icons.analytics_outlined,
                title: 'Share Analytics',
                subtitle: 'Help improve the app',
                value: false,
                onChanged: (value) {},
              ),
              _SettingItem(
                icon: Icons.delete_forever_outlined,
                title: 'Delete All Data',
                subtitle: 'Permanently delete all local data',
                titleColor: AppColors.error,
                onTap: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Notifications section
          _SectionHeader(title: 'Notifications'),
          _SettingCard(
            children: [
              _SwitchSettingItem(
                icon: Icons.notifications_outlined,
                title: 'Push Notifications',
                subtitle: 'Receive reminders and updates',
                value: true,
                onChanged: (value) {},
              ),
              _SwitchSettingItem(
                icon: Icons.volume_up_outlined,
                title: 'Sound',
                subtitle: 'Play notification sounds',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About section
          _SectionHeader(title: 'About'),
          _SettingCard(
            children: [
              _SettingItem(
                icon: Icons.info_outline,
                title: 'App Version',
                trailing: Text(
                  '1.0.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              _SettingItem(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingItem(
                icon: Icons.code,
                title: 'Open Source Licenses',
                onTap: () {
                  showLicensePage(context: context);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your Google Gemini API key to enable AI features.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'AIza...',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save API key securely
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('API key saved')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text(
          'This will permanently delete all your health data, journal entries, and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete all data
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All data deleted')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  titleColor ??
                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      )
                    : const SizedBox()),
          ],
        ),
      ),
    );
  }
}

class _SwitchSettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

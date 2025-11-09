import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/application/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFF2C94C),
                  child: Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.email ?? 'Student User',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.uid ?? 'ID Not Available',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[500]),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          const Divider(color: Colors.grey, height: 1),

          // Notification Settings
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('App Settings',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.colorScheme.primary)),
          ),

          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notification Reminders'),
            trailing: Switch(
              value: true,
              onChanged: (val) {
                // Local simulation for notifications
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),

          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('Email Updates'),
            trailing: Switch(
              value: false,
              onChanged: (val) {
                // Local simulation for email updates
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),

          const Divider(color: Colors.grey, height: 1),

          // About and Logout
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About BookSwap'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Log Out',
                style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/browse/browse_screen.dart';
import '../../features/my_listings_screen.dart';
import '../../features/chats_screen.dart';
import '../../features/settings_screen.dart';

// This provider will hold the currently selected tab index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  // List of our 4 main screens
  final List<Widget> _screens = const [
    BrowseScreen(),
    MyListingsScreen(),
    ChatsScreen(),
    SettingsScreen(), // Corresponds to the Profile/Settings screen
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the current index
    final selectedIndex = ref.watch(navigationIndexProvider);

    return Scaffold(
      body: _screens[selectedIndex], // Show the currently selected screen
      bottomNavigationBar: BottomNavigationBar(
        // Use the theme you set in main.dart
        type: Theme.of(context).bottomNavigationBarTheme.type,
        currentIndex: selectedIndex,
        onTap: (index) {
          // When tapped, update the provider's state
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        items: const [
          // Index 0: Browse Listings -> Feed
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          // Index 1: My Listings
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'My Listings',
          ),
          // Index 2: Chats
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          // Index 3: Settings -> Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

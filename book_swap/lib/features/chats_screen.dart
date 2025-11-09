import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat/chat_detail_screen.dart';

class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Static list to represent active swap chats.
    final activeChats = [
      {
        'chatId': 'test_chat_1',
        'recipientEmail': 'Alice',
        'lastMessage': 'Hsu about tomorrow?'
      },
      {
        'chatId': 'test_chat_2',
        'recipientEmail': 'Bob Goays',
        'lastMessage': 'I\'m interested in finding.'
      },
    ];

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: activeChats.length,
        itemBuilder: (context, index) {
          final chat = activeChats[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFF2C94C), // Yellow avatar background
                child: Icon(Icons.person, color: Colors.black, size: 24),
              ),
              title: Text(chat['recipientEmail']!,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(chat['lastMessage']!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              trailing: Text('May 20',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => ChatDetailScreen(
                      chatId: chat['chatId']!,
                      recipientEmail: chat['recipientEmail']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:chat_app/components/chat_drawer.dart';
import 'package:chat_app/components/chat_text.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  void _showUnblockBox(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ChatText(
          text: 'unblock user',
          size: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.surface,
        ),
        content: ChatText(
          text: 'are you sure you want to unblock this user?',
          size: 15,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.surface,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: ChatText(
              text: 'no',
              size: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          TextButton(
            onPressed: () {
              ChatService().unblockUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: ChatText(
                    text: 'user unblocked!',
                    size: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              );
            },
            child: ChatText(
              text: 'yes, unblock',
              size: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.surface,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String userId = authService.getCurrentUser()!.uid;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: ChatText(
          text: 'blocked users',
          size: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      drawer: const ChatDrawer(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUsersStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 75,
                  ),
                  const SizedBox(height: 5.0),
                  ChatText(
                    text: 'an error ocurred',
                    size: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(height: 2.0),
                  ChatText(
                    text: "sorry for that. please, try again",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                  )
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }

          final blockedUsers = snapshot.data ?? [];

          if (blockedUsers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mood,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 75,
                  ),
                  const SizedBox(height: 5.0),
                  ChatText(
                    text: 'no blocked users found',
                    size: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                userName: user["name"],
                userEmail: user["email"],
                onTap: () => _showUnblockBox(context, user["uid"]),
              );
            },
          );
        },
      ),
    );
  }
}

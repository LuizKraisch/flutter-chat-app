import 'package:chat_app/components/chat_drawer.dart';
import 'package:chat_app/components/chat_text.dart';
import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: ChatText(
          text: 'chats',
          size: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      drawer: const ChatDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ]),
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

        if (snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.mood_bad,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 75,
                ),
                const SizedBox(height: 5.0),
                ChatText(
                  text: 'no users found',
                  size: 18,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(height: 2.0),
                ChatText(
                  text: "don't be shy... start by adding some users!",
                  size: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              ],
            ),
          );
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        userName: userData["name"],
        userEmail: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}

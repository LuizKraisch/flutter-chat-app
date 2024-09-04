import 'package:chat_app/components/chat_drawer.dart';
import 'package:chat_app/components/chat_text.dart';
import 'package:chat_app/pages/blocked_users_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: ChatText(
          text: 'settings',
          size: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      drawer: const ChatDrawer(),
      body: const SettingsOptions(),
    );
  }
}

class SettingsOptions extends StatelessWidget {
  const SettingsOptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatText(
                    text: 'light mode',
                    size: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  ChatText(
                    text: 'enables or disables the light mode in the app',
                    size: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ],
              ),
              CupertinoSwitch(
                value: Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).isLightMode,
                onChanged: (value) => Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatText(
                    text: 'blocked users',
                    size: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  ChatText(
                    text: 'check the users you blocked',
                    size: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlockedUsersPage(),
                  ),
                ),
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

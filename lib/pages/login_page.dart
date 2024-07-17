import 'package:chat_app/components/chat_button.dart';
import 'package:chat_app/components/chat_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onRegisterTap;

  LoginPage({super.key, required this.onRegisterTap});

  void login() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.mood,
                size: 80,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 10),
              Text(
                'welcome back!',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "it's good to see you again.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ChatTextField(
                controller: _emailController,
                hintText: 'your email',
                obscureText: false,
                padding: 0,
              ),
              const SizedBox(height: 20),
              ChatTextField(
                controller: _passwordController,
                hintText: 'your password',
                obscureText: true,
                padding: 0,
              ),
              const SizedBox(height: 20),
              ChatButton(
                onTap: login,
                label: 'login',
                padding: 15,
                margin: 0,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'not a member? ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onRegisterTap,
                    child: Text(
                      'register now',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

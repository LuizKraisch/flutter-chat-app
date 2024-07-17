import 'package:chat_app/components/chat_button.dart';
import 'package:chat_app/components/chat_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final void Function()? onLoginTap;

  RegisterPage({super.key, required this.onLoginTap});

  void register() {}

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
                Icons.person_add_alt_1,
                size: 80,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              const SizedBox(height: 10),
              Text(
                "let's create your account!",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "we're so happy to have you here.",
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
              ChatTextField(
                controller: _confirmPasswordController,
                hintText: 'confirm your password',
                obscureText: true,
                padding: 0,
              ),
              const SizedBox(height: 20),
              ChatButton(
                onTap: register,
                label: 'register',
                padding: 15,
                margin: 0,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already have an account? ',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onLoginTap,
                    child: Text(
                      'back to login',
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

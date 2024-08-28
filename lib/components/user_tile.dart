import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  final String userName;
  final String userID;
  final void Function()? onTap;

  const UserTile(
      {super.key,
      required this.userName,
      required this.userID,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                      userID,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

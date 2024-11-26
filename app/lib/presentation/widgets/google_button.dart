import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the platform
    final bool isIOS = !kIsWeb && Platform.isIOS;

    // Define platform-specific dimensions and paddings
    final double buttonHeight = isIOS ? 44.0 : 40.0;
    final double horizontalPadding = isIOS ? 16.0 : 12.0;
    final double iconTextSpacing = isIOS ? 12.0 : 10.0;
    final double iconSize = 20.0; // Logo size remains 20px
    final double borderRadius = 20.0; // Remains the same
    final double borderWidth = 1.0; // Remains the same

    return SizedBox(
      width: 200,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: Color(0xFF747775), // Stroke color: #747775
              width: borderWidth,
            ),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          mainAxisSize: MainAxisSize.max,
          children: [
            // Icon with fixed size
            Container(
              width: iconSize,
              height: iconSize,
              // Space between icon and text
              margin: EdgeInsets.only(right: iconTextSpacing),
              child: SvgPicture.string(
                '''<svg version="1.1" xmlns="http://www.w3.org/2000/svg" 
                    viewBox="0 0 48 48" xmlns:xlink="http://www.w3.org/1999/xlink">
                  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 
                  3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 
                  2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
                  <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94
                  c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 
                  7.09-10.36 7.09-17.65z"/>
                  <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59
                  l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 
                  2.56 10.78l7.97-6.19z"/>
                  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 
                  1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 
                  6.19C6.51 42.62 14.62 48 24 48z"/>
                  <path fill="none" d="M0 0h48v48H0z"/>
                </svg>''',
                width: iconSize,
                height: iconSize,
              ),
            ),
            // Text
            Text(
              'Sign in with Google',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Font weight: Medium
                fontSize: 14, // Font size: 14px
                height: 20 / 14, // Line height: 20px
                letterSpacing: 0.25, // Letter spacing: 0.25px
                color: Color(0xFF1F1F1F), // Font color: #1F1F1F
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Remove Spacer(), no longer needed
          ],
        ),
      ),
    );
  }
}

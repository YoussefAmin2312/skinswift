import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skinswift/auth/auth_service.dart';

Widget buildDivider() {
  return Row(
    children: [
      Expanded(child: Divider(color: Colors.grey[300])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text('OR', style: TextStyle(color: Colors.grey[600])),
      ),
      Expanded(child: Divider(color: Colors.grey[300])),
    ],
  );
}

Widget buildSocialLoginButtons(
    BuildContext context, ValueNotifier<bool> isLoading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SocialLoginButton(
        assetPath: 'assets/google_logo.svg',
        onTap: () async {
          isLoading.value = true;
          try {
            await AuthService().signInWithGoogle();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          } finally {
            if (context.mounted) {
              isLoading.value = false;
            }
          }
        },
      ),
    ],
  );
}

class SocialLoginButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          assetPath,
          height: 40,
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/constants.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppStrings.orContinueWith,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        )
            .animate(delay: 600.ms)
            .fadeIn(duration: 600.ms),
        
        const SizedBox(height: 24),
        
        // Social login buttons
        Column(
          children: [
            _buildSocialButton(
              context: context,
              provider: 'Google',
              icon: FontAwesomeIcons.google,
              color: const Color(0xFFDB4437),
              delay: 700,
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              context: context,
              provider: 'Facebook',
              icon: FontAwesomeIcons.facebook,
              color: const Color(0xFF4267B2),
              delay: 800,
            ),
            const SizedBox(height: 12),
            _buildSocialButton(
              context: context,
              provider: 'Twitter',
              icon: FontAwesomeIcons.twitter,
              color: const Color(0xFF1DA1F2),
              delay: 900,
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Privacy text
        Text(
          AppStrings.privacyAgreement,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        )
            .animate(delay: 1000.ms)
            .fadeIn(duration: 600.ms),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          // For now, show a toast that social login is not configured
          Fluttertoast.showToast(
            msg: '$provider login is not configured yet',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 12),
            Text(
              '${AppStrings.continueWith} $provider',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: delay.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0)
        .then()
        .shimmer(duration: 1500.ms, delay: 2000.ms);
  }
}
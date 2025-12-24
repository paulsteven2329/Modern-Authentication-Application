import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/theme/theme_event.dart';
import '../widgets/magic_link_form.dart';
import '../widgets/social_login_buttons.dart';
import '../widgets/theme_toggle.dart';
import '../widgets/floating_elements.dart';
import '../widgets/glass_container.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.hasError) {
          Fluttertoast.showToast(
            msg: state.errorMessage!,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else if (state.successMessage != null) {
          Fluttertoast.showToast(
            msg: state.successMessage!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        }

        if (state.isAuthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Scaffold(
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return Stack(
                  children: [
                    // Background gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.backgroundGradient(themeState.isDark),
                      ),
                    ),
                    
                    // Floating elements
                    const FloatingElements(),
                    
                    // Theme toggle
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      right: 16,
                      child: const ThemeToggle(),
                    ),
                    
                    // Main content
                    SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(
                            sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                                ? 16 
                                : 24,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: sizingInformation.deviceScreenType == DeviceScreenType.mobile
                                  ? double.infinity
                                  : 400,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Login card
                                GlassContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32),
                                    child: Column(
                                      children: [
                                        // Header
                                        _buildHeader(),
                                        
                                        const SizedBox(height: 32),
                                        
                                        // Magic link form
                                        const MagicLinkForm(),
                                        
                                        const SizedBox(height: 24),
                                        
                                        // Social login
                                        const SocialLoginButtons(),
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Footer
                                        _buildFooter(),
                                      ],
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Additional info
                                _buildAdditionalInfo(themeState.isDark),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.security,
            size: 32,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
        
        const SizedBox(height: 16),
        
        // Title
        Text(
          AppStrings.welcomeBack,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        
        const SizedBox(height: 8),
        
        // Subtitle
        Text(
          AppStrings.signInPrompt,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        )
            .animate(delay: 400.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildFooter() {
    return Text(
      AppStrings.securePasswordless,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[600],
      ),
    )
        .animate(delay: 700.ms)
        .fadeIn(duration: 600.ms);
  }

  Widget _buildAdditionalInfo(bool isDark) {
    return Text(
      AppStrings.noPasswordsToRemember,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        color: isDark ? Colors.white.withOpacity(0.8) : Colors.white.withOpacity(0.9),
      ),
    )
        .animate(delay: 800.ms)
        .fadeIn(duration: 600.ms);
  }
}
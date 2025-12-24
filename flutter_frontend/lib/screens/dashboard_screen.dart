import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../widgets/theme_toggle.dart';
import '../widgets/glass_container.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return Scaffold(
            backgroundColor: themeState.isDark 
                ? const Color(0xFF111827)
                : const Color(0xFFF7FAFC),
            body: ResponsiveBuilder(
              builder: (context, sizingInformation) {
                return CustomScrollView(
                  slivers: [
                    // App bar
                    _buildSliverAppBar(context, themeState, sizingInformation),
                    
                    // Content
                    SliverPadding(
                      padding: EdgeInsets.all(
                        sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                            ? 16 
                            : 24,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Welcome section
                          _buildWelcomeSection(context),
                          
                          const SizedBox(height: 32),
                          
                          // Stats cards
                          _buildStatsSection(context, sizingInformation),
                          
                          const SizedBox(height: 32),
                          
                          // Features section
                          _buildFeaturesSection(context),
                        ]),
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

  Widget _buildSliverAppBar(
    BuildContext context,
    ThemeState themeState,
    SizingInformation sizingInformation,
  ) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: themeState.isDark 
              ? const Color(0xFF1F2937).withOpacity(0.8)
              : Colors.white.withOpacity(0.8),
          border: Border(
            bottom: BorderSide(
              color: themeState.isDark 
                  ? Colors.grey[700]!
                  : Colors.grey[200]!,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizingInformation.deviceScreenType == DeviceScreenType.mobile 
                  ? 16 
                  : 24,
            ),
            child: Row(
              children: [
                // App logo and title
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const Spacer(),
                
                // Theme toggle and logout
                Row(
                  children: [
                    const ThemeToggle(),
                    const SizedBox(width: 12),
                    _buildLogoutButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            _showLogoutDialog(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.red[600],
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  AppStrings.signOut,
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return GlassContainer(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.welcomeBack + '!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You\'re successfully authenticated and ready to go.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Celebration emoji
                  Text(
                    '🎉',
                    style: const TextStyle(fontSize: 64),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(period: 4000.ms),
                      )
                      .rotate(
                        begin: -0.1,
                        end: 0.1,
                        duration: 1000.ms,
                      ),
                ],
              ),
              
              if (state.user != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: state.user!.avatar != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  state.user!.avatar!,
                                  width: 48,
                                  height: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 24,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user!.name ?? 'User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    state.user!.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildStatsSection(BuildContext context, SizingInformation sizingInformation) {
    final stats = [
      {
        'icon': Icons.person,
        'label': AppStrings.profile,
        'value': AppStrings.complete,
        'color': Colors.blue,
      },
      {
        'icon': Icons.security,
        'label': AppStrings.security,
        'value': AppStrings.verified,
        'color': Colors.green,
      },
      {
        'icon': Icons.star,
        'label': AppStrings.status,
        'value': AppStrings.active,
        'color': Colors.orange,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sizingInformation.deviceScreenType == DeviceScreenType.mobile ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: sizingInformation.deviceScreenType == DeviceScreenType.mobile ? 4 : 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  stat['icon'] as IconData,
                  color: stat['color'] as Color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      stat['value'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0);
      },
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      AppStrings.passwordlessAuth,
      AppStrings.magicLinkLogin,
      AppStrings.socialAuth,
      AppStrings.jwtSecurity,
      AppStrings.darkModeSupport,
      AppStrings.glassmorphismUI,
    ];

    return GlassContainer(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.authFeatures,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 4,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      features[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0);
  }
}
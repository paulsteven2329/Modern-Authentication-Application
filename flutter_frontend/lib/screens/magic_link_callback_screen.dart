import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/auth/auth_event.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class MagicLinkCallbackScreen extends StatefulWidget {
  final String? token;
  final String? provider;
  final String? code;

  const MagicLinkCallbackScreen({
    Key? key,
    this.token,
    this.provider,
    this.code,
  }) : super(key: key);

  @override
  State<MagicLinkCallbackScreen> createState() => _MagicLinkCallbackScreenState();
}

class _MagicLinkCallbackScreenState extends State<MagicLinkCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  void _handleCallback() {
    if (widget.token != null) {
      // Magic link verification
      context.read<AuthBloc>().add(AuthMagicLinkVerifyRequested(widget.token!));
    } else if (widget.provider != null && widget.code != null) {
      // Social login callback
      context.read<AuthBloc>().add(
        AuthSocialLoginRequested(widget.provider!, code: widget.code),
      );
    } else {
      // Invalid callback parameters
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            }
          });
        } else if (state.hasError) {
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status icon
                    _buildStatusIcon(state),
                    
                    const SizedBox(height: 32),
                    
                    // Status title
                    Text(
                      _getStatusTitle(state),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),
                    
                    const SizedBox(height: 16),
                    
                    // Status message
                    Text(
                      _getStatusMessage(state),
                      style: TextStyle(
                        fontSize: 16,
                        color: _getMessageColor(state),
                      ),
                      textAlign: TextAlign.center,
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms),
                    
                    const SizedBox(height: 32),
                    
                    // Loading indicator or status indicator
                    if (state.isLoading) ...[
                      _buildLoadingIndicator(),
                    ] else if (state.isAuthenticated) ...[
                      Text(
                        AppStrings.redirectingToDashboard,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 600.ms),
                    ] else if (state.hasError) ...[
                      Text(
                        AppStrings.redirectingToLogin,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms, duration: 600.ms),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusIcon(AuthState state) {
    Widget icon;
    Color color;

    if (state.isLoading) {
      icon = const CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.blue,
      );
      color = Colors.blue;
    } else if (state.isAuthenticated) {
      icon = Icon(
        Icons.check_circle,
        size: 64,
        color: Colors.green[600],
      );
      color = Colors.green;
    } else if (state.hasError) {
      icon = Icon(
        Icons.error,
        size: 64,
        color: Colors.red[600],
      );
      color = Colors.red;
    } else {
      icon = Icon(
        Icons.hourglass_empty,
        size: 64,
        color: Colors.orange[600],
      );
      color = Colors.orange;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(child: icon),
    )
        .animate()
        .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut);
  }

  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0),
        const SizedBox(width: 8),
        _buildDot(100),
        const SizedBox(width: 8),
        _buildDot(200),
      ],
    )
        .animate()
        .fadeIn(delay: 600.ms, duration: 600.ms);
  }

  Widget _buildDot(int delay) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .scale(
          delay: delay.ms,
          duration: 800.ms,
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.2, 1.2),
        )
        .then()
        .scale(
          duration: 800.ms,
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.5, 0.5),
        );
  }

  String _getStatusTitle(AuthState state) {
    if (state.isLoading) {
      return AppStrings.authenticating;
    } else if (state.isAuthenticated) {
      return AppStrings.welcome;
    } else if (state.hasError) {
      return AppStrings.authFailed;
    }
    return 'Processing...';
  }

  String _getStatusMessage(AuthState state) {
    if (state.isLoading) {
      return 'Verifying your authentication...';
    } else if (state.isAuthenticated) {
      return state.successMessage ?? 'Successfully signed in!';
    } else if (state.hasError) {
      return state.errorMessage ?? 'Authentication failed';
    }
    return 'Please wait while we process your request.';
  }

  Color _getMessageColor(AuthState state) {
    if (state.isLoading) {
      return Colors.blue[600]!;
    } else if (state.isAuthenticated) {
      return Colors.green[600]!;
    } else if (state.hasError) {
      return Colors.red[600]!;
    }
    return Colors.grey[600]!;
  }
}
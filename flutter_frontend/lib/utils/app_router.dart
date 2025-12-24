import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/magic_link_callback_screen.dart';
import '../screens/splash_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/auth/callback',
        name: 'auth_callback',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          final provider = state.uri.queryParameters['provider'];
          final code = state.uri.queryParameters['code'];
          
          return MagicLinkCallbackScreen(
            token: token,
            provider: provider,
            code: code,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final location = state.matchedLocation;

      // Skip redirect for callback route
      if (location.startsWith('/auth/callback')) {
        return null;
      }

      // Skip redirect for splash screen
      if (location == '/') {
        return null;
      }

      // If user is authenticated and trying to access login, redirect to dashboard
      if (authState.isAuthenticated && location == '/login') {
        return '/dashboard';
      }

      // If user is not authenticated and trying to access protected routes, redirect to login
      if (!authState.isAuthenticated && location == '/dashboard') {
        return '/login';
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      // This will refresh the router when auth state changes
      // We'll implement this as a simple stream
      Stream.empty(),
    ),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Extension to make navigation easier
extension AppNavigation on BuildContext {
  void goToLogin() => go('/login');
  void goToDashboard() => go('/dashboard');
  void goToSplash() => go('/');
}
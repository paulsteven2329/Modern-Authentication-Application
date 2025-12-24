import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../models/models.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService _apiService;

  AuthBloc(this._apiService) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthMagicLinkVerifyRequested>(_onAuthMagicLinkVerifyRequested);
    on<AuthSocialLoginRequested>(_onAuthSocialLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthResendMagicLinkRequested>(_onAuthResendMagicLinkRequested);
    on<AuthTokenRefreshRequested>(_onAuthTokenRefreshRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      // Check if token exists and is valid
      final isTokenValid = await StorageService.isTokenValid();
      if (!isTokenValid) {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
        ));
        return;
      }

      // Get stored user data
      final user = await StorageService.getUser();
      final token = await StorageService.getToken();

      if (user != null && token != null) {
        _apiService.setAccessToken(token);
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
        ));
      }
    } catch (e) {
      debugPrint('Auth check error: $e');
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      ));
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, clearError: true));

      await _apiService.sendMagicLink(event.email);

      emit(state.copyWith(
        status: AuthStatus.magicLinkSent,
        successMessage: 'Magic link sent to your email!',
        lastSentEmail: event.email,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthMagicLinkVerifyRequested(
    AuthMagicLinkVerifyRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, clearError: true));

      final authResponse = await _apiService.verifyMagicLink(event.token);

      // Save token and user data
      await StorageService.saveToken(authResponse.accessToken);
      await StorageService.saveUser(authResponse.user);

      // Set token for future API calls
      _apiService.setAccessToken(authResponse.accessToken);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: authResponse.user,
        successMessage: 'Login successful!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthSocialLoginRequested(
    AuthSocialLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, clearError: true));

      if (event.code != null) {
        // Handle callback with code
        final authResponse = await _apiService.socialLogin(event.provider, event.code!);

        // Save token and user data
        await StorageService.saveToken(authResponse.accessToken);
        await StorageService.saveUser(authResponse.user);

        // Set token for future API calls
        _apiService.setAccessToken(authResponse.accessToken);

        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: authResponse.user,
          successMessage: 'Login successful with ${event.provider}!',
        ));
      } else {
        // This would trigger the social login flow
        // The actual implementation depends on the platform
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Social login not implemented for this platform',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Clear stored data
      await StorageService.clearAll();
      
      // Clear API service token
      _apiService.setAccessToken(null);

      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
        successMessage: 'Logged out successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to logout: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAuthResendMagicLinkRequested(
    AuthResendMagicLinkRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading, clearError: true));

      await _apiService.sendMagicLink(event.email);

      emit(state.copyWith(
        status: AuthStatus.magicLinkSent,
        successMessage: 'Magic link resent to your email!',
        lastSentEmail: event.email,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAuthTokenRefreshRequested(
    AuthTokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    // For now, we'll just check the token validity
    // In a real app, you might implement token refresh logic
    add(const AuthCheckRequested());
  }
}
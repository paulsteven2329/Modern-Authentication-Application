import 'package:equatable/equatable.dart';
import '../../models/models.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  magicLinkSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? successMessage;
  final String? lastSentEmail;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
    this.lastSentEmail,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? successMessage,
    String? lastSentEmail,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      lastSentEmail: lastSentEmail ?? this.lastSentEmail,
    );
  }

  // Convenience getters
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isMagicLinkSent => status == AuthStatus.magicLinkSent;
  bool get hasError => status == AuthStatus.error && errorMessage != null;

  @override
  List<Object?> get props => [
        status,
        user,
        errorMessage,
        successMessage,
        lastSentEmail,
      ];
}
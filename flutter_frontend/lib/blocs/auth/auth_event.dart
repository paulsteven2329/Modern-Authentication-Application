import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;

  const AuthLoginRequested(this.email);

  @override
  List<Object> get props => [email];
}

class AuthMagicLinkVerifyRequested extends AuthEvent {
  final String token;

  const AuthMagicLinkVerifyRequested(this.token);

  @override
  List<Object> get props => [token];
}

class AuthSocialLoginRequested extends AuthEvent {
  final String provider;
  final String? code;

  const AuthSocialLoginRequested(this.provider, {this.code});

  @override
  List<Object?> get props => [provider, code];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthResendMagicLinkRequested extends AuthEvent {
  final String email;

  const AuthResendMagicLinkRequested(this.email);

  @override
  List<Object> get props => [email];
}

class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}
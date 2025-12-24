import 'package:equatable/equatable.dart';

class AuthResponse extends Equatable {
  final String accessToken;
  final User user;

  const AuthResponse({
    required this.accessToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user': user.toJson(),
    };
  }

  @override
  List<Object?> get props => [accessToken, user];
}

class User extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? avatar;
  final bool isEmailVerified;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.avatar,
    this.isEmailVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'isEmailVerified': isEmailVerified,
    };
  }

  @override
  List<Object?> get props => [id, email, name, avatar, isEmailVerified];
}
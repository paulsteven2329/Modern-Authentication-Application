import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:universal_io/io.dart' as universal_io;
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;
  String? _accessToken;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        debugPrint('🚀 Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('✅ Response: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        debugPrint('❌ Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        debugPrint('❌ Error Message: ${error.message}');
        handler.next(error);
      },
    ));
  }

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  // Send magic link
  Future<Map<String, dynamic>> sendMagicLink(String email) async {
    try {
      final response = await _dio.post(
        '/auth/send-magic-link',
        data: {'email': email},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Verify magic link
  Future<AuthResponse> verifyMagicLink(String token) async {
    try {
      final response = await _dio.post(
        '/auth/verify-magic-link',
        data: {'token': token},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get user profile
  Future<User> getUserProfile() async {
    try {
      final response = await _dio.get('/user/profile');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Social login (web only - for mobile we'll use platform-specific implementations)
  Future<AuthResponse> socialLogin(String provider, String code) async {
    try {
      final response = await _dio.post(
        '/auth/$provider/callback',
        data: {'code': code},
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get social auth URL (mainly for web)
  String getSocialAuthUrl(String provider) {
    final redirectUri = kIsWeb 
        ? '${Uri.base.origin}/auth/callback'
        : 'modern-auth://auth/callback';
    
    return '${AppConstants.apiBaseUrl}/auth/$provider?redirect_uri=${Uri.encodeComponent(redirectUri)}';
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        return data['message'] as String;
      }
    }
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try again later.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
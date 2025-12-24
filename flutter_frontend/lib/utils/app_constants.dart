class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3001/api';
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String magicLinkEndpoint = '/auth/magic-link';
  static const String verifyMagicLinkEndpoint = '/auth/verify-magic-link';
  static const String socialLoginEndpoint = '/auth/social';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String userProfileEndpoint = '/user/profile';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Social Login Providers
  static const String googleProvider = 'google';
  static const String facebookProvider = 'facebook';
  static const String twitterProvider = 'twitter';
  static const String githubProvider = 'github';
  
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please log in again.';
  static const String validationError = 'Please check your input and try again.';
  static const String genericError = 'Something went wrong. Please try again.';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String magicLinkSent = 'Magic link sent to your email!';
  static const String logoutSuccess = 'Logged out successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int maxEmailLength = 254;
  static const int maxNameLength = 50;
  
  // Rate Limiting
  static const Duration magicLinkCooldown = Duration(minutes: 1);
  static const int maxLoginAttempts = 5;
  static const Duration loginCooldown = Duration(minutes: 15);
}
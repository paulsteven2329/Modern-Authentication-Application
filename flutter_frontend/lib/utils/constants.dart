class AppConstants {
  static const String apiBaseUrl = 'http://localhost:3001/api';
  
  // For production/different environments
  static const String productionApiUrl = 'https://your-api-domain.com/api';
  
  // App info
  static const String appName = 'Modern Auth Flutter';
  static const String appVersion = '1.0.0';
  
  // Magic link expiration
  static const int magicLinkExpirationMinutes = 15;
  
  // Animation durations
  static const int shortAnimationMs = 200;
  static const int mediumAnimationMs = 400;
  static const int longAnimationMs = 600;
  
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1200;
  
  // Social auth providers
  static const List<String> supportedSocialProviders = [
    'google',
    'facebook',
    'twitter',
  ];
}

class AppStrings {
  static const String welcomeBack = 'Welcome back';
  static const String signInPrompt = 'Sign in to your account using magic link or social login';
  static const String emailAddress = 'Email address';
  static const String enterEmail = 'Enter your email address';
  static const String sendMagicLink = 'Send magic link';
  static const String orContinueWith = 'Or continue with';
  static const String continueWith = 'Continue with';
  static const String checkYourEmail = 'Check your email';
  static const String magicLinkSent = 'We sent a magic link to';
  static const String magicLinkInstructions = 'Click the link in your email to sign in. The link will expire in 15 minutes.';
  static const String resendMagicLink = 'Resend magic link';
  static const String useDifferentEmail = 'Use a different email address';
  static const String securityNotice = 'Security Notice:';
  static const String noPasswordsToRemember = 'No passwords to remember • No forms to fill • Just click and go';
  static const String authenticating = 'Authenticating...';
  static const String welcome = 'Welcome!';
  static const String authFailed = 'Authentication Failed';
  static const String redirectingToDashboard = 'Redirecting to dashboard...';
  static const String redirectingToLogin = 'Redirecting to login page...';
  static const String signOut = 'Sign out';
  static const String profile = 'Profile';
  static const String complete = 'Complete';
  static const String security = 'Security';
  static const String verified = 'Verified';
  static const String status = 'Status';
  static const String active = 'Active';
  static const String authFeatures = 'Authentication Features';
  static const String passwordlessAuth = 'Passwordless Authentication';
  static const String magicLinkLogin = 'Magic Link Login';
  static const String socialAuth = 'Social Authentication';
  static const String jwtSecurity = 'JWT Token Security';
  static const String darkModeSupport = 'Dark Mode Support';
  static const String glassmorphismUI = 'Glassmorphism UI';
  static const String privacyAgreement = 'By continuing, you agree to our terms and privacy policy';
  static const String securePasswordless = 'Secure, passwordless authentication powered by modern technology';
}
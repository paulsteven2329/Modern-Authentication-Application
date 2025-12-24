# Modern Auth Flutter App

A cross-platform authentication application built with Flutter, featuring modern glassmorphism UI design and BLoC state management. This app provides secure authentication with multiple login methods including magic links and social authentication.

## Features

### 🔐 Authentication
- **Magic Link Authentication**: Passwordless login via email
- **Social Login**: Google, Facebook, Twitter, GitHub integration
- **JWT Token Management**: Secure token storage and refresh
- **Auto Login**: Persistent authentication state

### 🎨 Modern UI/UX
- **Glassmorphism Design**: Beautiful glass-effect UI components
- **Dark/Light Theme**: Automatic and manual theme switching
- **Responsive Layout**: Adaptive design for mobile, tablet, and web
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Material 3**: Latest Material Design guidelines

### 🏗️ Architecture
- **BLoC Pattern**: Predictable state management
- **Clean Architecture**: Separation of concerns
- **Reactive Programming**: Stream-based data flow
- **Type Safety**: Full Dart type safety

### 📱 Cross-Platform
- **Mobile**: iOS and Android support
- **Web**: Progressive Web App capabilities
- **Desktop**: Windows, macOS, Linux support

## Tech Stack

- **Framework**: Flutter 3.16+
- **State Management**: flutter_bloc
- **UI Components**: Material 3, Glassmorphism effects
- **Typography**: Google Fonts (Inter)
- **HTTP Client**: dio
- **Local Storage**: shared_preferences, flutter_secure_storage
- **Responsive Design**: responsive_builder
- **Animations**: Flutter built-in animations

## Project Structure

```
lib/
├── blocs/                 # BLoC state management
│   ├── auth/             # Authentication logic
│   └── theme/            # Theme management
├── models/               # Data models
├── screens/              # UI screens
├── services/             # External services
├── utils/                # Utilities and constants
└── widgets/              # Reusable UI components
```

## Getting Started

### Prerequisites

- Flutter SDK 3.16 or higher
- Dart SDK 3.2 or higher
- VS Code or Android Studio

### Backend Setup

Ensure the NestJS backend is running on `http://localhost:3001` with the following endpoints:
- `POST /api/auth/magic-link` - Send magic link
- `POST /api/auth/verify-magic-link` - Verify magic link
- `POST /api/auth/social` - Social authentication
- `GET /api/user/profile` - User profile
- `POST /api/auth/refresh` - Refresh token

### Installation

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Configure environment**:
   - Update `lib/utils/app_constants.dart` with your API endpoints
   - Configure social login credentials if needed

3. **Run the app**:
   ```bash
   # For development (web)
   flutter run -d web-server --web-port 3002
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   
   # For desktop
   flutter run -d linux
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build linux --release
flutter build windows --release
flutter build macos --release
```

## Configuration

### API Configuration

Update the base URL in `lib/utils/app_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:3001/api';
```

### Social Login Setup

1. **Google**: Configure OAuth credentials in platform-specific files
2. **Facebook**: Add Facebook App ID to configurations
3. **Twitter**: Configure API keys in backend
4. **GitHub**: Set up OAuth app credentials

### Theme Customization

Modify colors and styles in `lib/utils/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6366F1);
static const Color secondaryColor = Color(0xFF8B5CF6);
```

## Key Components

### BLoC Architecture

**AuthBloc**: Handles authentication state
- Login/logout operations
- Token management
- User session persistence

**ThemeBloc**: Manages app theming
- Light/dark mode switching
- System theme detection

### Screen Components

**SplashScreen**: Initial loading and auth check
**LoginScreen**: Main authentication interface with magic link and social login
**DashboardScreen**: User dashboard with profile and settings
**MagicLinkCallbackScreen**: Handles magic link verification

### Custom Widgets

**GlassContainer**: Glassmorphism effect container
**SocialLoginButtons**: Branded social authentication buttons
**MagicLinkForm**: Email input with validation
**ThemeToggle**: Dark/light mode switcher

## Development Guidelines

### State Management
- Use BLoC for business logic
- Keep UI widgets stateless when possible
- Implement proper error handling

### UI/UX Standards
- Follow Material 3 guidelines
- Maintain consistent spacing (8px grid)
- Use semantic colors and typography
- Implement proper accessibility

## Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## API Integration

The app integrates with a NestJS backend for authentication services:

- **Magic Link**: Send email with secure login link
- **Social OAuth**: Integration with Google, Facebook, Twitter, GitHub
- **JWT Tokens**: Secure token management and refresh
- **User Profile**: Fetch and update user information

## Security Features

- **Secure Storage**: Sensitive data stored securely
- **Token Refresh**: Automatic token refresh handling
- **Input Validation**: Client and server-side validation
- **HTTPS Only**: Secure communication in production

## Responsive Design

The app adapts to different screen sizes:
- **Mobile**: Optimized for phone screens
- **Tablet**: Enhanced layout for larger screens
- **Desktop**: Full desktop experience
- **Web**: Progressive Web App capabilities

## Performance Optimization

- **Lazy Loading**: Screens loaded on demand
- **Image Optimization**: Efficient asset handling
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Efficient API calls

## Troubleshooting

### Common Issues

1. **Build Issues**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Dependencies Issues**:
   ```bash
   flutter pub upgrade
   flutter pub get
   ```

3. **Web Issues**:
   - Ensure backend CORS is configured
   - Check network connectivity

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Submit a pull request

## License

MIT License - see LICENSE file for details.

---

**Built with ❤️ using Flutter and modern development practices**

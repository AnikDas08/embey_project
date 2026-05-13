# Embeyi

A comprehensive Flutter-based job recruitment and matching platform connecting job seekers with recruiters. Built with a feature-based architecture, real-time communication, and location-based services.

## Features

### For Job Seekers
- Profile creation and management
- Job search and filtering
- Application tracking
- Real-time notifications
- Location-based job recommendations

### For Recruiters
- Company profile management
- Job posting and management
- Candidate search and filtering
- Application review workflow
- Real-time communication with candidates

### Common Features
- User authentication (Sign Up/Sign In)
- Onboarding flow
- Real-time socket-based messaging
- Push notifications
- Image upload and management
- Location services and maps integration
- PDF viewing and document handling

## Tech Stack

### Core Framework
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language (SDK ^3.9.0)

### State Management
- **GetX** - State management, dependency injection, and routing

### Networking & Data
- **Dio** - HTTP client for API calls
- **Socket.IO Client** - Real-time WebSocket communication
- **Pretty Dio Logger** - Network request logging

### UI Components
- **Flutter ScreenUtil** - Responsive design and screen adaptation
- **Google Fonts** - Custom typography
- **Flutter SVG** - SVG image support
- **Cached Network Image** - Image caching
- **Carousel Slider** - Image carousels

### Storage & Persistence
- **Shared Preferences** - Local key-value storage
- **Get Storage** - Fast local storage
- **Path Provider** - File system access

### Location & Maps
- **Geolocator** - Location services
- **Google Maps Flutter** - Map integration
- **Geocoding** - Geocoding and reverse geocoding

### Media & Documents
- **Image Picker** - Image selection from gallery/camera
- **Image Cropper** - Image cropping functionality
- **File Picker** - File selection
- **PDF** - PDF generation and viewing
- **Syncfusion Flutter PDF Viewer** - Advanced PDF viewing
- **Printing** - Document printing

### Utilities
- **Intl** - Internationalization and formatting
- **Intl Phone Field** - Phone number input with country codes
- **Pin Code Fields** - PIN/OTP input fields
- **Flutter HTML** - HTML rendering
- **Flutter Dotenv** - Environment variable management
- **URL Launcher** - Opening URLs and making calls
- **Timeago** - Relative time formatting
- **Permission Handler** - Runtime permissions
- **WebView Flutter** - In-app web browsing
- **Mime** - MIME type detection

## Project Structure

```
lib/
├── app.dart                      # Main app widget
├── main.dart                     # Entry point
├── core/                         # Core functionality
│   ├── component/               # Reusable UI components
│   ├── config/                  # Configuration (DI, routes, themes)
│   ├── services/                # Services (notification, socket, storage)
│   └── utils/                   # Utilities and extensions
└── features/                    # Feature modules
    ├── common/                  # Shared features
    │   ├── auth/               # Authentication (sign up, sign in)
    │   ├── onboarding_screen/  # User onboarding
    │   └── splash/             # Splash screen
    ├── job_seeker/             # Job seeker specific features
    └── recruiter/              # Recruiter specific features
```

## Prerequisites

- Flutter SDK (3.9.0 or higher)
- Dart SDK (3.9.0 or higher)
- Android Studio / Xcode (for mobile development)
- Node.js (if using additional tools)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd embey_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   - Create a `.env` file in the project root
   - Add your API keys and configuration:
     ```
     API_BASE_URL=your_api_base_url
     SOCKET_URL=your_socket_url
     API_KEY=your_api_key
     ```

4. **Generate app icons** (if needed)
   ```bash
   flutter pub run flutter_launcher_icons
   ```

## Running the App

### Android
```bash
flutter run
```

### iOS
```bash
flutter run
```

### Web
```bash
flutter run -d chrome
```

### Specific Device
```bash
flutter devices
flutter run -d <device-id>
```

## Configuration

### Environment Variables
The app uses `flutter_dotenv` for environment configuration. Ensure your `.env` file is properly configured before running the app.

### Permissions
The app requires the following permissions:

**Android (android/app/src/main/AndroidManifest.xml):**
- Internet access
- Camera access
- Storage access (read/write)
- Location access (fine/coarse)

**iOS (ios/Runner/Info.plist):**
- Photo Library Usage Description
- Camera Usage Description
- Location When In Use Usage Description
- Location Always and When In Use Usage Description

## Architecture

The project follows a **feature-based architecture** with clean code principles:

- **Separation of Concerns**: Each feature is self-contained with its own controllers, screens, and widgets
- **Dependency Injection**: Uses GetX for managing dependencies
- **State Management**: GetX reactive state management
- **Reusable Components**: Common UI components in `core/component`
- **Service Layer**: Centralized services for notifications, sockets, and storage

## Build & Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Testing

Run unit tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## Code Quality

The project uses `flutter_lints` for code quality. Run linter:
```bash
flutter analyze
```

## Additional Documentation

- [USAGE_GUIDE.md](USAGE_GUIDE.md) - Detailed usage guide for specific features
- [DESIGN_IMPLEMENTATION_CHECKLIST.md](DESIGN_IMPLEMENTATION_CHECKLIST.md) - Design implementation verification
- [POPUP_DESIGN_SPECS.md](POPUP_DESIGN_SPECS.md) - Popup design specifications
- [POPUP_IMPLEMENTATION_GUIDE.md](POPUP_IMPLEMENTATION_GUIDE.md) - Popup implementation guide

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is private and proprietary.

## Support

For support and questions, please contact the development team.

---

**Version:** 1.0.0+1  
**Flutter SDK:** ^3.9.0  
**Last Updated:** 2025

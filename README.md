# AutoGallery Flutter App

A Flutter mobile application that allows users to pick images from their device gallery and send them to a desktop server.

## 📱 Project Overview

This project is a mobile app built with Flutter that enables users to:
- Select images from their device gallery
- Send selected images to a remote server
- Display the selected image in the app interface

## 🏗️ Project Structure

```
AutoGalleryApp/
├── README.md                    # This file - project documentation
└── my_app/                      # Main Flutter application directory
    ├── lib/                     # Application source code
    │   └── main.dart           # Main application entry point
    ├── android/                 # Android-specific configuration
    ├── ios/                     # iOS-specific configuration  
    ├── web/                     # Web platform configuration
    ├── windows/                 # Windows desktop configuration
    ├── linux/                   # Linux desktop configuration
    ├── macos/                   # macOS desktop configuration
    ├── test/                    # Unit and widget tests
    ├── pubspec.yaml            # Project dependencies and metadata
    ├── pubspec.lock            # Locked dependency versions
    ├── analysis_options.yaml   # Dart code analysis rules
    └── .gitignore              # Git ignore patterns
```

## 📁 Key Folders and Files Explained

### `/lib/` - Application Source Code
- **`main.dart`**: The main entry point of the Flutter app
  - Contains `MyApp` widget (root application widget)
  - Contains `ImageSenderScreen` widget (main screen UI)
  - Implements image picking functionality using `image_picker` package
  - Handles HTTP requests to send images to server using `http` package

### `/android/` - Android Configuration
- Contains Android-specific build configuration
- `app/build.gradle.kts`: Android app build settings
- `app/src/main/AndroidManifest.xml`: Android app permissions and settings

### `/ios/` - iOS Configuration
- Contains iOS-specific build configuration
- `Runner/Info.plist`: iOS app settings and permissions
- Xcode project files for iOS builds

### `/web/` - Web Configuration
- `index.html`: Web app entry point
- `manifest.json`: Progressive Web App configuration
- Icons for web app

### `/windows/`, `/linux/`, `/macos/` - Desktop Configurations
- Platform-specific configuration for desktop builds
- CMake build files for native desktop compilation

### Configuration Files
- **`pubspec.yaml`**: Project metadata and dependencies
  - Defines app name, version, and description
  - Lists required packages (flutter, image_picker, http)
  - Specifies supported platforms
- **`analysis_options.yaml`**: Dart code analysis and linting rules
- **`.gitignore`**: Specifies files to ignore in version control

## 🛠️ Development Progress

### What We Accomplished:

1. **✅ Created Flutter Project Structure**
   - Generated a new Flutter app using `flutter create`
   - Set up cross-platform support (Android, iOS, Web, Desktop)

2. **✅ Implemented Core Functionality**
   - Added image picker functionality to select images from gallery
   - Implemented HTTP client to send images to server
   - Created user interface with image display and upload button

3. **✅ Configured Dependencies**
   - Added `image_picker` package for gallery access
   - Added `http` package for network requests
   - Updated pubspec.yaml with required dependencies

4. **✅ Set Up Development Environment**
   - Installed Flutter and Dart VS Code extensions
   - Configured project for multi-platform development

### Current Status:

- **App Code**: ✅ Complete and functional
- **Dependencies**: ✅ Installed and configured
- **Platform Support**: ✅ Android, iOS, Web, Windows, macOS, Linux
- **Development Setup**: ⚠️ Requires Flutter SDK installation and Developer Mode

## 🚀 Getting Started

### Prerequisites

1. **Flutter SDK**: Download from [flutter.dev](https://docs.flutter.dev/get-started/install)
2. **Developer Mode**: Enable on Windows for symlink support
3. **Android Studio**: For Android development and emulator
4. **VS Code**: With Flutter and Dart extensions (already installed)

### Running the App

1. **Enable Windows Developer Mode**:
   ```powershell
   start ms-settings:developers
   ```
   Toggle "Developer Mode" to ON

2. **Install Flutter SDK**:
   - Download Flutter SDK
   - Extract to `C:\flutter`
   - Add `C:\flutter\bin` to system PATH

3. **Run the App**:
   ```bash
   cd my_app
   flutter pub get          # Install dependencies
   flutter run -d chrome    # Run on web browser
   # OR
   flutter run -d android   # Run on Android emulator
   ```

### Setting Up Server Connection

Update the server URL in `lib/main.dart`:
```dart
final String serverUrl = 'http://YOUR_SERVER_IP:8080/upload';
```

## 🔧 Development Commands

- `flutter pub get` - Install dependencies
- `flutter pub outdated` - Check for dependency updates
- `flutter run` - Run the app
- `flutter build` - Build for production
- `flutter doctor` - Check development environment
- `flutter devices` - List available devices/emulators

## 📦 Dependencies

- **flutter**: UI framework
- **image_picker**: Gallery and camera access
- **http**: Network requests
- **cupertino_icons**: iOS-style icons

## 🎯 Next Steps

1. Set up a local server to receive image uploads
2. Add error handling for network failures
3. Implement image compression before upload
4. Add progress indicators during upload
5. Test on physical devices

## 📄 License

This project is for educational/development purposes.

# Lex Bharat - Setup & Deployment Guide

## Development Environment Setup

### 1. Prerequisites
```bash
# Check Flutter version
flutter --version
# Required: Flutter 3.10.8+, Dart 3.10.8+

# Check Android SDK
sdkmanager --list
# Required: API Level 21+

# Check Xcode (macOS)
xcode-select --print-path
# Required: Xcode 13.0+
```

### 2. Project Setup

```bash
# Navigate to project
cd /Users/aasthasudan/StudioProjects/lex_bharat

# Get dependencies
flutter pub get

# Generate build runner files (if needed)
flutter pub run build_runner build

# Create local.properties for Android
echo "sdk.dir=/path/to/android/sdk" > android/local.properties

# Update cocoapods (macOS/iOS)
cd ios
pod install
cd ..
```

### 3. Environment Configuration

**Create `.env` file in project root:**
```bash
API_BASE_URL=https://api.lexbharat.in/v1
API_TIMEOUT=30
ENABLE_ANALYTICS=true
ENABLE_CRASH_REPORTING=true
DEFAULT_LANGUAGE=en
```

**Update `lib/utils/app_config.dart` with your values:**
```dart
static const String apiBaseUrl = 'https://your-api.com/v1';
static const bool enableAnalytics = true;
```

## Running the App

### Development Mode
```bash
# Run on default device
flutter run

# Run with hot reload
flutter run -v

# Run on specific device
flutter run -d <device_id>

# Run with specific flavor
flutter run --flavor dev

# Profile mode (performance analysis)
flutter run --profile
```

### Debug Configuration
```bash
# Enable verbose logging
flutter run -v

# Debug specific package
flutter run --dart-define=<PACKAGE_NAME>=true

# With device console
flutter run -v 2>&1 | tee debug.log
```

## Testing

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/api_service_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report
lcov --list coverage/lcov.info
```

### Widget Tests
```bash
# Run widget tests
flutter test --flutter-only

# Run integration tests
flutter test integration_test
```

## Building for Production

### Android Build

#### APK Release
```bash
# Generate release APK
flutter build apk --release

# Location: build/app/outputs/flutter-apk/app-release.apk

# Optimize APK size
flutter build apk --release --split-per-abi

# APKs for each ABI:
# - arm64-v8a
# - armeabi-v7a
# - x86_64
```

#### App Bundle (Google Play)
```bash
# Generate App Bundle
flutter build appbundle --release

# Location: build/app/outputs/bundle/release/app-release.aab

# Verify bundle
bundletool build-apks \
  --bundle=app-release.aab \
  --output=app.apks \
  --ks=keystore.jks \
  --ks-pass=pass:password \
  --ks-key-alias=alias_name \
  --key-pass=pass:password
```

#### Keystore Setup
```bash
# Generate keystore
keytool -genkey -v \
  -keystore lexbharat.jks \
  -keyalgorithm RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias lexbharat-key \
  -storepass password123 \
  -keypass password123

# Update build.gradle
# android {
#   ...
#   signingConfigs {
#     release {
#       keyAlias 'lexbharat-key'
#       keyPassword 'password123'
#       storeFile file('lexbharat.jks')
#       storePassword 'password123'
#     }
#   }
#   buildTypes {
#     release {
#       signingConfig signingConfigs.release
#     }
#   }
# }
```

### iOS Build

#### Development Build
```bash
# Build for development
flutter build ios --debug

# Install on connected device
ios-deploy -b build/ios/iphoneos/Runner.app
```

#### Release Build
```bash
# Build for release
flutter build ios --release

# Location: build/ios/iphoneos/Runner.app
```

#### Distribution

**Using Xcode:**
```bash
# Open project
open ios/Runner.xcworkspace

# Product -> Archive
# Window -> Organizer
# Distribute App
```

**Using Command Line:**
```bash
# Export archive
xcodebuild -exportArchive \
  -archivePath Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./ipa

# ExportOptions.plist:
# <dict>
#   <key>signingStyle</key>
#   <string>automatic</string>
#   <key>method</key>
#   <string>app-store</string>
#   <key>stripSwiftSymbols</key>
#   <true/>
# </dict>
```

## App Store Deployment

### Google Play Store

1. **Create Developer Account**
   - Visit https://play.google.com/console
   - Pay one-time fee ($25)

2. **Prepare Store Listing**
   - App title, description
   - Screenshots (min 2, max 8)
   - Feature graphic (1024x500)
   - Icon (512x512)
   - Video preview (optional)

3. **App Content**
   - Content rating questionnaire
   - Target audience selection
   - Content guidelines compliance

4. **Privacy Policy**
   - Create comprehensive privacy policy
   - Host at https://lexbharat.in/privacy
   - Update in app/build.gradle

5. **Upload**
   ```bash
   # Upload App Bundle via Console
   # Or use API:
   play --package_name=com.lexbharat.app \
        --in=build/app/outputs/bundle/release/app-release.aab
   ```

6. **Release**
   - Internal testing → Closed testing → Open testing → Production
   - Staged rollout (5% → 10% → 50% → 100%)

### Apple App Store

1. **Create Developer Account**
   - Visit https://developer.apple.com
   - Pay annual fee ($99/year)

2. **Create App**
   - App Store Connect
   - Create new app
   - Bundle ID: com.lexbharat.app

3. **Prepare for Submission**
   - Screenshots (min 2 per device)
   - App Preview video (optional)
   - Description (max 170 chars)
   - Keywords (max 100 chars)
   - Support URL
   - Privacy Policy URL

4. **Build & Upload**
   ```bash
   # Build and upload
   flutter build ios --release
   
   # Or use Xcode
   open ios/Runner.xcworkspace
   ```

5. **Review Compliance**
   - Privacy Policy
   - App functionality
   - Content appropriateness

6. **Submit for Review**
   - App Store Connect
   - Build ready to submit
   - Submit for Review

## Continuous Integration/Deployment

### GitHub Actions

**Create `.github/workflows/build.yml`:**
```yaml
name: Build & Deploy

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  build-apk:
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: app-release.apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    runs-on: macos-latest
    needs: test
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build ios --release
```

## Monitoring & Analytics

### Firebase Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase
firebase init

# Configure Crashlytics
firebase add analytics
firebase add crashes
```

### App Metrics to Track

- User registrations
- Feature usage
- Crash reports
- API response times
- Offline usage patterns
- Form completion rates

## Performance Optimization

### Before Release

```bash
# Analyze bundle size
flutter build appbundle --analyze-size

# Profile performance
flutter run --profile

# Check memory usage
flutter run --profile --trace-skia

# Generate profiling data
dart --profile trace.dart > trace.json
```

### Recommended Optimizations

- Lazy load screens
- Cache API responses (7 days)
- Compress images to max 1MB
- Minimize font file size
- Remove unused dependencies
- Code shrinking for Android
- Tree shaking for unused code

## Versioning Strategy

**Version Format:** `major.minor.patch+buildNumber`

Example: `1.0.0+1`

**Update `pubspec.yaml`:**
```yaml
version: 1.0.0+1

# For next release:
# version: 1.1.0+2  (minor feature addition)
# version: 1.0.1+2  (bug fix)
# version: 2.0.0+3  (major update)
```

**Update Android:**
```gradle
android {
    defaultConfig {
        versionCode 1
        versionName "1.0.0"
    }
}
```

**Update iOS:**
```
MARKETING_VERSION = 1.0.0
CURRENT_PROJECT_VERSION = 1
```

## Rollback Procedure

If critical issue detected:

1. **Immediate Actions**
   - Pause rollout (50% → 5%)
   - Notify users of issue
   - Create hotfix branch

2. **Fix & Re-release**
   ```bash
   git checkout -b hotfix/critical-issue
   # Fix the issue
   git commit -m "Fix critical issue"
   # Increment version
   # Build & deploy again
   ```

3. **Post-Mortem**
   - Document what went wrong
   - Improve testing
   - Update deployment checklist

## Maintenance

### Regular Tasks

- **Weekly**: Monitor crash reports, check analytics
- **Bi-weekly**: Update dependencies
- **Monthly**: Security audit, performance review
- **Quarterly**: Feature evaluation, technical debt

### Update Dependencies
```bash
# Check for updates
flutter pub outdated

# Get latest
flutter pub upgrade

# Run tests after update
flutter test
```

## Support & Documentation

- **User Documentation**: https://lexbharat.in/docs
- **Developer Documentation**: https://github.com/lexbharat/dev-docs
- **Issue Tracking**: https://github.com/lexbharat/issues
- **Support Email**: support@lexbharat.in

---

**Last Updated:** March 16, 2026
**Maintained by:** Lex Bharat Team


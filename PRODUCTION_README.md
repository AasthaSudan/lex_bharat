# Lex Bharat - Legal Rights Assistant App

A comprehensive Flutter application designed to democratize legal knowledge and empower underserved communities with access to legal rights information, procedures, and support systems.

## Overview

Lex Bharat is a mobile-first legal rights assistant that provides:
- Educational content on various legal rights (labor, property, women's, consumer, child, disability, minority rights)
- AI-powered legal advisor chatbot
- Form filling assistance and templates
- Resource locator for legal aid organizations
- Complaint/incident reporting system
- Secure document storage
- Offline functionality
- Multi-language support (15+ Indian languages)
- Voice-based interaction for accessibility

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── main_production.dart               # Production app configuration
├── models/                            # Data models
│   ├── user.dart
│   ├── message.dart
│   ├── topic.dart
│   ├── form.dart
│   ├── resource.dart
│   ├── document.dart
│   ├── report.dart
│   ├── rights_category.dart
│   ├── legal_resource.dart
│   ├── complaint_report.dart
│   ├── legal_procedure.dart
│   └── offline_sync.dart
├── services/                          # Business logic services
│   ├── api_service_impl.dart
│   ├── storage_service_impl.dart
│   ├── voice_service_impl.dart
│   ├── pdf_service_impl.dart
│   ├── location_service_impl.dart
│   └── sync_service_impl.dart
├── providers/                         # State management (Riverpod)
│   ├── app_provider.dart
│   └── rights_provider.dart
├── screens/                           # UI Screens
│   ├── splash_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── onboarding/
│   │   ├── language_selection_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── permissions_screen.dart
│   │   └── profile_setup_screen.dart
│   ├── learn/
│   │   ├── categories_screen.dart
│   │   ├── topics_list_screen.dart
│   │   ├── topic_details_screen.dart
│   │   ├── quiz_screen.dart
│   │   └── quiz_results_screen.dart
│   ├── chat/
│   │   ├── chat_screen.dart
│   │   └── widgets/
│   ├── forms/
│   │   ├── form_categories_screen.dart
│   │   ├── form_details_screen.dart
│   │   ├── form_filling_wizard_screen.dart
│   │   ├── form_review_screen.dart
│   │   ├── form_success_screen.dart
│   │   └── widgets/
│   ├── resources/
│   │   ├── resources_home_screen.dart
│   │   ├── resource_details_screen.dart
│   │   └── widgets/
│   ├── report/
│   │   ├── report_categories_screen.dart
│   │   ├── report_details_screen.dart
│   │   ├── add_evidence_screen.dart
│   │   └── review_submit_screen.dart
│   ├── documents/
│   │   ├── my_documents_screen.dart
│   │   └── document_viewer_screen.dart
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       └── settings_screen.dart
├── widgets/                           # Reusable widgets
│   ├── common/
│   │   ├── custom_button.dart
│   │   ├── custom_text_field.dart
│   │   ├── loading_indicator.dart
│   │   └── custom_widgets_impl.dart
│   └── custom/
│       ├── voice_button.dart
│       ├── step_progress_indicator.dart
│       ├── review_section.dart
│       └── custom_widgets_impl.dart
├── utils/                             # Utility classes
│   ├── constants.dart
│   ├── app_colors.dart
│   ├── text_styles.dart
│   ├── validators.dart
│   ├── helpers.dart
│   └── app_config.dart
├── routes/
│   └── app_routes.dart                # Route configuration
└── assets/
    ├── images/
    ├── icons/
    ├── lottie/
    └── audio/
```

## Key Features Implementation

### 1. Rights Education Module
- **Categories**: Labor, Property, Women's, Consumer, Child, Disability, Minority rights
- **Learning Materials**: Text, Audio (voice-guided), Video, Infographics
- **Interactive Quizzes**: Test understanding with scenario-based quizzes
- **Progress Tracking**: Gamified learning with badges and scores

### 2. Legal Procedure Guide
- **Step-by-Step Walkthroughs**: 
  - Police Complaint (FIR) filing
  - Divorce procedures
  - Property registration
  - Court appearance
  - Document registration
- **Voice-Guided Navigation**: Complete voice support for illiterate users
- **Document Checklists**: Required documents for each procedure

### 3. Form Filling Assistant
- **Camera Integration**: Scan government forms
- **Smart Field Explanation**: Simple language explanations
- **Voice-to-Text**: Fill forms using voice
- **Template Library**: Pre-made templates for common legal documents
- **Form Validation**: Prevent mistakes before submission

### 4. AI Legal Advisor Chatbot
- **Question Answering**: Query-based legal information
- **Case Assessment**: Evaluate situation and suggest actions
- **Contextual Understanding**: Remember conversation history
- **Multi-Language**: Switch languages during conversation
- **Preliminary Case Strength**: Estimate likelihood of success

### 5. Resource Connector
- **Legal Aid Database**: Find free legal aid organizations
- **Location-Based**: Nearest police stations, courts, legal aid offices
- **Eligibility Checker**: Automated welfare scheme eligibility
- **Ratings & Reviews**: Community feedback on services
- **Emergency Contacts**: Hotlines for immediate assistance

### 6. Documentation & Evidence Helper
- **Evidence Guidance**: What evidence needed for different cases
- **Secure Storage**: End-to-end encrypted document storage
- **OCR Scanning**: Convert paper documents to digital
- **Incident Logger**: Voice diary for recording incidents
- **Export as PDF**: Generate legal-ready documents

### 7. Court Navigator
- **Court Information**: Location, hours, contact details
- **Court Preparation**: What to expect, how to address judges
- **Hearing Reminders**: Calendar integration with notifications
- **Pre-Hearing Checklist**: Documents and preparation guide

### 8. Complaint System
- **Official Complaint Helper**: Guided formal complaint creation
- **Anonymous Reporting**: Option for confidential reporting
- **Status Tracking**: Follow complaint progress
- **Escalation Guidance**: What to do if no response

### 9. Offline Capabilities
- **Offline Database**: Core legal knowledge available offline
- **Form Templates**: All form templates cached locally
- **Voice Assistant**: Works without internet
- **Periodic Sync**: Automatic sync when connection available
- **2G Support**: Optimized for low bandwidth

### 10. Advanced Features
- **Financial Guidance**: Lawyer fees calculator, free service eligibility
- **Success Stories**: Real case examples (anonymized)
- **Community FAQ**: Answers from similar users
- **Wellness Tracking**: Legal literacy progress gamification
- **Rights Violation Analytics**: Heat maps for authorities

## Technology Stack

### Frontend
- **Flutter 3.x**: Cross-platform mobile development
- **Dart**: Programming language
- **GetX/Riverpod**: State management
- **Google Fonts**: Typography

### Backend & Services
- **REST API**: Backend communication
- **Firebase**: Analytics, push notifications (optional)
- **Hive**: Local database
- **SQLite**: Structured data storage

### Libraries & Packages
```yaml
flutter_riverpod: ^3.3.1        # State management
google_fonts: ^8.0.2            # Typography
lottie: ^3.3.2                  # Animations
speech_to_text: ^7.3.0          # Voice input
flutter_tts: ^4.2.5             # Text-to-speech
http: ^1.1.2                    # Network requests
hive: ^2.2.3                    # Local storage
hive_flutter: ^1.1.0            # Hive Flutter integration
shared_preferences: ^2.2.2      # Simple key-value storage
intl: ^0.20.2                   # Internationalization
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.10.8)
- Dart SDK (^3.10.8)
- Android Studio / Xcode
- Node.js (for backend, optional)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/lex_bharat.git
   cd lex_bharat
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files (if using intl)**
   ```bash
   flutter gen-l10n
   ```

4. **Run the app**
   ```bash
   # Development
   flutter run
   
   # Production
   flutter run --release
   
   # Specific device
   flutter run -d <device_id>
   ```

## API Integration

### Base Configuration
- **Base URL**: `https://api.lexbharat.in/v1`
- **Timeout**: 30 seconds
- **Authentication**: Bearer token

### Key Endpoints

#### Authentication
- `POST /auth/register` - User registration
- `POST /auth/login` - User login
- `POST /auth/refresh` - Refresh token

#### Rights & Learning
- `GET /rights/categories` - All rights categories
- `GET /rights/categories/{id}/topics` - Topics in category
- `GET /rights/topics/{id}` - Topic details
- `POST /learning/track-progress` - Track learning progress

#### Forms
- `GET /forms/categories` - Form categories
- `GET /forms/{id}` - Form details
- `POST /forms/submit` - Submit form

#### Resources
- `GET /resources?type=...&location=...` - Search resources
- `GET /resources/{id}` - Resource details
- `POST /resources/review` - Add review

#### Complaints
- `POST /complaints` - File complaint
- `GET /complaints/{id}` - Get complaint status
- `PATCH /complaints/{id}` - Update complaint

#### Documents
- `POST /documents/upload` - Upload document
- `GET /documents` - List user documents
- `GET /documents/{id}/download` - Download document

## Data Models

### User Model
```dart
User(
  id: String,
  name: String,
  email: String,
  phone: String,
  language: String,
  state: String,
  city: String,
  createdAt: DateTime,
)
```

### Rights Category Model
```dart
RightsCategory(
  id: String,
  title: String,
  description: String,
  icon: String,
  topics: List<RightsTopic>,
  progressPercentage: int,
)
```

### Complaint Report Model
```dart
ComplaintReport(
  id: String,
  userId: String,
  title: String,
  description: String,
  violationType: String,
  status: String,
  evidenceUrls: List<String>,
  incidentDate: DateTime,
  isAnonymous: bool,
  severity: double,
)
```

## Offline Sync Strategy

### Sync Flow
1. User performs action (create complaint, upload document)
2. Data saved to local Hive database
3. UI shows "Syncing..." indicator
4. When connection available:
   - App detects internet
   - Reads pending sync queue
   - Uploads data to server
   - Updates local status
   - Clears sync queue

### Conflict Resolution
- Server timestamp takes precedence
- User notified of conflicts
- Option to retry or discard local changes

## Security Measures

- **End-to-End Encryption**: Documents encrypted before storage
- **Secure Storage**: Sensitive data in encrypted Hive boxes
- **Token Management**: Secure token refresh mechanism
- **Input Validation**: All inputs validated before processing
- **HTTPS Only**: All API calls over HTTPS
- **Password Hashing**: Bcrypt for passwords
- **Permission Handling**: Proper Android/iOS permissions

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test --dart-define=test.use_live_server=false
```

### Integration Tests
```bash
flutter test integration_test
```

## Deployment

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
cd ios
xcode -workspace Runner.xcworkspace -scheme Runner -config Release
```

## Performance Optimization

- **Lazy Loading**: Images and content loaded on-demand
- **Caching**: API responses cached for 7 days
- **Code Splitting**: Modular screen loading
- **Image Compression**: Automatic image optimization
- **Database Indexing**: Optimized Hive queries

## Accessibility

- **Voice Navigation**: Full voice support
- **Text Scaling**: Responsive typography
- **High Contrast**: Dark mode support
- **Large Touch Targets**: Minimum 48x48 dp buttons
- **Screen Reader Support**: Semantic labels

## Localization

Supported Languages:
- English (en)
- Hindi (hi)
- Tamil (ta)
- Telugu (te)
- Kannada (ka)
- Malayalam (ml)
- Bengali (bn)
- Gujarati (gu)
- Marathi (mr)
- Odia (or)
- Punjabi (pa)
- Urdu (ur)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@lexbharat.in or visit www.lexbharat.in

## Roadmap

- [ ] AI-powered case assessment
- [ ] Video consultations with lawyers
- [ ] Blockchain-based document verification
- [ ] Integration with government databases
- [ ] ML-based rights violation detection
- [ ] Community moderation system
- [ ] Wearable app integration

## Acknowledgments

- Indian legal framework and laws
- NGO partners for resources
- Community feedback and testing
- Open-source Flutter community

---

**Made with ❤️ for underserved communities**


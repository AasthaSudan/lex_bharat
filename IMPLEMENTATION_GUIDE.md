# Lex Bharat - Legal Rights Assistant

A comprehensive Flutter app that democratizes legal knowledge for underserved communities in India, providing accessible legal information in multiple languages.

## 🎯 Core Features

### 1. **Rights Education Module (Learn Tab)**
- **Know Your Rights Library** - Interactive learning across 6 major categories:
  - Labor Rights (minimum wage, working hours, safety)
  - Property Rights (ownership, rental, inheritance)
  - Women's Rights (protection, harassment prevention)
  - Consumer Rights (refunds, fraud protection)
  - Child Rights (education, protection)
  - Digital Rights (privacy, cyber safety)

- **Interactive Voice Learning**
  - Audio lessons in local languages
  - Real-life scenario-based learning
  - Visual infographics for low-literacy users
  - Quizzes to test understanding

- **Learning Progress Tracking**
  - Track completion percentage
  - Quiz scores and performance analytics
  - Badges and gamification

### 2. **AI Legal Advisor Chatbot (Chat Tab)**
- **Multi-turn Conversations** - Context-aware responses
- **Case Assessment** - Preliminary evaluation of legal situations
- **Offline Support** - Works with cached responses when offline
- **Multi-language** - Responds in English and Hindi
- **Simple Language** - Explains complex laws in everyday terms

### 3. **Smart Form Filling Assistant (Forms Tab)**
- **Government Form Templates** - Pre-built forms for:
  - Filing Police Complaint (FIR)
  - Right to Information (RTI) Request
  - Tenant Eviction Notice
  - Legal Notices and Complaints

- **Smart Field Helper**
  - Voice-to-text input
  - Auto-validation
  - Helpful hints for each field
  - Export to PDF

### 4. **Resource Connector**
- **Legal Aid Network** - Find nearby legal aid organizations
- **Emergency Contacts** - 24/7 helpline numbers
- **Government Schemes** - Eligibility checking
- **Success Stories** - Real cases that got justice

### 5. **Offline-First Architecture**
- **Local Storage** - All content cached with Hive
- **Sync Queue** - Pending actions sync when online
- **Low Bandwidth Mode** - Works on slow connections
- **SMS Fallback** - Critical info via SMS when needed

### 6. **Multilingual Support**
- **English & Hindi** - Full translation of all content
- **Simple Language** - Legal jargon explained plainly
- **Voice Output** - Text-to-speech for non-readers

## 📦 Technology Stack

```yaml
- Flutter 3.x with Material Design 3
- Riverpod for state management
- Hive for local database (offline)
- Supabase for cloud (optional)
- Groq AI for legal advice
- Google Fonts for typography
- Speech-to-text & TTS for voice
```

## 🚀 Getting Started

### Prerequisites
```bash
flutter --version  # 3.x or higher
dart --version     # 3.x or higher
```

### Setup

1. **Clone and Install**
```bash
cd lex_bharat
flutter pub get
```

2. **Configure Environment**
Create `.env` file:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
GROQ_API_KEY=your_groq_api_key
```

3. **Run App**
```bash
flutter run -d macos  # or your target device
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App initialization
├── app.dart                  # Theme configuration
├── screens/                  # UI Screens
│   ├── splash_screen.dart
│   ├── home/                 # Home tab
│   ├── learn/                # Learning tab
│   ├── chat/                 # Chat tab  
│   ├── forms/                # Forms tab
│   ├── profile/              # Profile tab
│   └── onboarding/           # Language selection
├── providers/                # Riverpod providers
│   ├── app_provider.dart     # Theme, language
│   ├── learning_provider.dart
│   ├── chat_provider.dart
│   └── auth_provider.dart
├── models/                   # Data models
│   ├── learning_models.dart
│   ├── message.dart
│   ├── user.dart
│   └── topic.dart
├── services/                 # Business logic
│   ├── ai_service.dart       # Groq AI integration
│   ├── learning_service.dart
│   ├── database_service.dart # Hive operations
│   └── storage_service.dart
├── utils/                    # Utilities
│   ├── colors.dart          # AppColors theme
│   ├── constants.dart
│   └── helpers.dart
├── widgets/                  # Reusable widgets
│   ├── common/
│   └── custom/
└── l10n/                     # Localization
    ├── app_en.arb
    └── app_hi.arb

assets/
├── data/
│   ├── legal_content.json    # Learning content
│   ├── form_templates.json   # Form templates
│   └── resources.json        # Emergency contacts
└── images/
    └── ...
```

## 🎓 Key Data Models

### Learning System
- **Category** - Rights categories (labor, property, women, etc.)
- **Topic** - Specific topics within categories
- **Lesson** - Individual learning units with content
- **Quiz** - Assessment with scoring
- **LearningProgress** - User's learning journey

### Chat System
- **ChatMessage** - Individual message
- **ChatSession** - Conversation history
- **CaseAssessment** - AI preliminary case evaluation

### Forms System
- **FormTemplate** - Pre-built form structure
- **FormField** - Individual form fields
- **FormResponse** - User's submitted form data

## 🔧 Core Services

### AI Service
```dart
// Get legal advice with multi-turn context
await aiService.getLegalAdvice(
  question,
  language: 'hi',
  conversationHistory: messages,
);

// Assess a legal case
await aiService.assessCase(
  situationDescription,
  language: 'en',
);
```

### Learning Service
```dart
// Load categories and topics
final categories = await LearningService.getCategories();
final topics = await LearningService.getTopicsByCategory(categoryId);
final lessons = await LearningService.getLessonsByTopic(topicId);

// Track progress
await LearningService.saveLearningProgress(progress);
```

### Database Service (Hive)
```dart
// Initialize offline storage
await DatabaseService.initHive();

// Save/retrieve data
await DatabaseService.saveChatSession(sessionId, data);
final messages = await DatabaseService.getChatSession(sessionId);

// Manage sync queue for offline changes
final pending = await DatabaseService.getPendingSyncQueue();
```

## 🌐 Localization

The app supports English and Hindi with complete translations:

- **app_en.arb** - English strings
- **app_hi.arb** - Hindi strings

### Adding New Languages
1. Create `app_xx.arb` (where xx = language code)
2. Add to `pubspec.yaml`:
```yaml
flutter:
  generate: true
  
l10n:
  arb-dir: lib/l10n
  template-arb-file: app_en.arb
```
3. Run: `flutter gen-l10n`

## 🎨 Design System

### Colors (AppColors)
- **Primary** - #3B82F6 (Blue)
- **Success** - #10B981 (Green)
- **Warning** - #F59E0B (Amber)
- **Error** - #EF4444 (Red)
- **Text Primary** - #111827 (Dark)
- **Text Secondary** - #6B7280 (Gray)

### Typography
- Font Family: Inter (Google Fonts)
- Headlines: Bold, -0.5 letter spacing
- Body: Regular, 16px, line-height 1.5

## 💾 Offline Architecture

### Storage Layers
1. **Hive Local Database** - Fast, encrypted storage
   - Chat sessions and messages
   - Learning progress
   - Form responses
   - Sync queue for offline changes

2. **SharedPreferences** - User preferences
   - Language selection
   - Theme (dark/light)
   - User settings

3. **Cloud Sync** - When online
   - Sync pending changes to Supabase
   - Fetch latest content updates
   - Backup user data

## 🔐 Security & Privacy

- **Encrypted Local Storage** - Hive with encryption
- **No Firebase** - Uses Supabase or local storage
- **Minimal Permissions** - Only required features
- **User Data Control** - Local first, cloud optional
- **Anonymous Mode** - Option to use without login

## 📱 Supported Platforms

- ✅ Android 8.0+
- ✅ iOS 11.0+
- ⏳ Web (in progress)
- ⏳ Desktop (planned)

## 📊 User Tracking & Analytics

Optional engagement tracking:
- Learning completion rates
- Most accessed topics
- Chat query patterns (anonymized)
- Feature usage analytics

## 🐛 Troubleshooting

### Issues & Solutions

**Q: App says "Offline Mode"**
A: This is normal when Groq API is not configured. Local responses work fine.

**Q: Messages not saving**
A: Hive box might be corrupted. Try:
```dart
await DatabaseService.clearAllData();
await DatabaseService.initHive();
```

**Q: Language not changing**
A: Restart app after selection. Language provider needs rebuild.

## 📚 Resources for Development

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Indian Legal Resources](https://nalsa.gov.in)
- [Groq API Docs](https://console.groq.com/docs)

## 🤝 Contributing

Guidelines for contributions:
1. Follow existing code style
2. Add tests for new features
3. Update documentation
4. Test on both Android and iOS

## 📄 License

MIT License - See LICENSE file

## 👥 Credits

- **Design**: Based on Jobee app design system
- **Content**: Legal knowledge from NALSA and government resources
- **AI**: Powered by Groq's language models
- **Community**: Built for underserved communities in India

## 📞 Support

- **Email**: support@lexbharat.com
- **Helpline**: 1800-11-4001 (National Legal Services)
- **GitHub Issues**: Report bugs here

---

**Last Updated**: April 2026
**Version**: 1.0.0
**Status**: Production Ready ✨


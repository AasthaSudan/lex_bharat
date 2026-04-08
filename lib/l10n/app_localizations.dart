import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get tabLearn;

  /// No description provided for @tabChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tabChat;

  /// No description provided for @tabForms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get tabForms;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @howCanIHelpText.
  ///
  /// In en, this message translates to:
  /// **'How can I help you today?'**
  String get howCanIHelpText;

  /// No description provided for @askLegalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a legal question...'**
  String get askLegalQuestion;

  /// No description provided for @emergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Emergency Help'**
  String get emergencyHelp;

  /// No description provided for @emergencyHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Helplines • Police • Women'**
  String get emergencyHelpSubtitle;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @learnRights.
  ///
  /// In en, this message translates to:
  /// **'Learn\nRights'**
  String get learnRights;

  /// No description provided for @lawsExplained.
  ///
  /// In en, this message translates to:
  /// **'Laws explained simply'**
  String get lawsExplained;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI\nAssistant'**
  String get aiAssistant;

  /// No description provided for @askAnyLegalQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask any legal question'**
  String get askAnyLegalQuestion;

  /// No description provided for @ipcBnsConverter.
  ///
  /// In en, this message translates to:
  /// **'IPC↔BNS\nConverter'**
  String get ipcBnsConverter;

  /// No description provided for @newLawSectionFinder.
  ///
  /// In en, this message translates to:
  /// **'New law section finder'**
  String get newLawSectionFinder;

  /// No description provided for @rightsQuiz.
  ///
  /// In en, this message translates to:
  /// **'Rights\nQuiz'**
  String get rightsQuiz;

  /// No description provided for @testYourKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge'**
  String get testYourKnowledge;

  /// No description provided for @fillForms.
  ///
  /// In en, this message translates to:
  /// **'Fill\nForms'**
  String get fillForms;

  /// No description provided for @firRtiLegalAid.
  ///
  /// In en, this message translates to:
  /// **'FIR, RTI, Legal Aid'**
  String get firRtiLegalAid;

  /// No description provided for @findHelp.
  ///
  /// In en, this message translates to:
  /// **'Find\nHelp'**
  String get findHelp;

  /// No description provided for @legalAidNearYou.
  ///
  /// In en, this message translates to:
  /// **'Legal aid near you'**
  String get legalAidNearYou;

  /// No description provided for @helplinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Helplines'**
  String get helplinesTitle;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get greetingNight;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Assistant'**
  String get chatTitle;

  /// No description provided for @chatSubtitleThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get chatSubtitleThinking;

  /// No description provided for @chatSubtitlePowered.
  ///
  /// In en, this message translates to:
  /// **'Powered by Groq AI'**
  String get chatSubtitlePowered;

  /// No description provided for @clearChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation?'**
  String get clearChatTitle;

  /// No description provided for @clearChatContent.
  ///
  /// In en, this message translates to:
  /// **'This will clear your chat history with the AI assistant.'**
  String get clearChatContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @typingIndicator.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get typingIndicator;

  /// No description provided for @askAnythingHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything...'**
  String get askAnythingHint;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @exportNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No chat history to export.'**
  String get exportNoHistory;

  /// No description provided for @chooseLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguageTitle;

  /// No description provided for @chooseLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get chooseLanguageSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

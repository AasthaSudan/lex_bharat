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

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lex Bharat'**
  String get welcome;

  /// No description provided for @yourLegalRightsInYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Your legal rights, in your language'**
  String get yourLegalRightsInYourLanguage;

  /// No description provided for @laborRights.
  ///
  /// In en, this message translates to:
  /// **'Labor Rights'**
  String get laborRights;

  /// No description provided for @propertyRights.
  ///
  /// In en, this message translates to:
  /// **'Property Rights'**
  String get propertyRights;

  /// No description provided for @womenRights.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Rights'**
  String get womenRights;

  /// No description provided for @consumerRights.
  ///
  /// In en, this message translates to:
  /// **'Consumer Rights'**
  String get consumerRights;

  /// No description provided for @childRights.
  ///
  /// In en, this message translates to:
  /// **'Child Rights'**
  String get childRights;

  /// No description provided for @disabilityRights.
  ///
  /// In en, this message translates to:
  /// **'Disability Rights'**
  String get disabilityRights;

  /// No description provided for @minorityRights.
  ///
  /// In en, this message translates to:
  /// **'Minority Rights'**
  String get minorityRights;

  /// No description provided for @minimumWage.
  ///
  /// In en, this message translates to:
  /// **'Minimum Wage'**
  String get minimumWage;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHours;

  /// No description provided for @workplaceSafety.
  ///
  /// In en, this message translates to:
  /// **'Workplace Safety'**
  String get workplaceSafety;

  /// No description provided for @termination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get termination;

  /// No description provided for @landOwnership.
  ///
  /// In en, this message translates to:
  /// **'Land Ownership'**
  String get landOwnership;

  /// No description provided for @rentalAgreements.
  ///
  /// In en, this message translates to:
  /// **'Rental Agreements'**
  String get rentalAgreements;

  /// No description provided for @inheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance'**
  String get inheritance;

  /// No description provided for @domesticViolence.
  ///
  /// In en, this message translates to:
  /// **'Domestic Violence'**
  String get domesticViolence;

  /// No description provided for @dowry.
  ///
  /// In en, this message translates to:
  /// **'Dowry'**
  String get dowry;

  /// No description provided for @workplaceHarassment.
  ///
  /// In en, this message translates to:
  /// **'Workplace Harassment'**
  String get workplaceHarassment;

  /// No description provided for @productQuality.
  ///
  /// In en, this message translates to:
  /// **'Product Quality'**
  String get productQuality;

  /// No description provided for @refunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get refunds;

  /// No description provided for @fraudProtection.
  ///
  /// In en, this message translates to:
  /// **'Fraud Protection'**
  String get fraudProtection;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @childLabor.
  ///
  /// In en, this message translates to:
  /// **'Child Labor'**
  String get childLabor;

  /// No description provided for @childProtection.
  ///
  /// In en, this message translates to:
  /// **'Child Protection'**
  String get childProtection;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @employmentQuotas.
  ///
  /// In en, this message translates to:
  /// **'Employment Quotas'**
  String get employmentQuotas;

  /// No description provided for @knowYourRights.
  ///
  /// In en, this message translates to:
  /// **'Know Your Rights'**
  String get knowYourRights;

  /// No description provided for @interactiveVoiceLearning.
  ///
  /// In en, this message translates to:
  /// **'Interactive Voice Learning'**
  String get interactiveVoiceLearning;

  /// No description provided for @visualExplainers.
  ///
  /// In en, this message translates to:
  /// **'Visual Explainers'**
  String get visualExplainers;

  /// No description provided for @realLifeScenarios.
  ///
  /// In en, this message translates to:
  /// **'Real-Life Scenarios'**
  String get realLifeScenarios;

  /// No description provided for @quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// No description provided for @successStories.
  ///
  /// In en, this message translates to:
  /// **'Success Stories'**
  String get successStories;

  /// No description provided for @filePolicComplaint.
  ///
  /// In en, this message translates to:
  /// **'File Police Complaint'**
  String get filePolicComplaint;

  /// No description provided for @getLegalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Get Legal Documents'**
  String get getLegalDocuments;

  /// No description provided for @fileDivorce.
  ///
  /// In en, this message translates to:
  /// **'File for Divorce'**
  String get fileDivorce;

  /// No description provided for @propertyRegistration.
  ///
  /// In en, this message translates to:
  /// **'Property Registration'**
  String get propertyRegistration;

  /// No description provided for @courtPreparation.
  ///
  /// In en, this message translates to:
  /// **'Court Preparation'**
  String get courtPreparation;

  /// No description provided for @bailApplication.
  ///
  /// In en, this message translates to:
  /// **'Bail Application'**
  String get bailApplication;

  /// No description provided for @voiceGuidedNavigation.
  ///
  /// In en, this message translates to:
  /// **'Voice-Guided Navigation'**
  String get voiceGuidedNavigation;

  /// No description provided for @documentChecklist.
  ///
  /// In en, this message translates to:
  /// **'Document Checklist'**
  String get documentChecklist;

  /// No description provided for @smartFormHelper.
  ///
  /// In en, this message translates to:
  /// **'Smart Form Helper'**
  String get smartFormHelper;

  /// No description provided for @scanGovForms.
  ///
  /// In en, this message translates to:
  /// **'Scan Government Forms'**
  String get scanGovForms;

  /// No description provided for @voiceToText.
  ///
  /// In en, this message translates to:
  /// **'Voice-to-Text'**
  String get voiceToText;

  /// No description provided for @templateLibrary.
  ///
  /// In en, this message translates to:
  /// **'Template Library'**
  String get templateLibrary;

  /// No description provided for @legalNoticeTemplates.
  ///
  /// In en, this message translates to:
  /// **'Legal Notice Templates'**
  String get legalNoticeTemplates;

  /// No description provided for @complaintLetters.
  ///
  /// In en, this message translates to:
  /// **'Complaint Letters'**
  String get complaintLetters;

  /// No description provided for @affidavitSamples.
  ///
  /// In en, this message translates to:
  /// **'Affidavit Samples'**
  String get affidavitSamples;

  /// No description provided for @applicationTemplates.
  ///
  /// In en, this message translates to:
  /// **'Application Templates'**
  String get applicationTemplates;

  /// No description provided for @languageSupport.
  ///
  /// In en, this message translates to:
  /// **'Language Support'**
  String get languageSupport;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask Anything'**
  String get askAnything;

  /// No description provided for @caseAssessment.
  ///
  /// In en, this message translates to:
  /// **'Case Assessment'**
  String get caseAssessment;

  /// No description provided for @contextualUnderstanding.
  ///
  /// In en, this message translates to:
  /// **'Contextual Understanding'**
  String get contextualUnderstanding;

  /// No description provided for @tellUsYourSituation.
  ///
  /// In en, this message translates to:
  /// **'Tell us your situation'**
  String get tellUsYourSituation;

  /// No description provided for @identifyingRelevantLaws.
  ///
  /// In en, this message translates to:
  /// **'Identifying relevant laws'**
  String get identifyingRelevantLaws;

  /// No description provided for @suggestingActions.
  ///
  /// In en, this message translates to:
  /// **'Suggesting possible actions'**
  String get suggestingActions;

  /// No description provided for @estimatingCaseStrength.
  ///
  /// In en, this message translates to:
  /// **'Estimating case strength'**
  String get estimatingCaseStrength;

  /// No description provided for @legalAidNetwork.
  ///
  /// In en, this message translates to:
  /// **'Legal Aid Network'**
  String get legalAidNetwork;

  /// No description provided for @freeServices.
  ///
  /// In en, this message translates to:
  /// **'Free Services'**
  String get freeServices;

  /// No description provided for @ngoContacts.
  ///
  /// In en, this message translates to:
  /// **'NGO Contacts'**
  String get ngoContacts;

  /// No description provided for @proBonoLawyers.
  ///
  /// In en, this message translates to:
  /// **'Pro-Bono Lawyers'**
  String get proBonoLawyers;

  /// No description provided for @governmentSchemes.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes'**
  String get governmentSchemes;

  /// No description provided for @checkEligibility.
  ///
  /// In en, this message translates to:
  /// **'Check Eligibility'**
  String get checkEligibility;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @womensHelpline.
  ///
  /// In en, this message translates to:
  /// **'Women\'s Helpline'**
  String get womensHelpline;

  /// No description provided for @childProtectionServices.
  ///
  /// In en, this message translates to:
  /// **'Child Protection Services'**
  String get childProtectionServices;

  /// No description provided for @laborCommissioner.
  ///
  /// In en, this message translates to:
  /// **'Labor Commissioner'**
  String get laborCommissioner;

  /// No description provided for @policeComplaintNumbers.
  ///
  /// In en, this message translates to:
  /// **'Police Complaint Numbers'**
  String get policeComplaintNumbers;

  /// No description provided for @humanRightsCommission.
  ///
  /// In en, this message translates to:
  /// **'Human Rights Commission'**
  String get humanRightsCommission;

  /// No description provided for @evidenceCollection.
  ///
  /// In en, this message translates to:
  /// **'Evidence Collection'**
  String get evidenceCollection;

  /// No description provided for @preserveEvidenceLegally.
  ///
  /// In en, this message translates to:
  /// **'Preserve Evidence Legally'**
  String get preserveEvidenceLegally;

  /// No description provided for @witnessStatements.
  ///
  /// In en, this message translates to:
  /// **'Witness Statements'**
  String get witnessStatements;

  /// No description provided for @photoVideoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Photo/Video Documentation'**
  String get photoVideoDocumentation;

  /// No description provided for @timelineCreation.
  ///
  /// In en, this message translates to:
  /// **'Timeline Creation'**
  String get timelineCreation;

  /// No description provided for @secureDocumentStorage.
  ///
  /// In en, this message translates to:
  /// **'Secure Document Storage'**
  String get secureDocumentStorage;

  /// No description provided for @incidentLogger.
  ///
  /// In en, this message translates to:
  /// **'Incident Logger'**
  String get incidentLogger;

  /// No description provided for @voiceDiary.
  ///
  /// In en, this message translates to:
  /// **'Voice Diary'**
  String get voiceDiary;

  /// No description provided for @nearestPoliceStation.
  ///
  /// In en, this message translates to:
  /// **'Nearest Police Station'**
  String get nearestPoliceStation;

  /// No description provided for @nearestCourt.
  ///
  /// In en, this message translates to:
  /// **'Nearest Court'**
  String get nearestCourt;

  /// No description provided for @officeHours.
  ///
  /// In en, this message translates to:
  /// **'Office Hours'**
  String get officeHours;

  /// No description provided for @publicTransport.
  ///
  /// In en, this message translates to:
  /// **'Public Transport'**
  String get publicTransport;

  /// No description provided for @whatToExpectInCourt.
  ///
  /// In en, this message translates to:
  /// **'What to Expect in Court'**
  String get whatToExpectInCourt;

  /// No description provided for @howToAddressJudge.
  ///
  /// In en, this message translates to:
  /// **'How to Address Judge'**
  String get howToAddressJudge;

  /// No description provided for @courtPreparationChecklist.
  ///
  /// In en, this message translates to:
  /// **'Court Preparation Checklist'**
  String get courtPreparationChecklist;

  /// No description provided for @commonCourtProcedures.
  ///
  /// In en, this message translates to:
  /// **'Common Court Procedures'**
  String get commonCourtProcedures;

  /// No description provided for @hearingReminders.
  ///
  /// In en, this message translates to:
  /// **'Hearing Reminders'**
  String get hearingReminders;

  /// No description provided for @courtDates.
  ///
  /// In en, this message translates to:
  /// **'Court Dates'**
  String get courtDates;

  /// No description provided for @formalComplaints.
  ///
  /// In en, this message translates to:
  /// **'Formal Complaints'**
  String get formalComplaints;

  /// No description provided for @complaintStatus.
  ///
  /// In en, this message translates to:
  /// **'Complaint Status'**
  String get complaintStatus;

  /// No description provided for @followUpReminders.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Reminders'**
  String get followUpReminders;

  /// No description provided for @escalationGuidance.
  ///
  /// In en, this message translates to:
  /// **'Escalation Guidance'**
  String get escalationGuidance;

  /// No description provided for @anonymousReporting.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Reporting'**
  String get anonymousReporting;

  /// No description provided for @whistleblowerProtection.
  ///
  /// In en, this message translates to:
  /// **'Whistleblower Protection'**
  String get whistleblowerProtection;

  /// No description provided for @corruptionReporting.
  ///
  /// In en, this message translates to:
  /// **'Corruption Reporting'**
  String get corruptionReporting;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @lowBandwidthMode.
  ///
  /// In en, this message translates to:
  /// **'Low Bandwidth Mode'**
  String get lowBandwidthMode;

  /// No description provided for @textOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'Text-only Mode'**
  String get textOnlyMode;

  /// No description provided for @smsFallback.
  ///
  /// In en, this message translates to:
  /// **'SMS Fallback'**
  String get smsFallback;

  /// No description provided for @criticalInformationViaSms.
  ///
  /// In en, this message translates to:
  /// **'Critical Information via SMS'**
  String get criticalInformationViaSms;

  /// No description provided for @ussdCodes.
  ///
  /// In en, this message translates to:
  /// **'USSD Codes'**
  String get ussdCodes;

  /// No description provided for @incidentReporting.
  ///
  /// In en, this message translates to:
  /// **'Incident Reporting'**
  String get incidentReporting;

  /// No description provided for @reportRightsViolations.
  ///
  /// In en, this message translates to:
  /// **'Report Rights Violations'**
  String get reportRightsViolations;

  /// No description provided for @violationType.
  ///
  /// In en, this message translates to:
  /// **'Violation Type'**
  String get violationType;

  /// No description provided for @anonymity.
  ///
  /// In en, this message translates to:
  /// **'Anonymity'**
  String get anonymity;

  /// No description provided for @generateFormalComplaint.
  ///
  /// In en, this message translates to:
  /// **'Generate Formal Complaint'**
  String get generateFormalComplaint;

  /// No description provided for @dataAnalyticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Data Analytics Dashboard'**
  String get dataAnalyticsDashboard;

  /// No description provided for @heatMaps.
  ///
  /// In en, this message translates to:
  /// **'Heat Maps'**
  String get heatMaps;

  /// No description provided for @trendingLegalIssues.
  ///
  /// In en, this message translates to:
  /// **'Trending Legal Issues'**
  String get trendingLegalIssues;

  /// No description provided for @lawyerFees.
  ///
  /// In en, this message translates to:
  /// **'Lawyer Fees'**
  String get lawyerFees;

  /// No description provided for @courtFees.
  ///
  /// In en, this message translates to:
  /// **'Court Fees'**
  String get courtFees;

  /// No description provided for @paymentPlans.
  ///
  /// In en, this message translates to:
  /// **'Payment Plans'**
  String get paymentPlans;

  /// No description provided for @feWaivers.
  ///
  /// In en, this message translates to:
  /// **'Fee Waivers'**
  String get feWaivers;

  /// No description provided for @governmentCompensation.
  ///
  /// In en, this message translates to:
  /// **'Government Compensation'**
  String get governmentCompensation;

  /// No description provided for @realCases.
  ///
  /// In en, this message translates to:
  /// **'Real Cases'**
  String get realCases;

  /// No description provided for @gotJustice.
  ///
  /// In en, this message translates to:
  /// **'Got Justice'**
  String get gotJustice;

  /// No description provided for @peerExperiences.
  ///
  /// In en, this message translates to:
  /// **'Peer Experiences'**
  String get peerExperiences;

  /// No description provided for @regionalVariations.
  ///
  /// In en, this message translates to:
  /// **'Regional Variations'**
  String get regionalVariations;

  /// No description provided for @legalLiteracyScore.
  ///
  /// In en, this message translates to:
  /// **'Legal Literacy Score'**
  String get legalLiteracyScore;

  /// No description provided for @gamifiedLearning.
  ///
  /// In en, this message translates to:
  /// **'Gamified Learning'**
  String get gamifiedLearning;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @communityLeaderboards.
  ///
  /// In en, this message translates to:
  /// **'Community Leaderboards'**
  String get communityLeaderboards;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;
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

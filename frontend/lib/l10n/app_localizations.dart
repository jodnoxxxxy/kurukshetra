import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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
    Locale('mr'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Kurukshetra'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome;

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

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myFarm.
  ///
  /// In en, this message translates to:
  /// **'My Farm'**
  String get myFarm;

  /// No description provided for @farmAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Farm Analytics'**
  String get farmAnalytics;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @farmerProfile.
  ///
  /// In en, this message translates to:
  /// **'Farmer Profile'**
  String get farmerProfile;

  /// No description provided for @verifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedTitle;

  /// No description provided for @farmerIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Farmer ID'**
  String get farmerIdLabel;

  /// No description provided for @farmAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm Area'**
  String get farmAreaLabel;

  /// No description provided for @organicScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Organic Score'**
  String get organicScoreLabel;

  /// No description provided for @memberSinceLabel.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSinceLabel;

  /// No description provided for @detailedStatistics.
  ///
  /// In en, this message translates to:
  /// **'Detailed Statistics'**
  String get detailedStatistics;

  /// No description provided for @primaryLocation.
  ///
  /// In en, this message translates to:
  /// **'Primary Location'**
  String get primaryLocation;

  /// No description provided for @totalLandArea.
  ///
  /// In en, this message translates to:
  /// **'Total Land Area'**
  String get totalLandArea;

  /// No description provided for @landRecords.
  ///
  /// In en, this message translates to:
  /// **'Land Records'**
  String get landRecords;

  /// No description provided for @cropHistory.
  ///
  /// In en, this message translates to:
  /// **'Crop History'**
  String get cropHistory;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToKurukshetra.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Kurukshetra'**
  String get signInToKurukshetra;

  /// No description provided for @validCredentialsError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid credentials'**
  String get validCredentialsError;

  /// No description provided for @loginFailedError.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailedError;

  /// No description provided for @farmerIdHint.
  ///
  /// In en, this message translates to:
  /// **'Phone Number or Farmer ID'**
  String get farmerIdHint;

  /// No description provided for @consumerEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Phone Number or Email'**
  String get consumerEmailHint;

  /// No description provided for @needAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account?'**
  String get needAnAccount;

  /// No description provided for @registerAsFarmer.
  ///
  /// In en, this message translates to:
  /// **'Register as Farmer'**
  String get registerAsFarmer;

  /// No description provided for @registerAsConsumer.
  ///
  /// In en, this message translates to:
  /// **'Register as Consumer'**
  String get registerAsConsumer;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @tapToChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to change photo'**
  String get tapToChangePhoto;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @farmInformation.
  ///
  /// In en, this message translates to:
  /// **'Farm Information'**
  String get farmInformation;

  /// No description provided for @farmLocation.
  ///
  /// In en, this message translates to:
  /// **'Farm Location'**
  String get farmLocation;

  /// No description provided for @farmAreaWithAcres.
  ///
  /// In en, this message translates to:
  /// **'Farm Area (Acres)'**
  String get farmAreaWithAcres;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get failedToUpdateProfile;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get failedToPickImage;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your farm location'**
  String get pleaseEnterLocation;

  /// No description provided for @pleaseEnterArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter your farm area'**
  String get pleaseEnterArea;

  /// No description provided for @pleaseEnterValidArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid farm area'**
  String get pleaseEnterValidArea;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registrationTitle;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @sentTo.
  ///
  /// In en, this message translates to:
  /// **'Sent to'**
  String get sentTo;

  /// No description provided for @enterOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get enterOtpHint;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @taluka.
  ///
  /// In en, this message translates to:
  /// **'Taluka'**
  String get taluka;

  /// No description provided for @village.
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select District'**
  String get selectDistrict;

  /// No description provided for @selectTaluka.
  ///
  /// In en, this message translates to:
  /// **'Select Taluka'**
  String get selectTaluka;

  /// No description provided for @selectVillage.
  ///
  /// In en, this message translates to:
  /// **'Select Village'**
  String get selectVillage;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created'**
  String get accountCreated;

  /// No description provided for @successfullyRegisteredFarmer.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered as a Farmer.'**
  String get successfullyRegisteredFarmer;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @selectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectTitle;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// No description provided for @systemOverview.
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get systemOverview;

  /// No description provided for @totalFarmersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Farmers'**
  String get totalFarmersLabel;

  /// No description provided for @farmersLabel.
  ///
  /// In en, this message translates to:
  /// **'Farmers'**
  String get farmersLabel;

  /// No description provided for @consumersLabel.
  ///
  /// In en, this message translates to:
  /// **'Consumers'**
  String get consumersLabel;

  /// No description provided for @activeProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active Products'**
  String get activeProductsLabel;

  /// No description provided for @revenueLabel.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenueLabel;

  /// No description provided for @managementModules.
  ///
  /// In en, this message translates to:
  /// **'Management Modules'**
  String get managementModules;

  /// No description provided for @verifyFarmersLabel.
  ///
  /// In en, this message translates to:
  /// **'Verify Farmers'**
  String get verifyFarmersLabel;

  /// No description provided for @flagsIssuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Flags & Issues'**
  String get flagsIssuesLabel;

  /// No description provided for @marketAnalyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Market Analytics'**
  String get marketAnalyticsLabel;

  /// No description provided for @systemConfigLabel.
  ///
  /// In en, this message translates to:
  /// **'System Config'**
  String get systemConfigLabel;

  /// No description provided for @adminIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin ID'**
  String get adminIdLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking credentials...'**
  String get loginLoading;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get loginError;

  /// No description provided for @adminLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access the management console.'**
  String get adminLoginDescription;

  /// No description provided for @returnToAppSelection.
  ///
  /// In en, this message translates to:
  /// **'Return to App Selection'**
  String get returnToAppSelection;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role to get started'**
  String get selectRole;

  /// No description provided for @welcomeToKurukshetra.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kurukshetra'**
  String get welcomeToKurukshetra;

  /// No description provided for @farmerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sell crops, analyze soil & detect pests'**
  String get farmerSubtitle;

  /// No description provided for @consumerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Buy fresh organic products directly'**
  String get consumerSubtitle;

  /// No description provided for @farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get farmer;

  /// No description provided for @consumer.
  ///
  /// In en, this message translates to:
  /// **'Consumer'**
  String get consumer;

  /// No description provided for @adminPortal.
  ///
  /// In en, this message translates to:
  /// **'Admin Portal'**
  String get adminPortal;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation'**
  String get aiRecommendation;

  /// No description provided for @suggestedNextCrop.
  ///
  /// In en, this message translates to:
  /// **'Suggested Next Crop: Soybean'**
  String get suggestedNextCrop;

  /// No description provided for @analyzeFullFarmData.
  ///
  /// In en, this message translates to:
  /// **'Analyze Full Farm Data'**
  String get analyzeFullFarmData;

  /// No description provided for @identifyPest.
  ///
  /// In en, this message translates to:
  /// **'Identify Pest & Disease'**
  String get identifyPest;

  /// No description provided for @myCrops.
  ///
  /// In en, this message translates to:
  /// **'My Crops'**
  String get myCrops;

  /// No description provided for @addCrop.
  ///
  /// In en, this message translates to:
  /// **'Add Crop'**
  String get addCrop;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @farmerServices.
  ///
  /// In en, this message translates to:
  /// **'Farmer Services'**
  String get farmerServices;

  /// No description provided for @cropAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory'**
  String get cropAdvisory;

  /// No description provided for @sop.
  ///
  /// In en, this message translates to:
  /// **'S.O.P.'**
  String get sop;

  /// No description provided for @soilHealthCard.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Card'**
  String get soilHealthCard;

  /// No description provided for @fertilizerCalculator.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Calculator'**
  String get fertilizerCalculator;

  /// No description provided for @climateTech.
  ///
  /// In en, this message translates to:
  /// **'Climate Tech'**
  String get climateTech;

  /// No description provided for @pestDisease.
  ///
  /// In en, this message translates to:
  /// **'Pest / Disease'**
  String get pestDisease;

  /// No description provided for @dbt.
  ///
  /// In en, this message translates to:
  /// **'D.B.T.'**
  String get dbt;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Kurukshetra'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @missionDescription.
  ///
  /// In en, this message translates to:
  /// **'Empowering Indian farmers with modern technology, sustainable farming practices, and direct market access.'**
  String get missionDescription;

  /// No description provided for @organicFarmingGuide.
  ///
  /// In en, this message translates to:
  /// **'Organic Farming Guide'**
  String get organicFarmingGuide;

  /// No description provided for @organicFarmingDescription.
  ///
  /// In en, this message translates to:
  /// **'Promoting sustainable and organic farming practices to improve soil health and farmer income.'**
  String get organicFarmingDescription;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for Indian Farmers'**
  String get madeWithLove;

  /// No description provided for @logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get logoutSubtitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @farmDetails.
  ///
  /// In en, this message translates to:
  /// **'Farm Details'**
  String get farmDetails;

  /// No description provided for @recordsLabel.
  ///
  /// In en, this message translates to:
  /// **'records'**
  String get recordsLabel;

  /// No description provided for @cropsTrackedLabel.
  ///
  /// In en, this message translates to:
  /// **'crops tracked'**
  String get cropsTrackedLabel;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get notificationsSubtitle;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @farmReports.
  ///
  /// In en, this message translates to:
  /// **'Farm Reports'**
  String get farmReports;

  /// No description provided for @farmReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download soil health and crop reports'**
  String get farmReportsSubtitle;

  /// No description provided for @organicCertification.
  ///
  /// In en, this message translates to:
  /// **'Organic Certification'**
  String get organicCertification;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage bank and UPI details'**
  String get paymentDetailsSubtitle;

  /// No description provided for @helpSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help with the app'**
  String get helpSupportSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @chooseSupportOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option below to get support'**
  String get chooseSupportOption;

  /// No description provided for @aiChatSupport.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Support'**
  String get aiChatSupport;

  /// No description provided for @aiChatSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get instant answers from our AI assistant'**
  String get aiChatSupportSubtitle;

  /// No description provided for @callExpert.
  ///
  /// In en, this message translates to:
  /// **'Call Agriculture Expert'**
  String get callExpert;

  /// No description provided for @callExpertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak directly with an agriculture expert'**
  String get callExpertSubtitle;

  /// No description provided for @kisanCallCentre.
  ///
  /// In en, this message translates to:
  /// **'Kisan Call Centre (KCC)'**
  String get kisanCallCentre;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @faqsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions and answers'**
  String get faqsSubtitle;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @userGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete app usage guide and tutorial'**
  String get userGuideSubtitle;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @reportIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a problem or suggest improvement'**
  String get reportIssueSubtitle;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Support hours: 6:00 AM – 10:00 PM'**
  String get supportHours;

  /// No description provided for @supportLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages: English, Hindi, Marathi'**
  String get supportLanguages;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @faq1Q.
  ///
  /// In en, this message translates to:
  /// **'How do I add a crop?'**
  String get faq1Q;

  /// No description provided for @faq1A.
  ///
  /// In en, this message translates to:
  /// **'Go to Home → My Crops → tap \'Add Crop\', select crop type and sowing date.'**
  String get faq1A;

  /// No description provided for @faq2Q.
  ///
  /// In en, this message translates to:
  /// **'How do I check pest alerts?'**
  String get faq2Q;

  /// No description provided for @faq2A.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Pest / Disease\' tile or go to the AI pest detection scanner.'**
  String get faq2A;

  /// No description provided for @faq3Q.
  ///
  /// In en, this message translates to:
  /// **'How do I see market prices?'**
  String get faq3Q;

  /// No description provided for @faq3A.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Market Price\' from the Farmer Services grid on the home screen.'**
  String get faq3A;

  /// No description provided for @faq4Q.
  ///
  /// In en, this message translates to:
  /// **'How do I change the language?'**
  String get faq4Q;

  /// No description provided for @faq4A.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Languages\' icon in the top-right of the home screen or go to Profile → Settings.'**
  String get faq4A;

  /// No description provided for @faq5Q.
  ///
  /// In en, this message translates to:
  /// **'How do I contact a farming expert?'**
  String get faq5Q;

  /// No description provided for @faq5A.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Help & Support\' menu → \'Call Agriculture Expert\'.'**
  String get faq5A;

  /// No description provided for @faq6Q.
  ///
  /// In en, this message translates to:
  /// **'How does the AI crop recommendation work?'**
  String get faq6Q;

  /// No description provided for @faq6A.
  ///
  /// In en, this message translates to:
  /// **'Go to Crop Advisory, enter your soil and climate details, and get AI-powered suggestions.'**
  String get faq6A;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @selectCropForSop.
  ///
  /// In en, this message translates to:
  /// **'Select Crop for S.O.P.'**
  String get selectCropForSop;

  /// No description provided for @sopTitle.
  ///
  /// In en, this message translates to:
  /// **'Standard Operating Procedure'**
  String get sopTitle;

  /// No description provided for @selectCropFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop first.'**
  String get selectCropFirst;

  /// No description provided for @cropSopTitle.
  ///
  /// In en, this message translates to:
  /// **'{crop} S.O.P.'**
  String cropSopTitle(Object crop);

  /// No description provided for @aiSopAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI SOP Assistant'**
  String get aiSopAssistant;

  /// No description provided for @noSopData.
  ///
  /// In en, this message translates to:
  /// **'No SOP data available for this crop.'**
  String get noSopData;

  /// No description provided for @errorLoadingSop.
  ///
  /// In en, this message translates to:
  /// **'Error loading SOP: {error}'**
  String errorLoadingSop(Object error);

  /// No description provided for @stepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {number}'**
  String stepLabel(Object number);

  /// No description provided for @sopDetail.
  ///
  /// In en, this message translates to:
  /// **'S.O.P. Detail'**
  String get sopDetail;

  /// No description provided for @stepDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Step details not found.'**
  String get stepDetailsNotFound;

  /// No description provided for @proTip.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get proTip;

  /// No description provided for @listenToInstructions.
  ///
  /// In en, this message translates to:
  /// **'Listen to Instructions'**
  String get listenToInstructions;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @pushNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive important alerts'**
  String get pushNotificationsSubtitle;

  /// No description provided for @accountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Account Preferences'**
  String get accountPreferences;

  /// No description provided for @privacySettings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// No description provided for @storageData.
  ///
  /// In en, this message translates to:
  /// **'Storage & Data'**
  String get storageData;

  /// No description provided for @aiCropPrediction.
  ///
  /// In en, this message translates to:
  /// **'AI Crop Prediction'**
  String get aiCropPrediction;

  /// No description provided for @autoFillWeather.
  ///
  /// In en, this message translates to:
  /// **'Auto-fill from weather'**
  String get autoFillWeather;

  /// No description provided for @gpsAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Auto-filled env variables via GPS.'**
  String get gpsAutoFilled;

  /// No description provided for @soilNutrients.
  ///
  /// In en, this message translates to:
  /// **'Soil Nutrients'**
  String get soilNutrients;

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get nitrogen;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P)'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K)'**
  String get potassium;

  /// No description provided for @soilPh.
  ///
  /// In en, this message translates to:
  /// **'Soil pH'**
  String get soilPh;

  /// No description provided for @rainfallMm.
  ///
  /// In en, this message translates to:
  /// **'Rainfall (mm)'**
  String get rainfallMm;

  /// No description provided for @environmentVariables.
  ///
  /// In en, this message translates to:
  /// **'Environment Variables'**
  String get environmentVariables;

  /// No description provided for @temperatureC.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°C)'**
  String get temperatureC;

  /// No description provided for @humidityPercent.
  ///
  /// In en, this message translates to:
  /// **'Humidity (%)'**
  String get humidityPercent;

  /// No description provided for @organicMatrix.
  ///
  /// In en, this message translates to:
  /// **'Organic Matrix'**
  String get organicMatrix;

  /// No description provided for @organicHealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Higher organic health pushes natural crop recommendations.'**
  String get organicHealthDesc;

  /// No description provided for @groundWater.
  ///
  /// In en, this message translates to:
  /// **'Ground Water (1-10)'**
  String get groundWater;

  /// No description provided for @organicHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Organic Health Score'**
  String get organicHealthScore;

  /// No description provided for @askAiEngine.
  ///
  /// In en, this message translates to:
  /// **'Ask AI Engine'**
  String get askAiEngine;

  /// No description provided for @evaluatingParameters.
  ///
  /// In en, this message translates to:
  /// **'Random Forest evaluating parameters...'**
  String get evaluatingParameters;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLabel;

  /// No description provided for @motivationMorning.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make your farm productive today 🌱'**
  String get motivationMorning;

  /// No description provided for @motivationAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Keep monitoring your crops for better yield 🌾'**
  String get motivationAfternoon;

  /// No description provided for @motivationEvening.
  ///
  /// In en, this message translates to:
  /// **'Check today\'s farm insights before resting 🌿'**
  String get motivationEvening;

  /// No description provided for @motivationNight.
  ///
  /// In en, this message translates to:
  /// **'Prepare for tomorrow\'s farming activities 🚜'**
  String get motivationNight;

  /// No description provided for @supportAssistant.
  ///
  /// In en, this message translates to:
  /// **'Support Assistant'**
  String get supportAssistant;

  /// No description provided for @howCanWeHelpToday.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get howCanWeHelpToday;

  /// No description provided for @unreadCountLabel.
  ///
  /// In en, this message translates to:
  /// **'unread'**
  String get unreadCountLabel;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app'**
  String get selectPreferredLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to'**
  String get languageChanged;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @kurukshetraFarmer.
  ///
  /// In en, this message translates to:
  /// **'Kurukshetra Farmer'**
  String get kurukshetraFarmer;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% Match'**
  String matchScore(Object score);

  /// No description provided for @recommendationReason.
  ///
  /// In en, this message translates to:
  /// **'Optimal soil pH and upcoming monsoon.'**
  String get recommendationReason;

  /// No description provided for @pestStep1.
  ///
  /// In en, this message translates to:
  /// **'1. Take Photo'**
  String get pestStep1;

  /// No description provided for @pestStep2.
  ///
  /// In en, this message translates to:
  /// **'2. Upload'**
  String get pestStep2;

  /// No description provided for @pestStep3.
  ///
  /// In en, this message translates to:
  /// **'3. Result'**
  String get pestStep3;

  /// No description provided for @activeCropsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Active'**
  String activeCropsCount(Object count);

  /// No description provided for @noCropsAdded.
  ///
  /// In en, this message translates to:
  /// **'No crops added yet'**
  String get noCropsAdded;

  /// No description provided for @addFirstCropDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first crop to get started'**
  String get addFirstCropDesc;

  /// No description provided for @sowedToday.
  ///
  /// In en, this message translates to:
  /// **'Sowed today'**
  String get sowedToday;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get dayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days since sowing'**
  String daysAgo(Object days);

  /// No description provided for @connectedModules.
  ///
  /// In en, this message translates to:
  /// **'Connected Modules'**
  String get connectedModules;

  /// No description provided for @deleteCropTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete crop'**
  String get deleteCropTooltip;

  /// No description provided for @deleteCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Crop'**
  String get deleteCropTitle;

  /// No description provided for @deleteCropConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String deleteCropConfirm(Object name);

  /// No description provided for @cropDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String cropDeleted(Object name);

  /// No description provided for @failedWeather.
  ///
  /// In en, this message translates to:
  /// **'Failed to load weather'**
  String get failedWeather;

  /// No description provided for @failedPrices.
  ///
  /// In en, this message translates to:
  /// **'Failed to load prices'**
  String get failedPrices;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// No description provided for @revenueValue.
  ///
  /// In en, this message translates to:
  /// **'₹4.2L'**
  String get revenueValue;

  /// No description provided for @pendingVerificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Pending verification requests (12)'**
  String get pendingVerificationDesc;

  /// No description provided for @customerComplaintsDesc.
  ///
  /// In en, this message translates to:
  /// **'Customer complaints and product reports'**
  String get customerComplaintsDesc;

  /// No description provided for @priceTrendsDesc.
  ///
  /// In en, this message translates to:
  /// **'Price trends and demand forecasting'**
  String get priceTrendsDesc;

  /// No description provided for @appSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'App settings and API management'**
  String get appSettingsDesc;

  /// No description provided for @moduleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{module} module coming soon'**
  String moduleComingSoon(Object module);

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailed;

  /// No description provided for @aiPestDetectionTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Pest Detection'**
  String get aiPestDetectionTitle;

  /// No description provided for @identifyPestsDiseases.
  ///
  /// In en, this message translates to:
  /// **'Identify Pests & Diseases'**
  String get identifyPestsDiseases;

  /// No description provided for @pestDetectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear photo of the affected crop leaf or stem. Our AI will analyze the image and provide treatment recommendations.'**
  String get pestDetectionDescription;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @analyzeImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze Image'**
  String get analyzeImage;

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing the image...'**
  String get analyzingImage;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @affectedArea.
  ///
  /// In en, this message translates to:
  /// **'Affected Area'**
  String get affectedArea;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @treatmentRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Treatment Recommendations'**
  String get treatmentRecommendations;

  /// No description provided for @preventionStrategies.
  ///
  /// In en, this message translates to:
  /// **'Prevention Strategies'**
  String get preventionStrategies;

  /// No description provided for @soilAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis'**
  String get soilAnalysisTitle;

  /// No description provided for @enterSoilData.
  ///
  /// In en, this message translates to:
  /// **'Enter Soil Data'**
  String get enterSoilData;

  /// No description provided for @soilDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Provide latest soil test results to get AI-powered fertilizer and crop recommendations.'**
  String get soilDataDescription;

  /// No description provided for @phLevel.
  ///
  /// In en, this message translates to:
  /// **'pH Level'**
  String get phLevel;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @analyzeSoil.
  ///
  /// In en, this message translates to:
  /// **'Analyze Soil'**
  String get analyzeSoil;

  /// No description provided for @aiAnalysisResults.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis Results'**
  String get aiAnalysisResults;

  /// No description provided for @healthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @suitableCrops.
  ///
  /// In en, this message translates to:
  /// **'Suitable Crops'**
  String get suitableCrops;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @soilTypeLoamy.
  ///
  /// In en, this message translates to:
  /// **'Loamy'**
  String get soilTypeLoamy;

  /// No description provided for @soilTypeClay.
  ///
  /// In en, this message translates to:
  /// **'Clay'**
  String get soilTypeClay;

  /// No description provided for @soilTypeSandy.
  ///
  /// In en, this message translates to:
  /// **'Sandy'**
  String get soilTypeSandy;

  /// No description provided for @soilTypeSilt.
  ///
  /// In en, this message translates to:
  /// **'Silt'**
  String get soilTypeSilt;

  /// No description provided for @soilTypePeaty.
  ///
  /// In en, this message translates to:
  /// **'Peaty'**
  String get soilTypePeaty;

  /// No description provided for @soilTypeSaline.
  ///
  /// In en, this message translates to:
  /// **'Saline'**
  String get soilTypeSaline;

  /// No description provided for @learningHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Shetishala'**
  String get learningHubTitle;

  /// No description provided for @featuredVideos.
  ///
  /// In en, this message translates to:
  /// **'Featured Videos'**
  String get featuredVideos;

  /// No description provided for @trainingModules.
  ///
  /// In en, this message translates to:
  /// **'Training Modules'**
  String get trainingModules;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryOrganic.
  ///
  /// In en, this message translates to:
  /// **'Organic Farming'**
  String get categoryOrganic;

  /// No description provided for @categoryPest.
  ///
  /// In en, this message translates to:
  /// **'Pest Control'**
  String get categoryPest;

  /// No description provided for @categoryIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get categoryIrrigation;

  /// No description provided for @categoryMarket.
  ///
  /// In en, this message translates to:
  /// **'Market Trends'**
  String get categoryMarket;

  /// No description provided for @modernDripIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Modern Drip Irrigation Techniques'**
  String get modernDripIrrigation;

  /// No description provided for @organicFertilizerPrep.
  ///
  /// In en, this message translates to:
  /// **'Organic Fertilizer Prep at Home'**
  String get organicFertilizerPrep;

  /// No description provided for @pestManagementMonsoon.
  ///
  /// In en, this message translates to:
  /// **'Pest Management in Monsoon'**
  String get pestManagementMonsoon;

  /// No description provided for @viewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String viewsCount(Object count);

  /// No description provided for @soilTesting101.
  ///
  /// In en, this message translates to:
  /// **'Soil Testing 101'**
  String get soilTesting101;

  /// No description provided for @cropRotationBasics.
  ///
  /// In en, this message translates to:
  /// **'Crop Rotation Basics'**
  String get cropRotationBasics;

  /// No description provided for @marketPricesTitle.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPricesTitle;

  /// No description provided for @noCropSelected.
  ///
  /// In en, this message translates to:
  /// **'No crop selected.'**
  String get noCropSelected;

  /// No description provided for @cropPrices.
  ///
  /// In en, this message translates to:
  /// **'{crop} Prices'**
  String cropPrices(Object crop);

  /// No description provided for @noMarketData.
  ///
  /// In en, this message translates to:
  /// **'No market data available right now.'**
  String get noMarketData;

  /// No description provided for @comparePricesLabel.
  ///
  /// In en, this message translates to:
  /// **'Compare prices across nearby markets to maximize profits.'**
  String get comparePricesLabel;

  /// No description provided for @marketDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Market Details'**
  String get marketDetailsTitle;

  /// No description provided for @noDetailsFound.
  ///
  /// In en, this message translates to:
  /// **'No details found.'**
  String get noDetailsFound;

  /// No description provided for @modalPricePerQuintal.
  ///
  /// In en, this message translates to:
  /// **'Modal Price per quintal'**
  String get modalPricePerQuintal;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPrice;

  /// No description provided for @marketAddress.
  ///
  /// In en, this message translates to:
  /// **'Market Address'**
  String get marketAddress;

  /// No description provided for @distanceFromYou.
  ///
  /// In en, this message translates to:
  /// **'Distance from you'**
  String get distanceFromYou;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @view7DayPriceTrend.
  ///
  /// In en, this message translates to:
  /// **'View 7-Day Price Trend'**
  String get view7DayPriceTrend;

  /// No description provided for @distanceKmText.
  ///
  /// In en, this message translates to:
  /// **'{distance} km (Est. {mins} mins)'**
  String distanceKmText(Object distance, Object mins);

  /// No description provided for @categoryCereals.
  ///
  /// In en, this message translates to:
  /// **'Cereals'**
  String get categoryCereals;

  /// No description provided for @categoryPulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get categoryPulses;

  /// No description provided for @categoryOilseeds.
  ///
  /// In en, this message translates to:
  /// **'Oilseeds'**
  String get categoryOilseeds;

  /// No description provided for @categoryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get categoryVegetables;

  /// No description provided for @categoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get categoryFruits;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @maize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get maize;

  /// No description provided for @gram.
  ///
  /// In en, this message translates to:
  /// **'Gram'**
  String get gram;

  /// No description provided for @blackGram.
  ///
  /// In en, this message translates to:
  /// **'Black Gram'**
  String get blackGram;

  /// No description provided for @greenGram.
  ///
  /// In en, this message translates to:
  /// **'Green Gram'**
  String get greenGram;

  /// No description provided for @soybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get soybean;

  /// No description provided for @groundnut.
  ///
  /// In en, this message translates to:
  /// **'Groundnut'**
  String get groundnut;

  /// No description provided for @sunflower.
  ///
  /// In en, this message translates to:
  /// **'Sunflower'**
  String get sunflower;

  /// No description provided for @tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get tomato;

  /// No description provided for @onion.
  ///
  /// In en, this message translates to:
  /// **'Onion'**
  String get onion;

  /// No description provided for @potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @jute.
  ///
  /// In en, this message translates to:
  /// **'Jute'**
  String get jute;

  /// No description provided for @cotton.
  ///
  /// In en, this message translates to:
  /// **'Cotton'**
  String get cotton;

  /// No description provided for @mustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get mustard;

  /// No description provided for @sugarcane.
  ///
  /// In en, this message translates to:
  /// **'Sugarcane'**
  String get sugarcane;

  /// No description provided for @ragi.
  ///
  /// In en, this message translates to:
  /// **'Ragi'**
  String get ragi;

  /// No description provided for @bajra.
  ///
  /// In en, this message translates to:
  /// **'Bajra'**
  String get bajra;

  /// No description provided for @jowar.
  ///
  /// In en, this message translates to:
  /// **'Jowar'**
  String get jowar;

  /// No description provided for @pulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get pulses;

  /// No description provided for @priceTrendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Trends'**
  String get priceTrendsTitle;

  /// No description provided for @noDataBound.
  ///
  /// In en, this message translates to:
  /// **'No data bound.'**
  String get noDataBound;

  /// No description provided for @cropTrends.
  ///
  /// In en, this message translates to:
  /// **'{crop} Trends'**
  String cropTrends(Object crop);

  /// No description provided for @marketValue.
  ///
  /// In en, this message translates to:
  /// **'Market: {market}'**
  String marketValue(Object market);

  /// No description provided for @historicalTrendsDesc.
  ///
  /// In en, this message translates to:
  /// **'7-Day historical modal prices per quintal.'**
  String get historicalTrendsDesc;

  /// No description provided for @noHistoricalTrends.
  ///
  /// In en, this message translates to:
  /// **'No historical trends available.'**
  String get noHistoricalTrends;

  /// No description provided for @pricesRising.
  ///
  /// In en, this message translates to:
  /// **'Prices are rising'**
  String get pricesRising;

  /// No description provided for @pricesDipping.
  ///
  /// In en, this message translates to:
  /// **'Prices are dipping'**
  String get pricesDipping;

  /// No description provided for @sellSuggestion.
  ///
  /// In en, this message translates to:
  /// **'We suggest selling your {crop} soon to capitalize on this uptrend.'**
  String sellSuggestion(Object crop);

  /// No description provided for @holdSuggestion.
  ///
  /// In en, this message translates to:
  /// **'It might be wise to hold your {crop} inventory if possible.'**
  String holdSuggestion(Object crop);

  /// No description provided for @topPrice.
  ///
  /// In en, this message translates to:
  /// **'Top Price'**
  String get topPrice;

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String kmAway(Object distance);

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @modalLabel.
  ///
  /// In en, this message translates to:
  /// **'Modal'**
  String get modalLabel;

  /// No description provided for @noSuitableCrops.
  ///
  /// In en, this message translates to:
  /// **'No suitable crops matched the strict parameters.'**
  String get noSuitableCrops;

  /// No description provided for @topMatchFound.
  ///
  /// In en, this message translates to:
  /// **'Top Match Found'**
  String get topMatchFound;

  /// No description provided for @predictionLogicDesc.
  ///
  /// In en, this message translates to:
  /// **'Based on your NPK, pH, and environmental indicators, the Random Forest model strongly predicts:'**
  String get predictionLogicDesc;

  /// No description provided for @loadingMLResults.
  ///
  /// In en, this message translates to:
  /// **'Loading ML Results...'**
  String get loadingMLResults;

  /// No description provided for @bestMatch.
  ///
  /// In en, this message translates to:
  /// **'Best Match'**
  String get bestMatch;

  /// No description provided for @suitability.
  ///
  /// In en, this message translates to:
  /// **'Suitability'**
  String get suitability;

  /// No description provided for @organicMatch.
  ///
  /// In en, this message translates to:
  /// **'Organic Match'**
  String get organicMatch;

  /// No description provided for @partlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy'**
  String get partlyCloudy;

  /// No description provided for @sunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get sunny;

  /// No description provided for @cloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get cloudy;

  /// No description provided for @rainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get rainy;

  /// No description provided for @hotAndDry.
  ///
  /// In en, this message translates to:
  /// **'Hot and Dry'**
  String get hotAndDry;

  /// No description provided for @notCertified.
  ///
  /// In en, this message translates to:
  /// **'Not Certified'**
  String get notCertified;

  /// No description provided for @certified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get certified;

  /// No description provided for @organicPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get organicPending;

  /// No description provided for @identifyPestAndDisease.
  ///
  /// In en, this message translates to:
  /// **'Identify Pest & Disease'**
  String get identifyPestAndDisease;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @scanCropLeaves.
  ///
  /// In en, this message translates to:
  /// **'Scan crop leaves using your camera'**
  String get scanCropLeaves;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select a photo from your gallery'**
  String get selectFromGallery;

  /// No description provided for @orLabel.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orLabel;

  /// No description provided for @browsePestLibrary.
  ///
  /// In en, this message translates to:
  /// **'Browse Pest Library'**
  String get browsePestLibrary;

  /// No description provided for @cropImage.
  ///
  /// In en, this message translates to:
  /// **'Crop Image'**
  String get cropImage;

  /// No description provided for @waitingForImage.
  ///
  /// In en, this message translates to:
  /// **'Waiting for image...'**
  String get waitingForImage;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI Analyzing...'**
  String get aiAnalyzing;

  /// No description provided for @analyzeWithAI.
  ///
  /// In en, this message translates to:
  /// **'Analyze with AI'**
  String get analyzeWithAI;

  /// No description provided for @aiAnalysisComplete.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis complete'**
  String get aiAnalysisComplete;

  /// No description provided for @noAnalysisFound.
  ///
  /// In en, this message translates to:
  /// **'No analysis found.'**
  String get noAnalysisFound;

  /// No description provided for @detectedLabel.
  ///
  /// In en, this message translates to:
  /// **'Detected: {pestName}'**
  String detectedLabel(String pestName);

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {score}%'**
  String confidenceLabel(String score);

  /// No description provided for @affectingLabel.
  ///
  /// In en, this message translates to:
  /// **'Affecting: {cropName}'**
  String affectingLabel(String cropName);

  /// No description provided for @viewOrganicSolutions.
  ///
  /// In en, this message translates to:
  /// **'View Organic Solutions'**
  String get viewOrganicSolutions;

  /// No description provided for @aphids.
  ///
  /// In en, this message translates to:
  /// **'Aphids'**
  String get aphids;

  /// No description provided for @stemBorer.
  ///
  /// In en, this message translates to:
  /// **'Stem Borer'**
  String get stemBorer;

  /// No description provided for @leafBlight.
  ///
  /// In en, this message translates to:
  /// **'Leaf Blight'**
  String get leafBlight;

  /// No description provided for @leafPests.
  ///
  /// In en, this message translates to:
  /// **'Leaf pests'**
  String get leafPests;

  /// No description provided for @stemPests.
  ///
  /// In en, this message translates to:
  /// **'Stem pests'**
  String get stemPests;

  /// No description provided for @fungalDiseases.
  ///
  /// In en, this message translates to:
  /// **'Fungal diseases'**
  String get fungalDiseases;

  /// No description provided for @unknownCrop.
  ///
  /// In en, this message translates to:
  /// **'Unknown Crop (Auto-detected)'**
  String get unknownCrop;

  /// No description provided for @symptomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptomsLabel;

  /// No description provided for @causeLabel.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get causeLabel;

  /// No description provided for @preventionLabel.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get preventionLabel;

  /// No description provided for @organicTreatmentRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Organic Treatment Recommendations'**
  String get organicTreatmentRecommendations;

  /// No description provided for @pestAndDiseaseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Pest & Disease Library'**
  String get pestAndDiseaseLibrary;

  /// No description provided for @noPestSelected.
  ///
  /// In en, this message translates to:
  /// **'No Pest Selected.'**
  String get noPestSelected;

  /// No description provided for @pestLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get pestLibrary;

  /// No description provided for @affectsLabel.
  ///
  /// In en, this message translates to:
  /// **'Affects: {crops}'**
  String affectsLabel(String crops);

  /// No description provided for @organicLabel.
  ///
  /// In en, this message translates to:
  /// **'ORGANIC'**
  String get organicLabel;

  /// No description provided for @enterSoilTestReport.
  ///
  /// In en, this message translates to:
  /// **'Enter Soil Test Report'**
  String get enterSoilTestReport;

  /// No description provided for @soilInputInstruction.
  ///
  /// In en, this message translates to:
  /// **'Input the precise macronutrient values from your soil lab test to generate organic recommendations.'**
  String get soilInputInstruction;

  /// No description provided for @nitrogenLabel.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N)'**
  String get nitrogenLabel;

  /// No description provided for @phosphorusLabel.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P)'**
  String get phosphorusLabel;

  /// No description provided for @potassiumLabel.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K)'**
  String get potassiumLabel;

  /// No description provided for @phLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Soil pH Level'**
  String get phLevelLabel;

  /// No description provided for @organicCarbonLabel.
  ///
  /// In en, this message translates to:
  /// **'Organic Carbon (OC)'**
  String get organicCarbonLabel;

  /// No description provided for @analyzingSoil.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzingSoil;

  /// No description provided for @analyzeSoilData.
  ///
  /// In en, this message translates to:
  /// **'Analyze Soil Data'**
  String get analyzeSoilData;

  /// No description provided for @kgHa.
  ///
  /// In en, this message translates to:
  /// **'kg/ha'**
  String get kgHa;

  /// No description provided for @soilAnalysisStatus.
  ///
  /// In en, this message translates to:
  /// **'Soil Analysis Status'**
  String get soilAnalysisStatus;

  /// No description provided for @noDataComputed.
  ///
  /// In en, this message translates to:
  /// **'No data computed.'**
  String get noDataComputed;

  /// No description provided for @detailedMacronutrients.
  ///
  /// In en, this message translates to:
  /// **'Detailed Macronutrients'**
  String get detailedMacronutrients;

  /// No description provided for @nutrientStatus.
  ///
  /// In en, this message translates to:
  /// **'{nutrient} Status'**
  String nutrientStatus(String nutrient);

  /// No description provided for @viewOrganicRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View Organic Recommendations'**
  String get viewOrganicRecommendations;

  /// No description provided for @organicStrategy.
  ///
  /// In en, this message translates to:
  /// **'Organic Strategy'**
  String get organicStrategy;

  /// No description provided for @soilPracticeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Following these organic practices will rebuild soil health and long-term carbon reserves naturally.'**
  String get soilPracticeInstruction;

  /// No description provided for @organicFertilizerSolutions.
  ///
  /// In en, this message translates to:
  /// **'Organic Fertilizer Solutions'**
  String get organicFertilizerSolutions;

  /// No description provided for @perfectSoilHealth.
  ///
  /// In en, this message translates to:
  /// **'Soil is in perfect health.'**
  String get perfectSoilHealth;

  /// No description provided for @idealCropVariations.
  ///
  /// In en, this message translates to:
  /// **'Ideal Crop Variations'**
  String get idealCropVariations;

  /// No description provided for @noSpecificCrops.
  ///
  /// In en, this message translates to:
  /// **'No specific crops for this profile.'**
  String get noSpecificCrops;

  /// No description provided for @lowStatus.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get lowStatus;

  /// No description provided for @mediumStatus.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get mediumStatus;

  /// No description provided for @highStatus.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get highStatus;

  /// No description provided for @acidicStatus.
  ///
  /// In en, this message translates to:
  /// **'Acidic'**
  String get acidicStatus;

  /// No description provided for @alkalineStatus.
  ///
  /// In en, this message translates to:
  /// **'Alkaline'**
  String get alkalineStatus;

  /// No description provided for @neutralStatus.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutralStatus;

  /// No description provided for @healthyLabel.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthyLabel;

  /// No description provided for @moderateLabel.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderateLabel;

  /// No description provided for @poorLabel.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poorLabel;

  /// No description provided for @soilHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Score'**
  String get soilHealthScore;

  /// No description provided for @weatherAlert.
  ///
  /// In en, this message translates to:
  /// **'Weather Alert'**
  String get weatherAlert;

  /// No description provided for @pestRiskAlert.
  ///
  /// In en, this message translates to:
  /// **'Pest Risk Alert'**
  String get pestRiskAlert;

  /// No description provided for @marketPriceAlert.
  ///
  /// In en, this message translates to:
  /// **'Market Price Alert'**
  String get marketPriceAlert;

  /// No description provided for @governmentSchemeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Government Scheme Update'**
  String get governmentSchemeUpdate;

  /// No description provided for @orderUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order Update'**
  String get orderUpdate;

  /// No description provided for @preferencesTab.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTab;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which notifications you want to receive'**
  String get notificationSubtitle;

  /// No description provided for @quietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get quietHours;

  /// No description provided for @quietHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'10:00 PM - 6:00 AM'**
  String get quietHoursSubtitle;

  /// No description provided for @quietHoursConfirm.
  ///
  /// In en, this message translates to:
  /// **'During quiet hours (10:00 PM - 6:00 AM), you will only receive emergency alerts.'**
  String get quietHoursConfirm;

  /// No description provided for @soundVibration.
  ///
  /// In en, this message translates to:
  /// **'Sound & Vibration'**
  String get soundVibration;

  /// No description provided for @soundVibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ringtone: Default, Vibration: On'**
  String get soundVibrationSubtitle;

  /// No description provided for @notificationSound.
  ///
  /// In en, this message translates to:
  /// **'Notification Sound'**
  String get notificationSound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @clearAllNotificationsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all notifications?'**
  String get clearAllNotificationsConfirm;

  /// No description provided for @allNotificationsCleared.
  ///
  /// In en, this message translates to:
  /// **'All notifications cleared'**
  String get allNotificationsCleared;

  /// No description provided for @soundSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Sound settings updated'**
  String get soundSettingsUpdated;

  /// No description provided for @quietHoursUpdated.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours settings updated'**
  String get quietHoursUpdated;

  /// No description provided for @notificationPrefUpdated.
  ///
  /// In en, this message translates to:
  /// **'Notification preference updated'**
  String get notificationPrefUpdated;

  /// No description provided for @openingIssueReport.
  ///
  /// In en, this message translates to:
  /// **'Opening Issue Report...'**
  String get openingIssueReport;

  /// No description provided for @callingExpert.
  ///
  /// In en, this message translates to:
  /// **'Calling expert...'**
  String get callingExpert;

  /// No description provided for @openingVoiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Opening Voice Assistant...'**
  String get openingVoiceAssistant;

  /// No description provided for @farmerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Farmer Dashboard'**
  String get farmerDashboardTitle;

  /// No description provided for @farmOverview.
  ///
  /// In en, this message translates to:
  /// **'Farm Overview'**
  String get farmOverview;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @estProfit.
  ///
  /// In en, this message translates to:
  /// **'Est. Profit'**
  String get estProfit;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stageLabel;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @cropHealthMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Crop Health Monitoring'**
  String get cropHealthMonitoring;

  /// No description provided for @soilHealthSummary.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Summary'**
  String get soilHealthSummary;

  /// No description provided for @viewFull.
  ///
  /// In en, this message translates to:
  /// **'View Full'**
  String get viewFull;

  /// No description provided for @marketPriceSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Market Price Snapshot'**
  String get marketPriceSnapshot;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @rising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get rising;

  /// No description provided for @falling.
  ///
  /// In en, this message translates to:
  /// **'Falling'**
  String get falling;

  /// No description provided for @acres.
  ///
  /// In en, this message translates to:
  /// **'{count} Acres'**
  String acres(Object count);

  /// No description provided for @krishiAiName.
  ///
  /// In en, this message translates to:
  /// **'Krishi AI Assistant'**
  String get krishiAiName;

  /// No description provided for @krishiAiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Agricultural AI Companion'**
  String get krishiAiSubtitle;

  /// No description provided for @krishiAiWelcome.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am Krishi AI. How can I help you with your farming today?'**
  String get krishiAiWelcome;

  /// No description provided for @krishiAiTyping.
  ///
  /// In en, this message translates to:
  /// **'Krishi AI is thinking...'**
  String get krishiAiTyping;

  /// No description provided for @krishiAiPrompt.
  ///
  /// In en, this message translates to:
  /// **'Ask about crops, pests, or market prices...'**
  String get krishiAiPrompt;

  /// No description provided for @cropSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Crop Selection'**
  String get cropSelectionTitle;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @resultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsTitle;

  /// No description provided for @fertilizerCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Calculator'**
  String get fertilizerCalculatorTitle;

  /// No description provided for @farmingDetails.
  ///
  /// In en, this message translates to:
  /// **'Farming Details'**
  String get farmingDetails;

  /// No description provided for @selectCropLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Crop'**
  String get selectCropLabel;

  /// No description provided for @landArea.
  ///
  /// In en, this message translates to:
  /// **'Land Area'**
  String get landArea;

  /// No description provided for @soilHealthDataNpk.
  ///
  /// In en, this message translates to:
  /// **'Soil Health Data (NPK)'**
  String get soilHealthDataNpk;

  /// No description provided for @soilHealthDataInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter the values from your recent soil health card. Approximate if unknown.'**
  String get soilHealthDataInstruction;

  /// No description provided for @calculateFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Calculate Fertilizer'**
  String get calculateFertilizer;

  /// No description provided for @nitrogenLabelKgHa.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N) kg/ha'**
  String get nitrogenLabelKgHa;

  /// No description provided for @phosphorusLabelKgHa.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus (P) kg/ha'**
  String get phosphorusLabelKgHa;

  /// No description provided for @potassiumLabelKgHa.
  ///
  /// In en, this message translates to:
  /// **'Potassium (K) kg/ha'**
  String get potassiumLabelKgHa;

  /// No description provided for @unitAcre.
  ///
  /// In en, this message translates to:
  /// **'Acre'**
  String get unitAcre;

  /// No description provided for @unitHectare.
  ///
  /// In en, this message translates to:
  /// **'Hectare'**
  String get unitHectare;

  /// No description provided for @recommendationReport.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Report'**
  String get recommendationReport;

  /// No description provided for @noComputingData.
  ///
  /// In en, this message translates to:
  /// **'No computing data found.'**
  String get noComputingData;

  /// No description provided for @failedToCalculate.
  ///
  /// In en, this message translates to:
  /// **'Failed to calculate.'**
  String get failedToCalculate;

  /// No description provided for @landAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Land Area: {area} {unit}'**
  String landAreaLabel(Object area, Object unit);

  /// No description provided for @organicMode.
  ///
  /// In en, this message translates to:
  /// **'Organic Mode'**
  String get organicMode;

  /// No description provided for @chemicalMode.
  ///
  /// In en, this message translates to:
  /// **'Chemical Mode'**
  String get chemicalMode;

  /// No description provided for @sufficientNutrients.
  ///
  /// In en, this message translates to:
  /// **'Soil nutrient levels are sufficient.'**
  String get sufficientNutrients;

  /// No description provided for @organicSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Organic Fertilizer Suggestions'**
  String get organicSuggestions;

  /// No description provided for @chemicalSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Chemical Fertilizer Suggestions'**
  String get chemicalSuggestions;

  /// No description provided for @applicationRate.
  ///
  /// In en, this message translates to:
  /// **'Application Rate: {amount} {unit}'**
  String applicationRate(Object amount, Object unit);

  /// No description provided for @advisoryTimeline.
  ///
  /// In en, this message translates to:
  /// **'Advisory Timeline'**
  String get advisoryTimeline;

  /// No description provided for @selectCropSowingDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a crop and sowing date first.'**
  String get selectCropSowingDateFirst;

  /// No description provided for @cropAdvisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{crop} Advisory'**
  String cropAdvisoryTitle(Object crop);

  /// No description provided for @aiChatAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Assistant'**
  String get aiChatAssistant;

  /// No description provided for @timelineLabel.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timelineLabel;

  /// No description provided for @failedToLoadStages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stages: {error}'**
  String failedToLoadStages(Object error);

  /// No description provided for @sowingDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Sowing Date'**
  String get sowingDateLabel;

  /// No description provided for @currentDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Day'**
  String get currentDayLabel;

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayCount(Object day);

  /// No description provided for @dayRange.
  ///
  /// In en, this message translates to:
  /// **'Day {start}-{end}'**
  String dayRange(Object end, Object start);
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
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

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
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

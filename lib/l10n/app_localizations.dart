import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @myDemos.
  ///
  /// In en, this message translates to:
  /// **'My Demos'**
  String get myDemos;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noDemosAvailable.
  ///
  /// In en, this message translates to:
  /// **'No demos available'**
  String get noDemosAvailable;

  /// No description provided for @pressButtonToFetch.
  ///
  /// In en, this message translates to:
  /// **'Press the button to fetch data'**
  String get pressButtonToFetch;

  /// No description provided for @demosImIn.
  ///
  /// In en, this message translates to:
  /// **'Demos I\'m In'**
  String get demosImIn;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @byAuthor.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String byAuthor(String author);

  /// No description provided for @usersCountText.
  ///
  /// In en, this message translates to:
  /// **'{count} users'**
  String usersCountText(int count);

  /// No description provided for @see.
  ///
  /// In en, this message translates to:
  /// **'See'**
  String get see;

  /// No description provided for @navMain.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get navMain;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @addDemo.
  ///
  /// In en, this message translates to:
  /// **'Add Demo'**
  String get addDemo;

  /// No description provided for @statMyDemos.
  ///
  /// In en, this message translates to:
  /// **'My Demos'**
  String get statMyDemos;

  /// No description provided for @statEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get statEnrolled;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get manageAccount;

  /// No description provided for @secPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get secPreferences;

  /// No description provided for @tileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get tileTheme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @tileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get tileLanguage;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @tileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get tileNotifications;

  /// No description provided for @tileMyCertificates.
  ///
  /// In en, this message translates to:
  /// **'My Certificate'**
  String get tileMyCertificates;

  /// No description provided for @notifOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get notifOn;

  /// No description provided for @notifOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notifOff;

  /// No description provided for @notificationsEnabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabledMsg;

  /// No description provided for @notificationsDisabledMsg.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabledMsg;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required. Please enable it in settings.'**
  String get notificationPermissionDenied;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettings;

  /// No description provided for @secSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get secSupport;

  /// No description provided for @tileAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get tileAboutUs;

  /// No description provided for @aboutUsTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsTitle;

  /// No description provided for @aboutUsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn more about our vision, platform, and features'**
  String get aboutUsSubtitle;

  /// No description provided for @aboutUsTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart & Interactive Learning Platform'**
  String get aboutUsTagline;

  /// No description provided for @aboutUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Our platform is a comprehensive educational ecosystem built to empower students, educators, and professionals. Experience interactive courses, live sessions, AI-powered assistance, and recognized certifications — all in one place.'**
  String get aboutUsDescription;

  /// No description provided for @aboutUsMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get aboutUsMissionTitle;

  /// No description provided for @aboutUsMissionDesc.
  ///
  /// In en, this message translates to:
  /// **'To make high-quality, interactive education accessible, flexible, and engaging for everyone, anywhere.'**
  String get aboutUsMissionDesc;

  /// No description provided for @aboutUsFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform Highlights'**
  String get aboutUsFeaturesTitle;

  /// No description provided for @aboutUsFeature1Title.
  ///
  /// In en, this message translates to:
  /// **'Interactive Courses & Lessons'**
  String get aboutUsFeature1Title;

  /// No description provided for @aboutUsFeature1Desc.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive video lectures, attachments, and structured learning tracks.'**
  String get aboutUsFeature1Desc;

  /// No description provided for @aboutUsFeature2Title.
  ///
  /// In en, this message translates to:
  /// **'AI Learning Assistant'**
  String get aboutUsFeature2Title;

  /// No description provided for @aboutUsFeature2Desc.
  ///
  /// In en, this message translates to:
  /// **'Smart, instant answers and contextual learning support powered by AI.'**
  String get aboutUsFeature2Desc;

  /// No description provided for @aboutUsFeature3Title.
  ///
  /// In en, this message translates to:
  /// **'Verified Certifications'**
  String get aboutUsFeature3Title;

  /// No description provided for @aboutUsFeature3Desc.
  ///
  /// In en, this message translates to:
  /// **'Earn verified credentials and share your achievements with confidence.'**
  String get aboutUsFeature3Desc;

  /// No description provided for @aboutUsFeature4Title.
  ///
  /// In en, this message translates to:
  /// **'Live Rooms & Collaboration'**
  String get aboutUsFeature4Title;

  /// No description provided for @aboutUsFeature4Desc.
  ///
  /// In en, this message translates to:
  /// **'Engage in live demos, department discussions, and active Q&A forums.'**
  String get aboutUsFeature4Desc;

  /// No description provided for @aboutUsFeature5Title.
  ///
  /// In en, this message translates to:
  /// **'Questions Bank & Quizzes'**
  String get aboutUsFeature5Title;

  /// No description provided for @aboutUsFeature5Desc.
  ///
  /// In en, this message translates to:
  /// **'Sharpen your knowledge with comprehensive practice quizzes and real-time feedback.'**
  String get aboutUsFeature5Desc;

  /// No description provided for @aboutUsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get aboutUsVersion;

  /// No description provided for @aboutUsRights.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved.'**
  String get aboutUsRights;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Discover Interactive Learning'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore structured video courses, interactive rooms, and comprehensive study materials designed to accelerate your growth.'**
  String get onboardingSlide1Subtitle;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Smart AI Study Companion'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Master difficult topics with instant, contextual AI guidance and connect with peers and mentors in real-time.'**
  String get onboardingSlide2Subtitle;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Assess & Earn Certifications'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluate your skills with custom quizzes, questions banks, and receive verified certificates to showcase your achievements.'**
  String get onboardingSlide3Subtitle;

  /// No description provided for @tileMessageAdmins.
  ///
  /// In en, this message translates to:
  /// **'Message Admins'**
  String get tileMessageAdmins;

  /// No description provided for @tileHelpFAQ.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get tileHelpFAQ;

  /// No description provided for @tilePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get tilePrivacyPolicy;

  /// No description provided for @btnLogOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get btnLogOut;

  /// No description provided for @profileEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get profileEnrolled;

  /// No description provided for @profileDemos.
  ///
  /// In en, this message translates to:
  /// **'Demos'**
  String get profileDemos;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @payAndCreate.
  ///
  /// In en, this message translates to:
  /// **'Pay \${price} & Create'**
  String payAndCreate(String price);

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @reviewDemoDetails.
  ///
  /// In en, this message translates to:
  /// **'Review your demo details and complete the payment.'**
  String get reviewDemoDetails;

  /// No description provided for @baseDemoReservation.
  ///
  /// In en, this message translates to:
  /// **'Base Demo Reservation'**
  String get baseDemoReservation;

  /// No description provided for @selectedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Selected Features'**
  String get selectedFeatures;

  /// No description provided for @noFeaturesSelected.
  ///
  /// In en, this message translates to:
  /// **'No features selected.'**
  String get noFeaturesSelected;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @startWithName.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start with a name'**
  String get startWithName;

  /// No description provided for @giveCatchyTitle.
  ///
  /// In en, this message translates to:
  /// **'Give your new demo a catchy title so you can easily identify it later.'**
  String get giveCatchyTitle;

  /// No description provided for @labelDemoName.
  ///
  /// In en, this message translates to:
  /// **'Demo Name'**
  String get labelDemoName;

  /// No description provided for @hintDemoName.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flutter Advanced Course'**
  String get hintDemoName;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get labelDescription;

  /// No description provided for @hintDescription.
  ///
  /// In en, this message translates to:
  /// **'What is this demo about?'**
  String get hintDescription;

  /// No description provided for @errorDemoNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Demo name is required, cannot be left empty'**
  String get errorDemoNameRequired;

  /// No description provided for @superchargeDemo.
  ///
  /// In en, this message translates to:
  /// **'Supercharge your Demo'**
  String get superchargeDemo;

  /// No description provided for @selectAddons.
  ///
  /// In en, this message translates to:
  /// **'Select optional add-ons to enhance your room. You can skip this if you don\'t need any.'**
  String get selectAddons;

  /// No description provided for @descriptionRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequiredError;

  /// No description provided for @uploadDemoImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Demo Image'**
  String get uploadDemoImage;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload image'**
  String get tapToUpload;

  /// No description provided for @selectPlan.
  ///
  /// In en, this message translates to:
  /// **'Select a Plan'**
  String get selectPlan;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @levelUpYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Level Up your plan'**
  String get levelUpYourPlan;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @restricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get restricted;

  /// No description provided for @daysLeftText.
  ///
  /// In en, this message translates to:
  /// **'{days} days left in free trial'**
  String daysLeftText(int days);

  /// No description provided for @createDemo.
  ///
  /// In en, this message translates to:
  /// **'Create Demo'**
  String get createDemo;

  /// No description provided for @demoSummary.
  ///
  /// In en, this message translates to:
  /// **'Demo Summary'**
  String get demoSummary;

  /// No description provided for @demoNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Demo Name'**
  String get demoNameLabel;

  /// No description provided for @demoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get demoDescriptionLabel;

  /// No description provided for @selectedPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Plan'**
  String get selectedPlanLabel;

  /// No description provided for @freeTrialLabel.
  ///
  /// In en, this message translates to:
  /// **'Includes 14-Day Free Trial'**
  String get freeTrialLabel;

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccessful;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been completed successfully. Enjoy your course!'**
  String get paymentSuccessMessage;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'Processing your payment...'**
  String get processingPayment;

  /// No description provided for @limitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get limitReachedMessage;

  /// No description provided for @limitReachedSnackBar.
  ///
  /// In en, this message translates to:
  /// **'This plan limit has been reached , please upgrade the plan'**
  String get limitReachedSnackBar;

  /// No description provided for @addDepartment.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addDepartment;

  /// No description provided for @noDepartmentFound.
  ///
  /// In en, this message translates to:
  /// **'No department found'**
  String get noDepartmentFound;

  /// No description provided for @noSectionFound.
  ///
  /// In en, this message translates to:
  /// **'No department found'**
  String get noSectionFound;

  /// No description provided for @demoMembers.
  ///
  /// In en, this message translates to:
  /// **'Demo Members'**
  String get demoMembers;

  /// No description provided for @usersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No users yet'**
  String get usersEmptyTitle;

  /// No description provided for @usersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Users will show up here once added.'**
  String get usersEmptySubtitle;

  /// No description provided for @usersErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading users.'**
  String get usersErrorGeneric;

  /// No description provided for @viewPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'View personal info'**
  String get viewPersonalInfo;

  /// No description provided for @changePermissions.
  ///
  /// In en, this message translates to:
  /// **'Change permissions'**
  String get changePermissions;

  /// No description provided for @removeFromRoom.
  ///
  /// In en, this message translates to:
  /// **'Remove from room'**
  String get removeFromRoom;

  /// No description provided for @memberRemovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'The Member removed successfully'**
  String get memberRemovedSuccessfully;

  /// No description provided for @userNameHint.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get userNameHint;

  /// No description provided for @searchUser.
  ///
  /// In en, this message translates to:
  /// **'Search user'**
  String get searchUser;

  /// No description provided for @startTyping.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get startTyping;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get sendInvitation;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get pleaseEnterEmail;

  /// No description provided for @emailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get emailSent;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @forgotPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordInstruction;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @pleaseEnterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password'**
  String get pleaseEnterEmailPassword;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @diveBackLearning.
  ///
  /// In en, this message translates to:
  /// **'Dive back into your learning'**
  String get diveBackLearning;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLink;

  /// No description provided for @logInBtn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logInBtn;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpLink;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @passwordRequirementsError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include uppercase, lowercase, a number, and a special character (@\$!%*?&)'**
  String get passwordRequirementsError;

  /// No description provided for @passwordMissingRequirements.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get passwordMissingRequirements;

  /// No description provided for @passwordRequirementMinLength.
  ///
  /// In en, this message translates to:
  /// **'at least 8 characters'**
  String get passwordRequirementMinLength;

  /// No description provided for @passwordRequirementLowercase.
  ///
  /// In en, this message translates to:
  /// **'a lowercase letter'**
  String get passwordRequirementLowercase;

  /// No description provided for @passwordRequirementUppercase.
  ///
  /// In en, this message translates to:
  /// **'an uppercase letter'**
  String get passwordRequirementUppercase;

  /// No description provided for @passwordRequirementNumber.
  ///
  /// In en, this message translates to:
  /// **'a number'**
  String get passwordRequirementNumber;

  /// No description provided for @passwordRequirementSpecialCharacter.
  ///
  /// In en, this message translates to:
  /// **'a special character (@\$!%*?&)'**
  String get passwordRequirementSpecialCharacter;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successTitle;

  /// No description provided for @goToLoginBtn.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLoginBtn;

  /// No description provided for @resetPasswordScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordScreenTitle;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @enterNewPasswordBelow.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password below.'**
  String get enterNewPasswordBelow;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// No description provided for @resetPasswordBtn.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordBtn;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @startLearningToday.
  ///
  /// In en, this message translates to:
  /// **'Start your ocean of learning today'**
  String get startLearningToday;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameHint;

  /// No description provided for @createAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountBtn;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logInLink.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logInLink;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get checkYourEmail;

  /// No description provided for @verificationLinkSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification link to:'**
  String get verificationLinkSent;

  /// No description provided for @verifyBeforeLogin.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email before logging in.'**
  String get verifyBeforeLogin;

  /// No description provided for @backToLoginBtn.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLoginBtn;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthHint;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name should not be empty'**
  String get nameRequiredError;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @enterPasswordToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your current and new password to continue'**
  String get enterPasswordToContinue;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get oldPassword;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @resendVerificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend verification email'**
  String get resendVerificationEmail;

  /// No description provided for @didntReceiveEmail.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email?'**
  String get didntReceiveEmail;

  /// No description provided for @diagramEditor.
  ///
  /// In en, this message translates to:
  /// **'Diagram Editor'**
  String get diagramEditor;

  /// No description provided for @diagramPreview.
  ///
  /// In en, this message translates to:
  /// **'Diagram Preview'**
  String get diagramPreview;

  /// No description provided for @savedAt.
  ///
  /// In en, this message translates to:
  /// **'Saved at'**
  String get savedAt;

  /// No description provided for @saveDiagram.
  ///
  /// In en, this message translates to:
  /// **'Save Diagram'**
  String get saveDiagram;

  /// No description provided for @whatDoYouWantToSave.
  ///
  /// In en, this message translates to:
  /// **'What do you want to save?'**
  String get whatDoYouWantToSave;

  /// No description provided for @xmlOnly.
  ///
  /// In en, this message translates to:
  /// **'XML only'**
  String get xmlOnly;

  /// No description provided for @pngOnly.
  ///
  /// In en, this message translates to:
  /// **'PNG only'**
  String get pngOnly;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied'**
  String get storagePermissionDenied;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @xmlSaved.
  ///
  /// In en, this message translates to:
  /// **'XML Saved'**
  String get xmlSaved;

  /// No description provided for @pngSaved.
  ///
  /// In en, this message translates to:
  /// **'PNG saved'**
  String get pngSaved;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @extraSecurityLayer.
  ///
  /// In en, this message translates to:
  /// **'Extra security layer for your account'**
  String get extraSecurityLayer;

  /// No description provided for @enableTwoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Authentication'**
  String get enableTwoFactorAuth;

  /// No description provided for @enableTwoFactorAuthMessage.
  ///
  /// In en, this message translates to:
  /// **'We will send a verification code to your email.'**
  String get enableTwoFactorAuthMessage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @codeSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email'**
  String get codeSentToEmail;

  /// No description provided for @enterPasswordToEnable2FA.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to enable two-factor authentication'**
  String get enterPasswordToEnable2FA;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @enableTwoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Enable Two-Factor Authentication'**
  String get enableTwoFactorAuthentication;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR Code'**
  String get scanQrCode;

  /// No description provided for @scanQrCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Open your authenticator app and scan the QR code below. Then enter the 6-digit verification code to complete the setup.'**
  String get scanQrCodeDescription;

  /// No description provided for @authenticationCode.
  ///
  /// In en, this message translates to:
  /// **'Authentication Code'**
  String get authenticationCode;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @twoFactorEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication has been enabled successfully.'**
  String get twoFactorEnabledSuccessfully;

  /// No description provided for @lincoCompanyDemo.
  ///
  /// In en, this message translates to:
  /// **'Linco Company Demo'**
  String get lincoCompanyDemo;

  /// No description provided for @byAhmadAhmad.
  ///
  /// In en, this message translates to:
  /// **'By Ahmad Ahmad'**
  String get byAhmadAhmad;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @sections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get sections;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @yourDepartments.
  ///
  /// In en, this message translates to:
  /// **'Your Departments'**
  String get yourDepartments;

  /// No description provided for @yourSections.
  ///
  /// In en, this message translates to:
  /// **'Your Departments'**
  String get yourSections;

  /// No description provided for @yourGroups.
  ///
  /// In en, this message translates to:
  /// **'Your Groups'**
  String get yourGroups;

  /// No description provided for @restrictedDepartments.
  ///
  /// In en, this message translates to:
  /// **'Restricted Departments'**
  String get restrictedDepartments;

  /// No description provided for @restrictedSections.
  ///
  /// In en, this message translates to:
  /// **'Restricted Departments'**
  String get restrictedSections;

  /// No description provided for @restrictedGroups.
  ///
  /// In en, this message translates to:
  /// **'Restricted Groups'**
  String get restrictedGroups;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroup;

  /// No description provided for @removeGroup.
  ///
  /// In en, this message translates to:
  /// **'Remove Group'**
  String get removeGroup;

  /// No description provided for @groupAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group added successfully'**
  String get groupAddedSuccessfully;

  /// No description provided for @groupUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group updated successfully'**
  String get groupUpdatedSuccessfully;

  /// No description provided for @groupDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group deleted successfully'**
  String get groupDeletedSuccessfully;

  /// No description provided for @deleteGroupConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this group? This action cannot be undone.'**
  String get deleteGroupConfirmation;

  /// No description provided for @noGroupFound.
  ///
  /// In en, this message translates to:
  /// **'No groups found'**
  String get noGroupFound;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupName;

  /// No description provided for @enterGroupName.
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// No description provided for @groupDescription.
  ///
  /// In en, this message translates to:
  /// **'Group Description'**
  String get groupDescription;

  /// No description provided for @enterGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter group description'**
  String get enterGroupDescription;

  /// No description provided for @groupJourney.
  ///
  /// In en, this message translates to:
  /// **'GROUP JOURNEY'**
  String get groupJourney;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @frontendSection.
  ///
  /// In en, this message translates to:
  /// **'Frontend Section'**
  String get frontendSection;

  /// No description provided for @frontendSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'the main section for developing web pages and dashboard'**
  String get frontendSectionSubtitle;

  /// No description provided for @project1Team.
  ///
  /// In en, this message translates to:
  /// **'Project 1 Team'**
  String get project1Team;

  /// No description provided for @project1TeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'building project 1 with many members'**
  String get project1TeamSubtitle;

  /// No description provided for @verify2FASubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from your authenticator app.'**
  String get verify2FASubtitle;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCode;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code'**
  String get invalidCode;

  /// No description provided for @createCourse.
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get createCourse;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get courseTitle;

  /// No description provided for @courseDescription.
  ///
  /// In en, this message translates to:
  /// **'Course Description'**
  String get courseDescription;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @publicVisibilityWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish to the public library?'**
  String get publicVisibilityWarningTitle;

  /// No description provided for @publicVisibilityWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'Choosing Public makes this course available in the public library after you save your changes.'**
  String get publicVisibilityWarningMessage;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @fillAllFieldsWarning.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fillAllFieldsWarning;

  /// No description provided for @ongoingCourses.
  ///
  /// In en, this message translates to:
  /// **'Ongoing courses'**
  String get ongoingCourses;

  /// No description provided for @courseManagement.
  ///
  /// In en, this message translates to:
  /// **'Course Management'**
  String get courseManagement;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @manageFaq.
  ///
  /// In en, this message translates to:
  /// **'Manage FAQ'**
  String get manageFaq;

  /// No description provided for @manageSections.
  ///
  /// In en, this message translates to:
  /// **'Manage Sections'**
  String get manageSections;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editCourse.
  ///
  /// In en, this message translates to:
  /// **'Edit Course'**
  String get editCourse;

  /// No description provided for @manageCoursesDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your courses, update their details, and continue building them.'**
  String get manageCoursesDescription;

  /// No description provided for @coursesInProgress.
  ///
  /// In en, this message translates to:
  /// **'Courses in Progress'**
  String get coursesInProgress;

  /// No description provided for @addSection.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get addSection;

  /// No description provided for @noSectionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sections yet'**
  String get noSectionsYet;

  /// No description provided for @addLesson.
  ///
  /// In en, this message translates to:
  /// **'Add Lesson'**
  String get addLesson;

  /// No description provided for @noLessonsYet.
  ///
  /// In en, this message translates to:
  /// **'No lessons yet'**
  String get noLessonsYet;

  /// No description provided for @questionsBank.
  ///
  /// In en, this message translates to:
  /// **'Questions Bank'**
  String get questionsBank;

  /// No description provided for @renameSection.
  ///
  /// In en, this message translates to:
  /// **'Rename Section'**
  String get renameSection;

  /// No description provided for @departmentName.
  ///
  /// In en, this message translates to:
  /// **'Department name'**
  String get departmentName;

  /// No description provided for @sectionName.
  ///
  /// In en, this message translates to:
  /// **'Section name'**
  String get sectionName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteSection.
  ///
  /// In en, this message translates to:
  /// **'Delete Section'**
  String get deleteSection;

  /// No description provided for @deleteDepartmantConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this department? This action cannot be undone.'**
  String get deleteDepartmantConfirmation;

  /// No description provided for @deleteSectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this department? This action cannot be undone.'**
  String get deleteSectionConfirmation;

  /// No description provided for @createLesson.
  ///
  /// In en, this message translates to:
  /// **'Create Lesson'**
  String get createLesson;

  /// No description provided for @lessonVideo.
  ///
  /// In en, this message translates to:
  /// **'Lesson Video'**
  String get lessonVideo;

  /// No description provided for @uploadLessonVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload Lesson Video'**
  String get uploadLessonVideo;

  /// No description provided for @lessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Lesson Title'**
  String get lessonTitle;

  /// No description provided for @enterLessonTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson title'**
  String get enterLessonTitle;

  /// No description provided for @lessonDescription.
  ///
  /// In en, this message translates to:
  /// **'Lesson Description'**
  String get lessonDescription;

  /// No description provided for @enterLessonDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter lesson description'**
  String get enterLessonDescription;

  /// No description provided for @lessonAttachments.
  ///
  /// In en, this message translates to:
  /// **'Lesson Attachments'**
  String get lessonAttachments;

  /// No description provided for @addAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add Attachment'**
  String get addAttachment;

  /// No description provided for @attachmentName.
  ///
  /// In en, this message translates to:
  /// **'Attachment name'**
  String get attachmentName;

  /// No description provided for @editAttachment.
  ///
  /// In en, this message translates to:
  /// **'Edit Attachment'**
  String get editAttachment;

  /// No description provided for @deleteAttachment.
  ///
  /// In en, this message translates to:
  /// **'Delete Attachment'**
  String get deleteAttachment;

  /// No description provided for @deleteAttachmentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this attachment?'**
  String get deleteAttachmentConfirmation;

  /// No description provided for @noAttachments.
  ///
  /// In en, this message translates to:
  /// **'No attachments yet'**
  String get noAttachments;

  /// No description provided for @saveLesson.
  ///
  /// In en, this message translates to:
  /// **'Save Lesson'**
  String get saveLesson;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @lessonManagement.
  ///
  /// In en, this message translates to:
  /// **'Lesson Management'**
  String get lessonManagement;

  /// No description provided for @editLesson.
  ///
  /// In en, this message translates to:
  /// **'Edit Lesson'**
  String get editLesson;

  /// No description provided for @noTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags available'**
  String get noTagsAvailable;

  /// No description provided for @noCoursesFound.
  ///
  /// In en, this message translates to:
  /// **'No courses found'**
  String get noCoursesFound;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @deleteCourseTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Course'**
  String get deleteCourseTitle;

  /// No description provided for @deleteCourseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this course?'**
  String get deleteCourseConfirmation;

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get failedToUploadImage;

  /// No description provided for @demoCourses.
  ///
  /// In en, this message translates to:
  /// **'Demo Courses'**
  String get demoCourses;

  /// No description provided for @demoCoursesDescription.
  ///
  /// In en, this message translates to:
  /// **'Courses available in your demo'**
  String get demoCoursesDescription;

  /// No description provided for @availableCourses.
  ///
  /// In en, this message translates to:
  /// **'Available Courses'**
  String get availableCourses;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @publishCourse.
  ///
  /// In en, this message translates to:
  /// **'Publish Course'**
  String get publishCourse;

  /// No description provided for @publishCourseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to publish this course? After publishing, it can no longer be edited.'**
  String get publishCourseConfirmation;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @producedBy.
  ///
  /// In en, this message translates to:
  /// **'Produced by'**
  String get producedBy;

  /// No description provided for @aboutThisCourse.
  ///
  /// In en, this message translates to:
  /// **'About this course'**
  String get aboutThisCourse;

  /// No description provided for @courseContent.
  ///
  /// In en, this message translates to:
  /// **'Course Content'**
  String get courseContent;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @courseCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Course created successfully'**
  String get courseCreatedSuccessfully;

  /// No description provided for @noSectionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sections available'**
  String get noSectionsAvailable;

  /// No description provided for @demoCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Demo Created Successfully!'**
  String get demoCreatedSuccessfully;

  /// No description provided for @removeUserPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove user?'**
  String get removeUserPrompt;

  /// No description provided for @areYouSureRemoveUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this user?'**
  String get areYouSureRemoveUser;

  /// No description provided for @testPage.
  ///
  /// In en, this message translates to:
  /// **'Test Page'**
  String get testPage;

  /// No description provided for @openDiagram.
  ///
  /// In en, this message translates to:
  /// **'Open Diagram'**
  String get openDiagram;

  /// No description provided for @photopeaEditor.
  ///
  /// In en, this message translates to:
  /// **'Photopea Editor'**
  String get photopeaEditor;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @quizResult.
  ///
  /// In en, this message translates to:
  /// **'Quiz Result'**
  String get quizResult;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @confirmAnswer.
  ///
  /// In en, this message translates to:
  /// **'Confirm Answer'**
  String get confirmAnswer;

  /// No description provided for @usersTab.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTab;

  /// No description provided for @demoStats.
  ///
  /// In en, this message translates to:
  /// **'Demo Stats'**
  String get demoStats;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @areYouSureSendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to send an invitation to this user?'**
  String get areYouSureSendInvitation;

  /// No description provided for @userAlreadyInvited.
  ///
  /// In en, this message translates to:
  /// **'User is already invited to this demo'**
  String get userAlreadyInvited;

  /// No description provided for @invitationSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent successfully'**
  String get invitationSentSuccessfully;

  /// No description provided for @invitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get invitationsTitle;

  /// No description provided for @invitationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your received demo invitations'**
  String get invitationsSubtitle;

  /// No description provided for @noNewInvitations.
  ///
  /// In en, this message translates to:
  /// **'No invitations available'**
  String get noNewInvitations;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get noNewNotifications;

  /// No description provided for @selectVideoFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a video first.'**
  String get selectVideoFirst;

  /// No description provided for @operationInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation in Progress'**
  String get operationInProgressTitle;

  /// No description provided for @operationInProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'A video upload or lesson creation is currently in progress. If you leave now, the video may finish uploading without being linked to the lesson. Are you sure you want to leave?'**
  String get operationInProgressMessage;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @leaveAnyway.
  ///
  /// In en, this message translates to:
  /// **'Leave Anyway'**
  String get leaveAnyway;

  /// No description provided for @deleteLesson.
  ///
  /// In en, this message translates to:
  /// **'Delete Lesson'**
  String get deleteLesson;

  /// No description provided for @deleteLessonFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the lesson.'**
  String get deleteLessonFailed;

  /// No description provided for @leaveWhileBusyTitle.
  ///
  /// In en, this message translates to:
  /// **'Operation in Progress'**
  String get leaveWhileBusyTitle;

  /// No description provided for @leaveWhileBusyMessage.
  ///
  /// In en, this message translates to:
  /// **'An upload or save operation is currently in progress. If you leave now, your changes may be lost. Are you sure you want to leave?'**
  String get leaveWhileBusyMessage;

  /// No description provided for @lessonUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully.'**
  String get lessonUpdatedSuccessfully;

  /// No description provided for @lessonUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes.'**
  String get lessonUpdateFailed;

  /// No description provided for @deleteLessonConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this lesson? This action cannot be undone.'**
  String get deleteLessonConfirmation;

  /// No description provided for @pressToSelectVideo.
  ///
  /// In en, this message translates to:
  /// **'Press to select video'**
  String get pressToSelectVideo;

  /// No description provided for @preparingToUpload.
  ///
  /// In en, this message translates to:
  /// **'Preparing to upload...'**
  String get preparingToUpload;

  /// No description provided for @processingVideo.
  ///
  /// In en, this message translates to:
  /// **'processing video...'**
  String get processingVideo;

  /// No description provided for @uploadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Uploading video...'**
  String get uploadingVideo;

  /// No description provided for @invitedBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by {firstName} {lastName}'**
  String invitedBy(String firstName, String lastName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @lessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessons;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @lessonOverview.
  ///
  /// In en, this message translates to:
  /// **'Lesson overview'**
  String get lessonOverview;

  /// No description provided for @failedToOpenAttachment.
  ///
  /// In en, this message translates to:
  /// **'Failed to open attachment'**
  String get failedToOpenAttachment;

  /// No description provided for @videoLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video'**
  String get videoLoadFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @noFaqAvailable.
  ///
  /// In en, this message translates to:
  /// **'No FAQs available'**
  String get noFaqAvailable;

  /// No description provided for @addFaq.
  ///
  /// In en, this message translates to:
  /// **'Add FAQ'**
  String get addFaq;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @questionIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Question is required'**
  String get questionIsRequired;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @answerIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Answer is required'**
  String get answerIsRequired;

  /// No description provided for @deleteFaq.
  ///
  /// In en, this message translates to:
  /// **'Delete FAQ'**
  String get deleteFaq;

  /// No description provided for @deleteFaqConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{question}\"?'**
  String deleteFaqConfirmation(Object question);

  /// No description provided for @tapToAddFaq.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add FAQ\" to create the first one.'**
  String get tapToAddFaq;

  /// No description provided for @noFaqsYet.
  ///
  /// In en, this message translates to:
  /// **'No FAQs yet'**
  String get noFaqsYet;

  /// No description provided for @faqs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get faqs;

  /// No description provided for @enterSectionName.
  ///
  /// In en, this message translates to:
  /// **'Enter section name'**
  String get enterSectionName;

  /// No description provided for @departmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Department Description'**
  String get departmentDescription;

  /// No description provided for @sectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Department Description'**
  String get sectionDescription;

  /// No description provided for @enterSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter section description'**
  String get enterSectionDescription;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @selectManager.
  ///
  /// In en, this message translates to:
  /// **'Select manager'**
  String get selectManager;

  /// No description provided for @pleaseSelectManager.
  ///
  /// In en, this message translates to:
  /// **'Please select a manager'**
  String get pleaseSelectManager;

  /// No description provided for @departmentAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Department added successfully'**
  String get departmentAddedSuccessfully;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Fields is required'**
  String get requiredField;

  /// No description provided for @departmentMainPage.
  ///
  /// In en, this message translates to:
  /// **'Main Page'**
  String get departmentMainPage;

  /// No description provided for @departmentCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get departmentCourses;

  /// No description provided for @departmentLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get departmentLeaderboard;

  /// No description provided for @departmentSendReport.
  ///
  /// In en, this message translates to:
  /// **'Send Report'**
  String get departmentSendReport;

  /// No description provided for @departmentChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get departmentChat;

  /// No description provided for @departmentLives.
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get departmentLives;

  /// No description provided for @createLiveStream.
  ///
  /// In en, this message translates to:
  /// **'Create Live Stream'**
  String get createLiveStream;

  /// No description provided for @startLiveStream.
  ///
  /// In en, this message translates to:
  /// **'Start Stream'**
  String get startLiveStream;

  /// No description provided for @endLiveStream.
  ///
  /// In en, this message translates to:
  /// **'End Stream'**
  String get endLiveStream;

  /// No description provided for @joinLiveStream.
  ///
  /// In en, this message translates to:
  /// **'Join Stream'**
  String get joinLiveStream;

  /// No description provided for @liveStreamTitle.
  ///
  /// In en, this message translates to:
  /// **'Stream Title'**
  String get liveStreamTitle;

  /// No description provided for @liveStreamDescription.
  ///
  /// In en, this message translates to:
  /// **'Stream Description'**
  String get liveStreamDescription;

  /// No description provided for @scheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduleTime;

  /// No description provided for @liveStatusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveStatusLive;

  /// No description provided for @liveStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED'**
  String get liveStatusScheduled;

  /// No description provided for @liveStatusEnded.
  ///
  /// In en, this message translates to:
  /// **'ENDED'**
  String get liveStatusEnded;

  /// No description provided for @noLiveStreamsFound.
  ///
  /// In en, this message translates to:
  /// **'No live streams available'**
  String get noLiveStreamsFound;

  /// No description provided for @editLiveStream.
  ///
  /// In en, this message translates to:
  /// **'Edit Stream'**
  String get editLiveStream;

  /// No description provided for @liveStreamCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Live stream created successfully'**
  String get liveStreamCreatedSuccessfully;

  /// No description provided for @liveStreamEnded.
  ///
  /// In en, this message translates to:
  /// **'Live stream ended'**
  String get liveStreamEnded;

  /// No description provided for @departmentMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get departmentMembers;

  /// No description provided for @noMembersInDepartment.
  ///
  /// In en, this message translates to:
  /// **'No members in this department yet.'**
  String get noMembersInDepartment;

  /// No description provided for @selectJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Job Title'**
  String get selectJobTitle;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @intern.
  ///
  /// In en, this message translates to:
  /// **'Intern'**
  String get intern;

  /// No description provided for @junior.
  ///
  /// In en, this message translates to:
  /// **'Junior'**
  String get junior;

  /// No description provided for @senior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get senior;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @memberAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Member added successfully'**
  String get memberAddedSuccessfully;

  /// No description provided for @searchDemoMembers.
  ///
  /// In en, this message translates to:
  /// **'Search Demo Members'**
  String get searchDemoMembers;

  /// No description provided for @searchMembersHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or email...'**
  String get searchMembersHint;

  /// No description provided for @noMembersFound.
  ///
  /// In en, this message translates to:
  /// **'No members found'**
  String get noMembersFound;

  /// No description provided for @removeMemberPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove Member'**
  String get removeMemberPrompt;

  /// No description provided for @areYouSureRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this member from the department?'**
  String get areYouSureRemoveMember;

  /// No description provided for @editDepartment.
  ///
  /// In en, this message translates to:
  /// **'Edit Department'**
  String get editDepartment;

  /// No description provided for @removeDepartment.
  ///
  /// In en, this message translates to:
  /// **'Remove Department'**
  String get removeDepartment;

  /// No description provided for @departmentUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Department updated successfully'**
  String get departmentUpdatedSuccessfully;

  /// No description provided for @departmentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Department deleted successfully'**
  String get departmentDeletedSuccessfully;

  /// No description provided for @departmentLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Road Map'**
  String get departmentLearningPath;

  /// No description provided for @departmentJourney.
  ///
  /// In en, this message translates to:
  /// **'DEPARTMENT JOURNEY'**
  String get departmentJourney;

  /// No description provided for @learningPath.
  ///
  /// In en, this message translates to:
  /// **'Road Map'**
  String get learningPath;

  /// No description provided for @addCourseToPath.
  ///
  /// In en, this message translates to:
  /// **'Add Course to Path'**
  String get addCourseToPath;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @fetchDataPrompt.
  ///
  /// In en, this message translates to:
  /// **'Request data to view the path'**
  String get fetchDataPrompt;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @departmentRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Department Roadmap'**
  String get departmentRoadmap;

  /// No description provided for @roadmapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step career path, skills, and projects.'**
  String get roadmapSubtitle;

  /// No description provided for @newRoadmap.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newRoadmap;

  /// No description provided for @generateRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Generate Roadmap'**
  String get generateRoadmap;

  /// No description provided for @generateRoadmapDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a title or career role (e.g. Flutter Engineer, Data Scientist) to generate a customized road map:'**
  String get generateRoadmapDesc;

  /// No description provided for @roadmapTitleOrRole.
  ///
  /// In en, this message translates to:
  /// **'Roadmap Title / Role'**
  String get roadmapTitleOrRole;

  /// No description provided for @roadmapTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Mobile Developer'**
  String get roadmapTitleHint;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @noRoadmapYet.
  ///
  /// In en, this message translates to:
  /// **'No Learning Roadmap Yet'**
  String get noRoadmapYet;

  /// No description provided for @emptyRoadmapDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a structured weekly learning roadmap with skills, projects, and deliverables for this department.'**
  String get emptyRoadmapDesc;

  /// No description provided for @generatingRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Generating Learning Roadmap...'**
  String get generatingRoadmap;

  /// No description provided for @generatingRoadmapSub.
  ///
  /// In en, this message translates to:
  /// **'Organizing topics, skills, and projects'**
  String get generatingRoadmapSub;

  /// No description provided for @failedToLoadRoadmap.
  ///
  /// In en, this message translates to:
  /// **'Failed to Load Roadmap'**
  String get failedToLoadRoadmap;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @weeksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Weeks'**
  String weeksCount(Object count);

  /// No description provided for @skillsCovered.
  ///
  /// In en, this message translates to:
  /// **'Skills Covered'**
  String get skillsCovered;

  /// No description provided for @practicalProjects.
  ///
  /// In en, this message translates to:
  /// **'Practical Projects'**
  String get practicalProjects;

  /// No description provided for @deliverables.
  ///
  /// In en, this message translates to:
  /// **'Deliverables'**
  String get deliverables;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @weekPrefix.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String weekPrefix(Object week);

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exportingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get exportingPdf;

  /// No description provided for @deleteCourse.
  ///
  /// In en, this message translates to:
  /// **'Delete Course'**
  String get deleteCourse;

  /// No description provided for @noCoursesInDepartment.
  ///
  /// In en, this message translates to:
  /// **'No courses in this department.'**
  String get noCoursesInDepartment;

  /// No description provided for @publicLibrary.
  ///
  /// In en, this message translates to:
  /// **'Public Library'**
  String get publicLibrary;

  /// No description provided for @searchCourses.
  ///
  /// In en, this message translates to:
  /// **'Search courses, or skills..'**
  String get searchCourses;

  /// No description provided for @allFilters.
  ///
  /// In en, this message translates to:
  /// **'All Filters'**
  String get allFilters;

  /// No description provided for @searchTags.
  ///
  /// In en, this message translates to:
  /// **'Search tags'**
  String get searchTags;

  /// No description provided for @selectedTagsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedTagsCount(int count);

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @showingResults.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} results for your search'**
  String showingResults(Object count);

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @enrollNow.
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get enrollNow;

  /// No description provided for @enrollToWatchLesson.
  ///
  /// In en, this message translates to:
  /// **'Enroll to Watch Lesson'**
  String get enrollToWatchLesson;

  /// No description provided for @exploreNewSkills.
  ///
  /// In en, this message translates to:
  /// **'Discover Your Passion & Learn New Skills'**
  String get exploreNewSkills;

  /// No description provided for @expandYourKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Hundreds of courses waiting for you'**
  String get expandYourKnowledge;

  /// No description provided for @checkoutError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while creating the payment session'**
  String get checkoutError;

  /// No description provided for @coursePurchaseSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You have successfully purchased \"{courseTitle}\". Start learning now!'**
  String coursePurchaseSuccessMessage(String courseTitle);

  /// No description provided for @alreadyEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Already Enrolled'**
  String get alreadyEnrolled;

  /// No description provided for @backToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Back to Library'**
  String get backToLibrary;

  /// No description provided for @aiAssistantTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Study Assistant'**
  String get aiAssistantTitle;

  /// No description provided for @askQuestionSection.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get askQuestionSection;

  /// No description provided for @askQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., What is the difference between Dependency Injection and Singleton?'**
  String get askQuestionHint;

  /// No description provided for @askButton.
  ///
  /// In en, this message translates to:
  /// **'Ask Assistant'**
  String get askButton;

  /// No description provided for @topicQuizSection.
  ///
  /// In en, this message translates to:
  /// **'Topic-Specific Quiz'**
  String get topicQuizSection;

  /// No description provided for @topicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Clean Architecture'**
  String get topicHint;

  /// No description provided for @questionCountHint.
  ///
  /// In en, this message translates to:
  /// **'Number of questions'**
  String get questionCountHint;

  /// No description provided for @generateTopicQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Generate Topic Quiz'**
  String get generateTopicQuizButton;

  /// No description provided for @randomQuizSection.
  ///
  /// In en, this message translates to:
  /// **'Random Course Quiz'**
  String get randomQuizSection;

  /// No description provided for @generateRandomQuizButton.
  ///
  /// In en, this message translates to:
  /// **'Generate Random Quiz'**
  String get generateRandomQuizButton;

  /// No description provided for @aiResponseTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Response'**
  String get aiResponseTitle;

  /// No description provided for @aiFulfillingRequest.
  ///
  /// In en, this message translates to:
  /// **'AI is fulfilling your request'**
  String get aiFulfillingRequest;

  /// No description provided for @noDataYet.
  ///
  /// In en, this message translates to:
  /// **'Ask a question or generate a quiz to see the AI insights here.'**
  String get noDataYet;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error occurred: '**
  String get errorPrefix;

  /// No description provided for @chatConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get chatConnecting;

  /// No description provided for @chatReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting to chat...'**
  String get chatReconnecting;

  /// No description provided for @chatConnectionLost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Retrying...'**
  String get chatConnectionLost;

  /// No description provided for @chatNoMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessagesYet;

  /// No description provided for @chatFirstMessagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Be the first to start the conversation!'**
  String get chatFirstMessagePrompt;

  /// No description provided for @chatMessageDeleted.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted'**
  String get chatMessageDeleted;

  /// No description provided for @chatEditedTag.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get chatEditedTag;

  /// No description provided for @chatReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get chatReply;

  /// No description provided for @chatEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get chatEdit;

  /// No description provided for @chatDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chatDelete;

  /// No description provided for @chatTypeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get chatTypeMessageHint;

  /// No description provided for @chatEditMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Edit message...'**
  String get chatEditMessageHint;

  /// No description provided for @chatAddAttachment.
  ///
  /// In en, this message translates to:
  /// **'Add photo or PDF'**
  String get chatAddAttachment;

  /// No description provided for @chatAttachmentReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file.'**
  String get chatAttachmentReadFailed;

  /// No description provided for @chatUploadingAttachment.
  ///
  /// In en, this message translates to:
  /// **'Uploading attachment...'**
  String get chatUploadingAttachment;

  /// No description provided for @chatPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get chatPhoto;

  /// No description provided for @chatFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get chatFile;

  /// No description provided for @chatOpenAttachmentFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open attachment.'**
  String get chatOpenAttachmentFailed;

  /// No description provided for @chatOnlineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} online'**
  String chatOnlineCount(int count);

  /// No description provided for @chatOnlineMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Online members'**
  String get chatOnlineMembersTitle;

  /// No description provided for @chatReplyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {name}'**
  String chatReplyingTo(String name);

  /// No description provided for @chatEditingMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing Message'**
  String get chatEditingMessageTitle;

  /// No description provided for @chatMemberIsTyping.
  ///
  /// In en, this message translates to:
  /// **'{name} is typing...'**
  String chatMemberIsTyping(String name);

  /// No description provided for @chatMembersAreTyping.
  ///
  /// In en, this message translates to:
  /// **'{count} members are typing...'**
  String chatMembersAreTyping(int count);

  /// No description provided for @chatFailedToLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load message history'**
  String get chatFailedToLoadHistory;

  /// No description provided for @deleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Question'**
  String get deleteQuestion;

  /// No description provided for @deleteQuestionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this question?'**
  String get deleteQuestionConfirmation;

  /// No description provided for @deleteQuestionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete question'**
  String get deleteQuestionFailed;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @questionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your question'**
  String get questionHint;

  /// No description provided for @choicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Choices'**
  String get choicesLabel;

  /// No description provided for @choiceHint.
  ///
  /// In en, this message translates to:
  /// **'Choice'**
  String get choiceHint;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @selectCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one correct answer'**
  String get selectCorrectAnswer;

  /// No description provided for @createQuestionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create question'**
  String get createQuestionFailed;

  /// No description provided for @noQuestionsYet.
  ///
  /// In en, this message translates to:
  /// **'No questions yet'**
  String get noQuestionsYet;

  /// No description provided for @enterQuestionFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter the question first'**
  String get enterQuestionFirst;

  /// No description provided for @choicesMustBeUnique.
  ///
  /// In en, this message translates to:
  /// **'Each choice must be different from the others'**
  String get choicesMustBeUnique;

  /// No description provided for @questionsBankDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage and review all questions in this section\'s question bank'**
  String get questionsBankDescription;

  /// No description provided for @questionsCount.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questionsCount;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkAnswer;

  /// No description provided for @correctAnswerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Correct answer!'**
  String get correctAnswerFeedback;

  /// No description provided for @incorrectAnswerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer'**
  String get incorrectAnswerFeedback;

  /// No description provided for @addChoice.
  ///
  /// In en, this message translates to:
  /// **'Add choice'**
  String get addChoice;

  /// No description provided for @inquiries.
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get inquiries;

  /// No description provided for @sendInquiries.
  ///
  /// In en, this message translates to:
  /// **'Send Inquiries'**
  String get sendInquiries;

  /// No description provided for @inquiriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Send complaints, questions, or feedback to owner'**
  String get inquiriesDescription;

  /// No description provided for @inquiriesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Inquiries feature coming soon'**
  String get inquiriesComingSoon;

  /// No description provided for @demoOptions.
  ///
  /// In en, this message translates to:
  /// **'Demo Options'**
  String get demoOptions;

  /// No description provided for @coursesOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage course selection'**
  String get coursesOptionDesc;

  /// No description provided for @publicLibraryOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Access shared public resources'**
  String get publicLibraryOptionDesc;

  /// No description provided for @usersTabOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage demo members and roles'**
  String get usersTabOptionDesc;

  /// No description provided for @demoStatsOptionDesc.
  ///
  /// In en, this message translates to:
  /// **'View analytics and statistics'**
  String get demoStatsOptionDesc;

  /// No description provided for @quizInformation.
  ///
  /// In en, this message translates to:
  /// **'Quiz Information'**
  String get quizInformation;

  /// No description provided for @addExam.
  ///
  /// In en, this message translates to:
  /// **'Add Exam'**
  String get addExam;

  /// No description provided for @editExam.
  ///
  /// In en, this message translates to:
  /// **'Edit Exam'**
  String get editExam;

  /// No description provided for @enterExamDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the details below to configure the exam settings.'**
  String get enterExamDetailsDescription;

  /// No description provided for @examTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Title'**
  String get examTitle;

  /// No description provided for @examTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Midterm Assessment'**
  String get examTitleHint;

  /// No description provided for @numberOfQuestions.
  ///
  /// In en, this message translates to:
  /// **'Number of Questions'**
  String get numberOfQuestions;

  /// No description provided for @numberOfQuestionsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get numberOfQuestionsHint;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (Minutes)'**
  String get durationMinutes;

  /// No description provided for @durationMinutesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 30'**
  String get durationMinutesHint;

  /// No description provided for @examCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Exam created successfully'**
  String get examCreatedSuccessfully;

  /// No description provided for @examUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Exam updated successfully'**
  String get examUpdatedSuccessfully;

  /// No description provided for @failedToUpdateExam.
  ///
  /// In en, this message translates to:
  /// **'Failed to update exam'**
  String get failedToUpdateExam;

  /// No description provided for @failedToCreateExam.
  ///
  /// In en, this message translates to:
  /// **'Failed to create exam'**
  String get failedToCreateExam;

  /// No description provided for @selectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select your answer'**
  String get selectAnswer;

  /// No description provided for @submitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Submit Quiz'**
  String get submitQuiz;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed'**
  String get quizCompleted;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job! Keep it up.'**
  String get greatJob;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @leaveQuiz.
  ///
  /// In en, this message translates to:
  /// **'Leave Quiz?'**
  String get leaveQuiz;

  /// No description provided for @leaveQuizMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost if you leave now.'**
  String get leaveQuizMessage;

  /// No description provided for @noQuestionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No questions are available.'**
  String get noQuestionsAvailable;

  /// No description provided for @noInquiriesYet.
  ///
  /// In en, this message translates to:
  /// **'No inquiries found'**
  String get noInquiriesYet;

  /// No description provided for @createInquiry.
  ///
  /// In en, this message translates to:
  /// **'New Inquiry'**
  String get createInquiry;

  /// No description provided for @inquirySubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get inquirySubject;

  /// No description provided for @inquirySubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Enter inquiry subject...'**
  String get inquirySubjectHint;

  /// No description provided for @inquiryMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get inquiryMessage;

  /// No description provided for @inquiryMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your inquiry here...'**
  String get inquiryMessageHint;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @replyHint.
  ///
  /// In en, this message translates to:
  /// **'Write your reply here...'**
  String get replyHint;

  /// No description provided for @sendReply.
  ///
  /// In en, this message translates to:
  /// **'Send Reply'**
  String get sendReply;

  /// No description provided for @inquirySentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Inquiry submitted successfully'**
  String get inquirySentSuccessfully;

  /// No description provided for @replySentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reply sent successfully'**
  String get replySentSuccessfully;

  /// No description provided for @inquiryDetails.
  ///
  /// In en, this message translates to:
  /// **'Inquiry Details'**
  String get inquiryDetails;

  /// No description provided for @senderDetails.
  ///
  /// In en, this message translates to:
  /// **'Sender Details'**
  String get senderDetails;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusReplied.
  ///
  /// In en, this message translates to:
  /// **'Replied'**
  String get statusReplied;

  /// No description provided for @awaitingReply.
  ///
  /// In en, this message translates to:
  /// **'Awaiting response from owner'**
  String get awaitingReply;

  /// No description provided for @ownerReply.
  ///
  /// In en, this message translates to:
  /// **'Owner Reply'**
  String get ownerReply;

  /// No description provided for @notificationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notificationPermissionTitle;

  /// No description provided for @notificationPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Please allow notifications to stay updated with important updates.'**
  String get notificationPermissionBody;

  /// No description provided for @fcmTokenError.
  ///
  /// In en, this message translates to:
  /// **'Failed to register notification token'**
  String get fcmTokenError;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @goodJob.
  ///
  /// In en, this message translates to:
  /// **'Good Job'**
  String get goodJob;

  /// No description provided for @keepPracticing.
  ///
  /// In en, this message translates to:
  /// **'Keep Practicing'**
  String get keepPracticing;

  /// No description provided for @youDidGreat.
  ///
  /// In en, this message translates to:
  /// **'You did great this time!'**
  String get youDidGreat;

  /// No description provided for @keepPracticingYoullImprove.
  ///
  /// In en, this message translates to:
  /// **'Keep practicing, you’ll improve!'**
  String get keepPracticingYoullImprove;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get reviewAnswers;

  /// No description provided for @exitQuiz.
  ///
  /// In en, this message translates to:
  /// **'Exit Quiz'**
  String get exitQuiz;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @questionNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get questionNote;

  /// No description provided for @correctAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswerLabel;

  /// No description provided for @yourAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswerLabel;

  /// No description provided for @hideReplies.
  ///
  /// In en, this message translates to:
  /// **'Hide replies'**
  String get hideReplies;

  /// No description provided for @repliesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Replies'**
  String repliesCount(Object count);

  /// No description provided for @askAQuestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get askAQuestion;

  /// No description provided for @viewReplies.
  ///
  /// In en, this message translates to:
  /// **'View replies'**
  String get viewReplies;

  /// No description provided for @answers.
  ///
  /// In en, this message translates to:
  /// **'answers'**
  String get answers;

  /// No description provided for @noAnswersYet.
  ///
  /// In en, this message translates to:
  /// **'No answers yet'**
  String get noAnswersYet;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @viewXml.
  ///
  /// In en, this message translates to:
  /// **'View XML'**
  String get viewXml;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @readyIdle.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get readyIdle;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @noDiagramYet.
  ///
  /// In en, this message translates to:
  /// **'No Diagram Yet'**
  String get noDiagramYet;

  /// No description provided for @noDiagramDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new flowchart or open an existing diagram to start editing.'**
  String get noDiagramDescription;

  /// No description provided for @openEditor.
  ///
  /// In en, this message translates to:
  /// **'Open Editor'**
  String get openEditor;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @attachmentDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Attachment downloaded successfully.'**
  String get attachmentDownloaded;

  /// No description provided for @failedToDownloadAttachment.
  ///
  /// In en, this message translates to:
  /// **'Failed to download attachment.'**
  String get failedToDownloadAttachment;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Question'**
  String get deleteQuestionTitle;

  /// No description provided for @deleteQuestionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this question? This action cannot be undone.'**
  String get deleteQuestionConfirm;

  /// No description provided for @deleteAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Answer'**
  String get deleteAnswerTitle;

  /// No description provided for @deleteAnswerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this answer? This action cannot be undone.'**
  String get deleteAnswerConfirm;

  /// No description provided for @myCertificates.
  ///
  /// In en, this message translates to:
  /// **'My Certificates'**
  String get myCertificates;

  /// No description provided for @certificatePreview.
  ///
  /// In en, this message translates to:
  /// **'Certificate Preview'**
  String get certificatePreview;

  /// No description provided for @couldNotGenerateCertificateImage.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the certificate image.'**
  String get couldNotGenerateCertificateImage;

  /// No description provided for @certificateImageSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Certificate image saved successfully.'**
  String get certificateImageSavedSuccessfully;

  /// No description provided for @couldNotSaveCertificateImage.
  ///
  /// In en, this message translates to:
  /// **'Could not save the certificate image.'**
  String get couldNotSaveCertificateImage;

  /// No description provided for @somethingWentWrongSavingImage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while saving the image.'**
  String get somethingWentWrongSavingImage;

  /// No description provided for @couldNotGenerateCertificate.
  ///
  /// In en, this message translates to:
  /// **'Could not generate the certificate.'**
  String get couldNotGenerateCertificate;

  /// No description provided for @certificatePdfSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Certificate PDF saved successfully.'**
  String get certificatePdfSavedSuccessfully;

  /// No description provided for @couldNotSaveCertificatePdf.
  ///
  /// In en, this message translates to:
  /// **'Could not save the certificate PDF.'**
  String get couldNotSaveCertificatePdf;

  /// No description provided for @somethingWentWrongCreatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while creating the PDF.'**
  String get somethingWentWrongCreatingPdf;

  /// No description provided for @downloadImage.
  ///
  /// In en, this message translates to:
  /// **'Download Image'**
  String get downloadImage;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @noCertificatesYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any certificates yet.'**
  String get noCertificatesYet;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @noCertificatesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No certificates available'**
  String get noCertificatesAvailable;

  /// No description provided for @reviewCertificateBeforeDownloading.
  ///
  /// In en, this message translates to:
  /// **'Review your certificate before downloading'**
  String get reviewCertificateBeforeDownloading;

  /// No description provided for @certificateDownloadHint.
  ///
  /// In en, this message translates to:
  /// **'You can download your certificate as an image or PDF'**
  String get certificateDownloadHint;

  /// No description provided for @certificateNotFound.
  ///
  /// In en, this message translates to:
  /// **'Certificate not found'**
  String get certificateNotFound;

  /// No description provided for @deleteQuizConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this quiz?'**
  String get deleteQuizConfirmation;

  /// No description provided for @deleteQuiz.
  ///
  /// In en, this message translates to:
  /// **'Delete Quiz'**
  String get deleteQuiz;

  /// No description provided for @failedToDeleteExam.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete the exam'**
  String get failedToDeleteExam;

  /// No description provided for @subscribeToUnlockLessons.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to unlock lessons'**
  String get subscribeToUnlockLessons;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get points;

  /// No description provided for @noLeaderboardData.
  ///
  /// In en, this message translates to:
  /// **'No leaderboard data available yet'**
  String get noLeaderboardData;

  /// No description provided for @topMembers.
  ///
  /// In en, this message translates to:
  /// **'Top Performers'**
  String get topMembers;

  /// No description provided for @groupFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Tools'**
  String get groupFeaturesTitle;

  /// No description provided for @groupFeaturesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Integrated tools to enhance collaboration, diagramming, and visual design.'**
  String get groupFeaturesSubtitle;

  /// No description provided for @drawioFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Draw.io'**
  String get drawioFeatureTitle;

  /// No description provided for @drawioFeatureTag.
  ///
  /// In en, this message translates to:
  /// **'Flowcharts & Architecture'**
  String get drawioFeatureTag;

  /// No description provided for @drawioFeatureDescription.
  ///
  /// In en, this message translates to:
  /// **'Create professional diagrams, system architecture blueprints, flowcharts, UML diagrams, and mind maps.'**
  String get drawioFeatureDescription;

  /// No description provided for @photopeaFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Photopea'**
  String get photopeaFeatureTitle;

  /// No description provided for @photopeaFeatureTag.
  ///
  /// In en, this message translates to:
  /// **'Graphic & Photo Editor'**
  String get photopeaFeatureTag;

  /// No description provided for @photopeaFeatureDescription.
  ///
  /// In en, this message translates to:
  /// **'Advanced graphic design and photo editing suite. Work with layers, edit PSD files, and export visual assets.'**
  String get photopeaFeatureDescription;

  /// No description provided for @openFeatureTool.
  ///
  /// In en, this message translates to:
  /// **'Open Tool'**
  String get openFeatureTool;

  /// No description provided for @featuresBadge.
  ///
  /// In en, this message translates to:
  /// **'Integrated Suite'**
  String get featuresBadge;

  /// No description provided for @featuresFooterNote.
  ///
  /// In en, this message translates to:
  /// **'All files and diagrams created with these tools can be saved and shared with your group members.'**
  String get featuresFooterNote;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for a free course'**
  String get priceHint;

  /// No description provided for @invalidPrice.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get visibilityPublic;

  /// No description provided for @visibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get visibilityPrivate;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

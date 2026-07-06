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

  /// No description provided for @notifOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get notifOn;

  /// No description provided for @secSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get secSupport;

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
  /// **'Enter password to continue'**
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

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @extraSecurityLayer.
  ///
  /// In en, this message translates to:
  /// **'Extra security layer for your account'**
  String get extraSecurityLayer;

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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'No storage permission. Please enable it from settings.'**
  String get storagePermissionDenied;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @xmlSaved.
  ///
  /// In en, this message translates to:
  /// **'XML saved successfully'**
  String get xmlSaved;

  /// No description provided for @pngSaved.
  ///
  /// In en, this message translates to:
  /// **'PNG saved successfully'**
  String get pngSaved;

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

  /// No description provided for @yourSections.
  ///
  /// In en, this message translates to:
  /// **'Your Sections'**
  String get yourSections;

  /// No description provided for @restrictedSections.
  ///
  /// In en, this message translates to:
  /// **'Restricted Sections'**
  String get restrictedSections;

  /// No description provided for @myGroups.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

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

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @renameSection.
  ///
  /// In en, this message translates to:
  /// **'Rename Section'**
  String get renameSection;

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

  /// No description provided for @deleteSectionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this section? This action cannot be undone.'**
  String get deleteSectionConfirmation;
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

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

  /// No description provided for @continueToPayment.
  ///
  /// In en, this message translates to:
  /// **'Continue to Payment'**
  String get continueToPayment;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your payment has been processed successfully. Your demo is now ready to use.'**
  String get paymentSuccessMessage;

  /// No description provided for @processingPayment.
  ///
  /// In en, this message translates to:
  /// **'processing payment'**
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

  /// No description provided for @addSection.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get addSection;

  /// No description provided for @noSectionFound.
  ///
  /// In en, this message translates to:
  /// **'No section found'**
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

  /// No description provided for @sectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Section Description'**
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
  /// **'Section added successfully'**
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
  /// **'Section updated successfully'**
  String get departmentUpdatedSuccessfully;

  /// No description provided for @departmentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Section deleted successfully'**
  String get departmentDeletedSuccessfully;

  /// No description provided for @departmentLearningPath.
  ///
  /// In en, this message translates to:
  /// **'Learning Path'**
  String get departmentLearningPath;

  /// No description provided for @departmentJourney.
  ///
  /// In en, this message translates to:
  /// **'DEPARTMENT JOURNEY'**
  String get departmentJourney;

  /// No description provided for @learningPath.
  ///
  /// In en, this message translates to:
  /// **'Learning Path'**
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
  /// **'Enter a title or career role (e.g. Flutter Engineer, Data Scientist) to generate a customized learning path:'**
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

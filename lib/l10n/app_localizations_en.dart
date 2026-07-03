// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myDemos => 'My Demos';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noDemosAvailable => 'No demos available';

  @override
  String get pressButtonToFetch => 'Press the button to fetch data';

  @override
  String get demosImIn => 'Demos I\'m In';

  @override
  String get seeAll => 'See all';

  @override
  String byAuthor(String author) {
    return 'by $author';
  }

  @override
  String usersCountText(int count) {
    return '$count users';
  }

  @override
  String get see => 'See';

  @override
  String get navMain => 'Main';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get goodMorning => 'Good morning,';

  @override
  String get addDemo => 'Add Demo';

  @override
  String get statMyDemos => 'My Demos';

  @override
  String get statEnrolled => 'Enrolled';

  @override
  String get profileTitle => 'Profile';

  @override
  String get manageAccount => 'Manage your account';

  @override
  String get secPreferences => 'Preferences';

  @override
  String get tileTheme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get tileLanguage => 'Language';

  @override
  String get langEnglish => 'English';

  @override
  String get tileNotifications => 'Notifications';

  @override
  String get notifOn => 'On';

  @override
  String get secSupport => 'Support';

  @override
  String get tileMessageAdmins => 'Message Admins';

  @override
  String get tileHelpFAQ => 'Help & FAQ';

  @override
  String get tilePrivacyPolicy => 'Privacy Policy';

  @override
  String get btnLogOut => 'Log Out';

  @override
  String get profileEnrolled => 'Enrolled';

  @override
  String get profileDemos => 'Demos';

  @override
  String get continueBtn => 'Continue';

  @override
  String payAndCreate(String price) {
    return 'Pay \$$price & Create';
  }

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get reviewDemoDetails =>
      'Review your demo details and complete the payment.';

  @override
  String get baseDemoReservation => 'Base Demo Reservation';

  @override
  String get selectedFeatures => 'Selected Features';

  @override
  String get noFeaturesSelected => 'No features selected.';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get startWithName => 'Let\'s start with a name';

  @override
  String get giveCatchyTitle =>
      'Give your new demo a catchy title so you can easily identify it later.';

  @override
  String get labelDemoName => 'Demo Name';

  @override
  String get hintDemoName => 'e.g. Flutter Advanced Course';

  @override
  String get labelDescription => 'Short Description';

  @override
  String get hintDescription => 'What is this demo about?';

  @override
  String get errorDemoNameRequired =>
      'Demo name is required, cannot be left empty';

  @override
  String get superchargeDemo => 'Supercharge your Demo';

  @override
  String get selectAddons =>
      'Select optional add-ons to enhance your room. You can skip this if you don\'t need any.';

  @override
  String get descriptionRequiredError => 'Description is required';

  @override
  String get uploadDemoImage => 'Upload Demo Image';

  @override
  String get tapToUpload => 'Tap to upload image';

  @override
  String get selectPlan => 'Select a Plan';

  @override
  String get upgradePlan => 'Upgrade Plan';

  @override
  String daysLeftText(int days) {
    return '$days days left in free trial';
  }

  @override
  String get createDemo => 'Create Demo';

  @override
  String get demoSummary => 'Demo Summary';

  @override
  String get demoNameLabel => 'Demo Name';

  @override
  String get demoDescriptionLabel => 'Description';

  @override
  String get selectedPlanLabel => 'Selected Plan';

  @override
  String get freeTrialLabel => 'Includes 14-Day Free Trial';

  @override
  String get pleaseEnterEmail => 'Please enter your email address';

  @override
  String get emailSent => 'Email Sent';

  @override
  String get ok => 'OK';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get forgotPasswordInstruction =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get pleaseEnterEmailPassword => 'Please enter email and password';

  @override
  String get loginSuccessful => 'Login successful!';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get diveBackLearning => 'Dive back into your learning';

  @override
  String get signIn => 'Sign In';

  @override
  String get emailAddressHint => 'Email Address';

  @override
  String get passwordHint => 'Password';

  @override
  String get forgotPasswordLink => 'Forgot Password?';

  @override
  String get logInBtn => 'Log In';

  @override
  String get orDivider => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUpLink => 'Sign Up';

  @override
  String get pleaseEnterNewPassword => 'Please enter new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get successTitle => 'Success';

  @override
  String get goToLoginBtn => 'Go to Login';

  @override
  String get resetPasswordScreenTitle => 'Reset Password';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get enterNewPasswordBelow => 'Enter your new password below.';

  @override
  String get newPasswordHint => 'New password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get resetPasswordBtn => 'Reset Password';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get startLearningToday => 'Start your ocean of learning today';

  @override
  String get firstNameHint => 'First Name';

  @override
  String get lastNameHint => 'Last Name';

  @override
  String get createAccountBtn => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logInLink => 'Log In';

  @override
  String get checkYourEmail => 'Check Your Email';

  @override
  String get verificationLinkSent => 'We sent a verification link to:';

  @override
  String get verifyBeforeLogin => 'Please verify your email before logging in.';

  @override
  String get backToLoginBtn => 'Back to Login';

  @override
  String get dateOfBirthHint => 'Date of Birth';

  @override
  String get nameRequiredError => 'Name should not be empty';

  @override
  String get changePassword => 'Change Password';

  @override
  String get enterPasswordToContinue => 'Enter password to continue';

  @override
  String get oldPassword => 'Current password';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get security => 'Security';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get extraSecurityLayer => 'Extra security layer for your account';

  @override
  String get resendVerificationEmail => 'Resend verification email';

  @override
  String get didntReceiveEmail => 'Didn\'t receive the email?';

  @override
  String get diagramEditor => 'Diagram Editor';

  @override
  String get diagramPreview => 'Diagram Preview';

  @override
  String get savedAt => 'Saved at';

  @override
  String get saveDiagram => 'Save Diagram';

  @override
  String get whatDoYouWantToSave => 'What do you want to save?';

  @override
  String get xmlOnly => 'XML only';

  @override
  String get pngOnly => 'PNG only';

  @override
  String get both => 'Both';

  @override
  String get cancel => 'Cancel';

  @override
  String get storagePermissionDenied =>
      'No storage permission. Please enable it from settings.';

  @override
  String get settings => 'Settings';

  @override
  String get xmlSaved => 'XML saved successfully';

  @override
  String get pngSaved => 'PNG saved successfully';

  @override
  String get enableTwoFactorAuth => 'Enable Two-Factor Authentication';

  @override
  String get enableTwoFactorAuthMessage =>
      'We will send a verification code to your email.';

  @override
  String get confirm => 'Confirm';

  @override
  String get codeSentToEmail => 'Verification code sent to your email';

  @override
  String get enterPasswordToEnable2FA =>
      'Enter your password to enable two-factor authentication';

  @override
  String get password => 'password';

  @override
  String get enableTwoFactorAuthentication =>
      'Enable Two-Factor Authentication';

  @override
  String get scanQrCode => 'Scan the QR Code';

  @override
  String get scanQrCodeDescription =>
      'Open your authenticator app and scan the QR code below. Then enter the 6-digit verification code to complete the setup.';

  @override
  String get authenticationCode => 'Authentication Code';

  @override
  String get enable => 'Enable';

  @override
  String get twoFactorEnabledSuccessfully =>
      'Two-factor authentication has been enabled successfully.';

  @override
  String get lincoCompanyDemo => 'Linco Company Demo';

  @override
  String get byAhmadAhmad => 'By Ahmad Ahmad';

  @override
  String get sections => 'Sections';

  @override
  String get groups => 'Groups';

  @override
  String get yourSections => 'Your Sections';

  @override
  String get restrictedSections => 'Restricted Sections';

  @override
  String get myGroups => 'My Groups';

  @override
  String get frontendSection => 'Frontend Section';

  @override
  String get frontendSectionSubtitle =>
      'the main section for developing web pages and dashboard';

  @override
  String get project1Team => 'Project 1 Team';

  @override
  String get project1TeamSubtitle => 'building project 1 with many members';

  @override
  String get verify2FASubtitle =>
      'Enter the 6-digit code from your authenticator app.';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get invalidCode => 'Invalid verification code';
}

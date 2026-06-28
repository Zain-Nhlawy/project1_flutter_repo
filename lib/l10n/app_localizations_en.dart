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
  String get labelDescription => 'Short Description (Optional)';

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
  String get enterPasswordToContinue =>
      'Enter your current and new password to continue';

  @override
  String get oldPassword => 'Current password';

  @override
  String get pleaseFillAllFields => 'Please fill all fields';

  @override
  String get security => 'Security';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get extraSecurityLayer => 'Add an extra layer of security';

  @override
  String get resendVerificationEmail => 'Resend verification email';

  @override
  String get didntReceiveEmail => 'Didn\'t receive the email?';
}

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
  String get continueToPayment => 'Continue to Payment';

  @override
  String get paymentSuccessful => 'Payment Successful';

  @override
  String get paymentSuccessMessage =>
      'Your payment has been completed successfully. Enjoy your course!';

  @override
  String get processingPayment => 'Processing your payment...';

  @override
  String get limitReachedMessage => 'Limit Reached';

  @override
  String get limitReachedSnackBar =>
      'This plan limit has been reached , please upgrade the plan';

  @override
  String get addSection => 'Add Section';

  @override
  String get noSectionFound => 'No section found';

  @override
  String get demoMembers => 'Demo Members';

  @override
  String get usersEmptyTitle => 'No users yet';

  @override
  String get usersEmptySubtitle => 'Users will show up here once added.';

  @override
  String get usersErrorGeneric => 'Something went wrong while loading users.';

  @override
  String get viewPersonalInfo => 'View personal info';

  @override
  String get changePermissions => 'Change permissions';

  @override
  String get removeFromRoom => 'Remove from room';

  @override
  String get memberRemovedSuccessfully => 'The Member removed successfully';

  @override
  String get userNameHint => 'User name';

  @override
  String get searchUser => 'Search user';

  @override
  String get startTyping => 'Start typing to search...';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get sendInvitation => 'Send invite';

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
  String get twoFactorAuth => 'Two-Factor Authentication';

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
  String get storagePermissionDenied =>
      'No storage permission. Please enable it from settings.';

  @override
  String get settings => 'Settings';

  @override
  String get xmlSaved => 'XML saved successfully';

  @override
  String get pngSaved => 'PNG saved successfully';

  @override
  String get security => 'Security';

  @override
  String get extraSecurityLayer => 'Extra security layer for your account';

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

  @override
  String get createCourse => 'Create Course';

  @override
  String get courseTitle => 'Course Title';

  @override
  String get courseDescription => 'Course Description';

  @override
  String get price => 'Price';

  @override
  String get public => 'Public';

  @override
  String get private => 'Private';

  @override
  String get tags => 'Tags';

  @override
  String get add => 'Add';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get fillAllFieldsWarning => 'Please fill in all required fields';

  @override
  String get ongoingCourses => 'Ongoing courses';

  @override
  String get courseManagement => 'Course Management';

  @override
  String get company => 'Company';

  @override
  String get manageFaq => 'Manage FAQ';

  @override
  String get manageSections => 'Manage Sections';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get editCourse => 'Edit Course';

  @override
  String get manageCoursesDescription =>
      'Manage your courses, update their details, and continue building them.';

  @override
  String get coursesInProgress => 'Courses in Progress';

  @override
  String get noSectionsYet => 'No sections yet';

  @override
  String get addLesson => 'Add Lesson';

  @override
  String get noLessonsYet => 'No lessons yet';

  @override
  String get questionsBank => 'Questions Bank';

  @override
  String get renameSection => 'Rename Section';

  @override
  String get sectionName => 'Section name';

  @override
  String get save => 'Save';

  @override
  String get deleteSection => 'Delete Section';

  @override
  String get deleteSectionConfirmation =>
      'Are you sure you want to delete this section? This action cannot be undone.';

  @override
  String get createLesson => 'Create Lesson';

  @override
  String get lessonVideo => 'Lesson Video';

  @override
  String get uploadLessonVideo => 'Upload Lesson Video';

  @override
  String get lessonTitle => 'Lesson Title';

  @override
  String get enterLessonTitle => 'Enter lesson title';

  @override
  String get lessonDescription => 'Lesson Description';

  @override
  String get enterLessonDescription => 'Enter lesson description';

  @override
  String get lessonAttachments => 'Lesson Attachments';

  @override
  String get addAttachment => 'Add Attachment';

  @override
  String get attachmentName => 'Attachment name';

  @override
  String get editAttachment => 'Edit Attachment';

  @override
  String get deleteAttachment => 'Delete Attachment';

  @override
  String get deleteAttachmentConfirmation =>
      'Are you sure you want to delete this attachment?';

  @override
  String get noAttachments => 'No attachments yet';

  @override
  String get saveLesson => 'Save Lesson';

  @override
  String get delete => 'Delete';

  @override
  String get lessonManagement => 'Lesson Management';

  @override
  String get editLesson => 'Edit Lesson';

  @override
  String get noTagsAvailable => 'No tags available';

  @override
  String get noCoursesFound => 'No courses found';

  @override
  String get free => 'Free';

  @override
  String get deleteCourseTitle => 'Delete Course';

  @override
  String get deleteCourseConfirmation =>
      'Are you sure you want to delete this course?';

  @override
  String get failedToUploadImage => 'Failed to upload image';

  @override
  String get demoCourses => 'Demo Courses';

  @override
  String get demoCoursesDescription => 'Courses available in your demo';

  @override
  String get availableCourses => 'Available Courses';

  @override
  String get courses => 'Courses';

  @override
  String get publish => 'Publish';

  @override
  String get publishCourse => 'Publish Course';

  @override
  String get publishCourseConfirmation =>
      'Are you sure you want to publish this course? After publishing, it can no longer be edited.';

  @override
  String get seeMore => 'See More';

  @override
  String get producedBy => 'Produced by';

  @override
  String get aboutThisCourse => 'About this course';

  @override
  String get courseContent => 'Course Content';

  @override
  String get courseDetails => 'Course Details';

  @override
  String get courseCreatedSuccessfully => 'Course created successfully';

  @override
  String get noSectionsAvailable => 'No sections available';

  @override
  String get demoCreatedSuccessfully => 'Demo Created Successfully!';

  @override
  String get removeUserPrompt => 'Remove user?';

  @override
  String get areYouSureRemoveUser =>
      'Are you sure you want to remove this user?';

  @override
  String get testPage => 'Test Page';

  @override
  String get openDiagram => 'Open Diagram';

  @override
  String get photopeaEditor => 'Photopea Editor';

  @override
  String get englishLanguage => 'English';

  @override
  String get quizResult => 'Quiz Result';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get confirmAnswer => 'Confirm Answer';

  @override
  String get usersTab => 'Users';

  @override
  String get demoStats => 'Demo Stats';

  @override
  String get themeDark => 'Dark';

  @override
  String get areYouSureSendInvitation =>
      'Are you sure you want to send an invitation to this user?';

  @override
  String get userAlreadyInvited => 'User is already invited to this demo';

  @override
  String get invitationSentSuccessfully => 'Invitation sent successfully';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get noNewNotifications => 'No new notifications';

  @override
  String get selectVideoFirst => 'Please select a video first.';

  @override
  String get operationInProgressTitle => 'Operation in Progress';

  @override
  String get operationInProgressMessage =>
      'A video upload or lesson creation is currently in progress. If you leave now, the video may finish uploading without being linked to the lesson. Are you sure you want to leave?';

  @override
  String get stay => 'Stay';

  @override
  String get leaveAnyway => 'Leave Anyway';

  @override
  String get deleteLesson => 'Delete Lesson';

  @override
  String get deleteLessonFailed => 'Failed to delete the lesson.';

  @override
  String get leaveWhileBusyTitle => 'Operation in Progress';

  @override
  String get leaveWhileBusyMessage =>
      'An upload or save operation is currently in progress. If you leave now, your changes may be lost. Are you sure you want to leave?';

  @override
  String get lessonUpdatedSuccessfully => 'Changes saved successfully.';

  @override
  String get lessonUpdateFailed => 'Failed to save changes.';

  @override
  String get deleteLessonConfirmation =>
      'Are you sure you want to delete this lesson? This action cannot be undone.';

  @override
  String get pressToSelectVideo => 'Press to select video';

  @override
  String get preparingToUpload => 'Preparing to upload...';

  @override
  String get processingVideo => 'processing video...';

  @override
  String get uploadingVideo => 'Uploading video...';

  @override
  String invitedBy(String firstName, String lastName) {
    return 'Invited by $firstName $lastName';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get quiz => 'Quiz';

  @override
  String get lessons => 'Lessons';

  @override
  String get duration => 'Duration';

  @override
  String get lessonOverview => 'Lesson overview';

  @override
  String get failedToOpenAttachment => 'Failed to open attachment';

  @override
  String get videoLoadFailed => 'Failed to load video';

  @override
  String get retry => 'Retry';

  @override
  String get faq => 'FAQ';

  @override
  String get noFaqAvailable => 'No FAQs available';

  @override
  String get addFaq => 'Add FAQ';

  @override
  String get question => 'Question';

  @override
  String get questionIsRequired => 'Question is required';

  @override
  String get answer => 'Answer';

  @override
  String get answerIsRequired => 'Answer is required';

  @override
  String get deleteFaq => 'Delete FAQ';

  @override
  String deleteFaqConfirmation(Object question) {
    return 'Are you sure you want to delete \"$question\"?';
  }

  @override
  String get tapToAddFaq => 'Tap \"Add FAQ\" to create the first one.';

  @override
  String get noFaqsYet => 'No FAQs yet';

  @override
  String get faqs => 'FAQs';

  @override
  String get enterSectionName => 'Enter section name';

  @override
  String get sectionDescription => 'Section Description';

  @override
  String get enterSectionDescription => 'Enter section description';

  @override
  String get manager => 'Manager';

  @override
  String get selectManager => 'Select manager';

  @override
  String get pleaseSelectManager => 'Please select a manager';

  @override
  String get departmentAddedSuccessfully => 'Section added successfully';

  @override
  String get requiredField => 'Fields is required';

  @override
  String get departmentMainPage => 'Main Page';

  @override
  String get departmentCourses => 'Courses';

  @override
  String get departmentLeaderboard => 'Leaderboard';

  @override
  String get departmentSendReport => 'Send Report';

  @override
  String get departmentChat => 'Chat';

  @override
  String get departmentMembers => 'Members';

  @override
  String get noMembersInDepartment => 'No members in this department yet.';

  @override
  String get selectJobTitle => 'Select Job Title';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get intern => 'Intern';

  @override
  String get junior => 'Junior';

  @override
  String get senior => 'Senior';

  @override
  String get addMember => 'Add Member';

  @override
  String get memberAddedSuccessfully => 'Member added successfully';

  @override
  String get searchDemoMembers => 'Search Demo Members';

  @override
  String get searchMembersHint => 'Search by name or email...';

  @override
  String get noMembersFound => 'No members found';

  @override
  String get removeMemberPrompt => 'Remove Member';

  @override
  String get areYouSureRemoveMember =>
      'Are you sure you want to remove this member from the department?';

  @override
  String get editDepartment => 'Edit Department';

  @override
  String get removeDepartment => 'Remove Department';

  @override
  String get departmentUpdatedSuccessfully => 'Section updated successfully';

  @override
  String get departmentDeletedSuccessfully => 'Section deleted successfully';

  @override
  String get departmentLearningPath => 'Learning Path';

  @override
  String get departmentJourney => 'DEPARTMENT JOURNEY';

  @override
  String get learningPath => 'Learning Path';

  @override
  String get addCourseToPath => 'Add Course to Path';

  @override
  String get replace => 'Replace';

  @override
  String get remove => 'Remove';

  @override
  String get fetchDataPrompt => 'Request data to view the path';

  @override
  String errorOccurred(Object error) {
    return 'Error: $error';
  }

  @override
  String get departmentRoadmap => 'Department Roadmap';

  @override
  String get roadmapSubtitle =>
      'Step-by-step career path, skills, and projects.';

  @override
  String get newRoadmap => 'New';

  @override
  String get generateRoadmap => 'Generate Roadmap';

  @override
  String get generateRoadmapDesc =>
      'Enter a title or career role (e.g. Flutter Engineer, Data Scientist) to generate a customized learning path:';

  @override
  String get roadmapTitleOrRole => 'Roadmap Title / Role';

  @override
  String get roadmapTitleHint => 'e.g. Mobile Developer';

  @override
  String get generate => 'Generate';

  @override
  String get noRoadmapYet => 'No Learning Roadmap Yet';

  @override
  String get emptyRoadmapDesc =>
      'Create a structured weekly learning roadmap with skills, projects, and deliverables for this department.';

  @override
  String get generatingRoadmap => 'Generating Learning Roadmap...';

  @override
  String get generatingRoadmapSub => 'Organizing topics, skills, and projects';

  @override
  String get failedToLoadRoadmap => 'Failed to Load Roadmap';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get stepsLabel => 'Steps';

  @override
  String get durationLabel => 'Duration';

  @override
  String weeksCount(Object count) {
    return '$count Weeks';
  }

  @override
  String get skillsCovered => 'Skills Covered';

  @override
  String get practicalProjects => 'Practical Projects';

  @override
  String get deliverables => 'Deliverables';

  @override
  String get resources => 'Resources';

  @override
  String weekPrefix(Object week) {
    return 'W$week';
  }

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get exportingPdf => 'Generating PDF...';

  @override
  String get deleteCourse => 'Delete Course';

  @override
  String get noCoursesInDepartment => 'No courses in this department.';

  @override
  String get publicLibrary => 'Public Library';

  @override
  String get searchCourses => 'Search courses, or skills..';

  @override
  String get allFilters => 'All Filters';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String showingResults(Object count) {
    return 'Showing $count results for your search';
  }

  @override
  String get sortBy => 'Sort by';

  @override
  String get popularity => 'Popularity';

  @override
  String get enrollNow => 'Enroll Now';

  @override
  String get enrollToWatchLesson => 'Enroll to Watch Lesson';

  @override
  String get exploreNewSkills => 'Discover Your Passion & Learn New Skills';

  @override
  String get expandYourKnowledge => 'Hundreds of courses waiting for you';

  @override
  String get checkoutError =>
      'An error occurred while creating the payment session';

  @override
  String coursePurchaseSuccessMessage(String courseTitle) {
    return 'You have successfully purchased \"$courseTitle\". Start learning now!';
  }

  @override
  String get alreadyEnrolled => 'Already Enrolled';

  @override
  String get backToLibrary => 'Back to Library';

  @override
  String get aiAssistantTitle => 'AI Study Assistant';

  @override
  String get askQuestionSection => 'Ask a Question';

  @override
  String get askQuestionHint =>
      'e.g., What is the difference between Dependency Injection and Singleton?';

  @override
  String get askButton => 'Ask Assistant';

  @override
  String get topicQuizSection => 'Topic-Specific Quiz';

  @override
  String get topicHint => 'e.g., Clean Architecture';

  @override
  String get questionCountHint => 'Number of questions';

  @override
  String get generateTopicQuizButton => 'Generate Topic Quiz';

  @override
  String get randomQuizSection => 'Random Course Quiz';

  @override
  String get generateRandomQuizButton => 'Generate Random Quiz';

  @override
  String get aiResponseTitle => 'AI Response';

  @override
  String get noDataYet =>
      'Ask a question or generate a quiz to see the AI insights here.';

  @override
  String get errorPrefix => 'Error occurred: ';

  @override
  String get chatConnecting => 'Connecting...';

  @override
  String get chatReconnecting => 'Reconnecting to chat...';

  @override
  String get chatConnectionLost => 'Connection lost. Retrying...';

  @override
  String get chatNoMessagesYet => 'No messages yet';

  @override
  String get chatFirstMessagePrompt =>
      'Be the first to start the conversation!';

  @override
  String get chatMessageDeleted => 'This message was deleted';

  @override
  String get chatEditedTag => 'edited';

  @override
  String get chatReply => 'Reply';

  @override
  String get chatEdit => 'Edit';

  @override
  String get chatDelete => 'Delete';

  @override
  String get chatTypeMessageHint => 'Type a message...';

  @override
  String get chatEditMessageHint => 'Edit message...';

  @override
  String chatReplyingTo(String name) {
    return 'Replying to $name';
  }

  @override
  String get chatEditingMessageTitle => 'Editing Message';

  @override
  String chatMemberIsTyping(String name) {
    return '$name is typing...';
  }

  @override
  String chatMembersAreTyping(int count) {
    return '$count members are typing...';
  }

  @override
  String get chatFailedToLoadHistory => 'Failed to load message history';

  @override
  String get deleteQuestion => 'Delete Question';

  @override
  String get deleteQuestionConfirmation =>
      'Are you sure you want to delete this question?';

  @override
  String get deleteQuestionFailed => 'Failed to delete question';

  @override
  String get addQuestion => 'Add Question';

  @override
  String get questionHint => 'Enter your question';

  @override
  String get choicesLabel => 'Choices';

  @override
  String get choiceHint => 'Choice';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get selectCorrectAnswer => 'Please select at least one correct answer';

  @override
  String get createQuestionFailed => 'Failed to create question';

  @override
  String get noQuestionsYet => 'No questions yet';

  @override
  String get enterQuestionFirst => 'Please enter the question first';

  @override
  String get choicesMustBeUnique =>
      'Each choice must be different from the others';

  @override
  String get questionsBankDescription =>
      'Manage and review all questions in this section\'s question bank';

  @override
  String get questionsCount => 'Questions';

  @override
  String get checkAnswer => 'Check Answer';

  @override
  String get correctAnswerFeedback => 'Correct answer!';

  @override
  String get incorrectAnswerFeedback => 'Incorrect answer';

  @override
  String get addChoice => 'Add choice';

  @override
  String get inquiries => 'Inquiries';

  @override
  String get sendInquiries => 'Send Inquiries';

  @override
  String get inquiriesDescription =>
      'Send complaints, questions, or feedback to owner';

  @override
  String get inquiriesComingSoon => 'Inquiries feature coming soon';

  @override
  String get demoOptions => 'Demo Options';

  @override
  String get coursesOptionDesc => 'View and manage course selection';

  @override
  String get publicLibraryOptionDesc => 'Access shared public resources';

  @override
  String get usersTabOptionDesc => 'Manage demo members and roles';

  @override
  String get demoStatsOptionDesc => 'View analytics and statistics';

  @override
  String get quizInformation => 'Quiz Information';

  @override
  String get addExam => 'Add Exam';

  @override
  String get editExam => 'Edit Exam';

  @override
  String get enterExamDetailsDescription =>
      'Please fill in the details below to configure the exam settings.';

  @override
  String get examTitle => 'Exam Title';

  @override
  String get examTitleHint => 'e.g. Midterm Assessment';

  @override
  String get numberOfQuestions => 'Number of Questions';

  @override
  String get numberOfQuestionsHint => 'e.g. 10';

  @override
  String get durationMinutes => 'Duration (Minutes)';

  @override
  String get durationMinutesHint => 'e.g. 30';

  @override
  String get examCreatedSuccessfully => 'Exam created successfully';

  @override
  String get examUpdatedSuccessfully => 'Exam updated successfully';

  @override
  String get failedToUpdateExam => 'Failed to update exam';

  @override
  String get failedToCreateExam => 'Failed to create exam';

  @override
  String get selectAnswer => 'Select your answer';

  @override
  String get submitQuiz => 'Submit Quiz';

  @override
  String get quizCompleted => 'Quiz Completed';

  @override
  String get greatJob => 'Great job! Keep it up.';

  @override
  String get score => 'Score';

  @override
  String get correct => 'Correct';

  @override
  String get wrong => 'Wrong';

  @override
  String get done => 'Done';

  @override
  String get leaveQuiz => 'Leave Quiz?';

  @override
  String get leaveQuizMessage => 'Your progress will be lost if you leave now.';

  @override
  String get noQuestionsAvailable => 'No questions are available.';

  @override
  String get noInquiriesYet => 'No inquiries found';

  @override
  String get createInquiry => 'New Inquiry';

  @override
  String get inquirySubject => 'Subject';

  @override
  String get inquirySubjectHint => 'Enter inquiry subject...';

  @override
  String get inquiryMessage => 'Message';

  @override
  String get inquiryMessageHint => 'Write your inquiry here...';

  @override
  String get reply => 'Reply';

  @override
  String get replyHint => 'Write your reply here...';

  @override
  String get sendReply => 'Send Reply';

  @override
  String get inquirySentSuccessfully => 'Inquiry submitted successfully';

  @override
  String get replySentSuccessfully => 'Reply sent successfully';

  @override
  String get inquiryDetails => 'Inquiry Details';

  @override
  String get senderDetails => 'Sender Details';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusReplied => 'Replied';

  @override
  String get awaitingReply => 'Awaiting response from owner';

  @override
  String get ownerReply => 'Owner Reply';

  @override
  String get notificationPermissionTitle => 'Notification Permission';

  @override
  String get notificationPermissionBody =>
      'Please allow notifications to stay updated with important updates.';

  @override
  String get fcmTokenError => 'Failed to register notification token';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get myDemos => ' الغرف الخاصة بي';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get noDemosAvailable => 'لا توجد غرف متاحة';

  @override
  String get pressButtonToFetch => 'اضغط على الزر لجلب البيانات';

  @override
  String get demosImIn => 'الغرف المشترك بها';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String byAuthor(String author) {
    return 'بواسطة $author';
  }

  @override
  String usersCountText(int count) {
    return '$count مستخدمين';
  }

  @override
  String get see => 'عرض';

  @override
  String get navMain => 'الرئيسية';

  @override
  String get navHistory => 'السجل';

  @override
  String get navProfile => 'الحساب';

  @override
  String get goodMorning => 'صباح الخير،';

  @override
  String get addDemo => 'إضافة غرفة';

  @override
  String get statMyDemos => 'غرفي';

  @override
  String get statEnrolled => 'المسجلة';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get manageAccount => 'إدارة حسابك';

  @override
  String get secPreferences => 'التفضيلات';

  @override
  String get tileTheme => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get tileLanguage => 'اللغة';

  @override
  String get langEnglish => 'الإنجليزية';

  @override
  String get tileNotifications => 'الإشعارات';

  @override
  String get notifOn => 'مفعلة';

  @override
  String get secSupport => 'الدعم الفني';

  @override
  String get tileMessageAdmins => 'مراسلة المسؤولين';

  @override
  String get tileHelpFAQ => 'المساعدة والأسئلة الشائعة';

  @override
  String get tilePrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get btnLogOut => 'تسجيل الخروج';

  @override
  String get profileEnrolled => 'المسجلة';

  @override
  String get profileDemos => 'الغرف';

  @override
  String get continueBtn => 'المتابعة';

  @override
  String payAndCreate(String price) {
    return 'دفع $price \$ وإنشاء';
  }

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get reviewDemoDetails =>
      'راجع تفاصيل الغرفة الخاصة بك وأكمل عملية الدفع.';

  @override
  String get baseDemoReservation => 'حجز الغرفة الأساسي';

  @override
  String get selectedFeatures => 'الميزات المحددة';

  @override
  String get noFeaturesSelected => 'لم يتم تحديد أي ميزات.';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get startWithName => 'دعنا نبدأ بالاسم';

  @override
  String get giveCatchyTitle =>
      'امنح الغرفة الجديدة عنواناً جذاباً لتتمكن من التعرف عليها بسهولة لاحقاً.';

  @override
  String get labelDemoName => 'اسم الغرفة';

  @override
  String get hintDemoName => 'مثال: دورة فلاتر المتقدمة';

  @override
  String get labelDescription => 'وصف قصير';

  @override
  String get hintDescription => 'عن ماذا تتحدث هذا الغرفة';

  @override
  String get errorDemoNameRequired => 'اسم الغرفة مطلوب، لا يمكن تركه فارغاً';

  @override
  String get superchargeDemo => 'طور الغرفة الخاصة بك';

  @override
  String get selectAddons =>
      'اختر إضافات اختيارية لتحسين غرفتك. يمكنك تخطي هذا إذا لم تكن بحاجة لأي منها.';

  @override
  String get descriptionRequiredError => ' وصف الغرفة مطلوب ';

  @override
  String get uploadDemoImage => 'رفع صورة الديمو';

  @override
  String get tapToUpload => 'اضغط لرفع الصورة';

  @override
  String get selectPlan => 'اختر الخطة';

  @override
  String get upgradePlan => 'ترقية الخطة';

  @override
  String daysLeftText(int days) {
    return 'متبقي $days أيام مجانية';
  }

  @override
  String get createDemo => 'إنشاء الديمو';

  @override
  String get demoSummary => 'ملخص الديمو';

  @override
  String get demoNameLabel => 'اسم الديمو';

  @override
  String get demoDescriptionLabel => 'الوصف';

  @override
  String get selectedPlanLabel => 'الخطة المحددة';

  @override
  String get freeTrialLabel => 'يتضمن تجربة مجانية لمدة 14 يوماً';

  @override
  String get continueToPayment => 'المتابعة للدفع';

  @override
  String get paymentSuccessful => 'تمت عملية الدفع بنجاح';

  @override
  String get paymentSuccessMessage => 'تمت عملية الدفع بنجاح، استمتع بكورسك!';

  @override
  String get processingPayment => 'جاري معالجة الدفع...';

  @override
  String get limitReachedMessage => 'تم تجاوز الحد';

  @override
  String get limitReachedSnackBar =>
      'تم تجاوز حد الخطة , يرجى الترقية للحصول على المزيد ';

  @override
  String get addSection => 'إضافة قسم';

  @override
  String get noSectionFound => 'لا يوجد اقسام متاحة';

  @override
  String get demoMembers => 'اعضاء الغرفة';

  @override
  String get usersEmptyTitle => 'لا يوجد مستخدمون بعد';

  @override
  String get usersEmptySubtitle => 'سيظهر المستخدمون هنا بمجرد إضافتهم.';

  @override
  String get usersErrorGeneric => 'حدث خطأ أثناء تحميل المستخدمين.';

  @override
  String get viewPersonalInfo => 'عرض المعلومات الشخصية';

  @override
  String get changePermissions => 'تغيير الصلاحيات';

  @override
  String get removeFromRoom => 'حذف العضو من الغرفة';

  @override
  String get memberRemovedSuccessfully => 'تمت إزالة العضو بنجاح';

  @override
  String get userNameHint => 'اسم المستخدم';

  @override
  String get searchUser => 'ابحث عن مستخدم';

  @override
  String get startTyping => 'ابدأ بالكتابة للبحث...';

  @override
  String get noUsersFound => 'لا يوجد مستخدمون';

  @override
  String get sendInvitation => 'إرسال دعوة';

  @override
  String get pleaseEnterEmail => 'يرجى إدخال عنوان بريدك الإلكتروني';

  @override
  String get emailSent => 'تم إرسال البريد الإلكتروني';

  @override
  String get ok => 'حسناً';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordInstruction =>
      'أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور الخاصة بك.';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get pleaseEnterEmailPassword =>
      'يرجى إدخال البريد الإلكتروني وكلمة المرور';

  @override
  String get loginSuccessful => 'تم تسجيل الدخول بنجاح!';

  @override
  String get welcomeBack => 'مرحباً بعودتك!';

  @override
  String get diveBackLearning => 'عد مجدداً لمتابعة تعلمك';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get emailAddressHint => 'البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get logInBtn => 'تسجيل الدخول';

  @override
  String get orDivider => 'أو';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUpLink => 'إنشاء حساب';

  @override
  String get pleaseEnterNewPassword => 'يرجى إدخال كلمة المرور الجديدة';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get successTitle => 'نجاح';

  @override
  String get goToLoginBtn => 'الذهاب لتسجيل الدخول';

  @override
  String get resetPasswordScreenTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get createNewPassword => 'إنشاء كلمة مرور جديدة';

  @override
  String get enterNewPasswordBelow => 'أدخل كلمة المرور الجديدة أدناه.';

  @override
  String get newPasswordHint => 'كلمة المرور الجديدة';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get resetPasswordBtn => 'إعادة تعيين كلمة المرور';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get startLearningToday => 'ابدأ رحلة تعلمك اليوم';

  @override
  String get firstNameHint => 'الاسم الأول';

  @override
  String get lastNameHint => 'الكنية';

  @override
  String get createAccountBtn => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get logInLink => 'تسجيل الدخول';

  @override
  String get checkYourEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get verificationLinkSent => 'لقد أرسلنا رابط التحقق إلى:';

  @override
  String get verifyBeforeLogin =>
      'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول.';

  @override
  String get backToLoginBtn => 'العودة لتسجيل الدخول';

  @override
  String get dateOfBirthHint => 'تاريخ الميلاد';

  @override
  String get nameRequiredError => 'الاسم لا يجب ان يكون فارغاً';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get enterPasswordToContinue =>
      'أدخل كلمة المرور الحالية والجديدة للمتابعة';

  @override
  String get oldPassword => 'كلمة المرور الحالية';

  @override
  String get pleaseFillAllFields => 'الرجاء تعبئة جميع الحقول';

  @override
  String get twoFactorAuth => 'المصادقة الثنائية';

  @override
  String get resendVerificationEmail => 'إعادة إرسال رابط التحقق';

  @override
  String get didntReceiveEmail => 'لم يصلك البريد الإلكتروني؟';

  @override
  String get diagramEditor => 'محرر المخططات';

  @override
  String get diagramPreview => 'معاينة المخطط';

  @override
  String get savedAt => 'محفوظ في';

  @override
  String get saveDiagram => 'حفظ المخطط';

  @override
  String get whatDoYouWantToSave => 'شو بدك تحفظ؟';

  @override
  String get xmlOnly => 'XML فقط';

  @override
  String get pngOnly => 'PNG فقط';

  @override
  String get both => 'الاثنين';

  @override
  String get storagePermissionDenied => 'ما عندك إذن تخزين، فعّله من الإعدادات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get xmlSaved => 'تم حفظ XML بنجاح';

  @override
  String get pngSaved => 'تم حفظ PNG بنجاح';

  @override
  String get security => 'الأمان';

  @override
  String get extraSecurityLayer => 'طبقة أمان إضافية لحسابك';

  @override
  String get enableTwoFactorAuth => 'تفعيل المصادقة الثنائية';

  @override
  String get enableTwoFactorAuthMessage =>
      'سنقوم بإرسال رمز تحقق إلى بريدك الإلكتروني.';

  @override
  String get confirm => 'تأكيد';

  @override
  String get codeSentToEmail => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني';

  @override
  String get enterPasswordToEnable2FA =>
      'أدخل كلمة المرور لتفعيل المصادقة الثنائية';

  @override
  String get password => 'كلمة السر';

  @override
  String get enableTwoFactorAuthentication => 'تفعيل المصادقة الثنائية';

  @override
  String get scanQrCode => 'امسح رمز QR';

  @override
  String get scanQrCodeDescription =>
      'افتح تطبيق المصادقة على هاتفك وامسح رمز QR أدناه، ثم أدخل رمز التحقق المكون من 6 أرقام لإكمال عملية التفعيل.';

  @override
  String get authenticationCode => 'رمز التحقق';

  @override
  String get enable => 'تفعيل';

  @override
  String get twoFactorEnabledSuccessfully =>
      'تم تفعيل المصادقة الثنائية بنجاح.';

  @override
  String get lincoCompanyDemo => 'Linco Company Demo';

  @override
  String get byAhmadAhmad => 'بواسطة أحمد أحمد';

  @override
  String get sections => 'الأقسام';

  @override
  String get groups => 'المجموعات';

  @override
  String get yourSections => 'أقسامك';

  @override
  String get restrictedSections => 'الأقسام المقيدة';

  @override
  String get myGroups => 'مجموعاتي';

  @override
  String get frontendSection => 'قسم الواجهات الأمامية';

  @override
  String get frontendSectionSubtitle =>
      'القسم الرئيسي لتطوير صفحات الويب ولوحات التحكم';

  @override
  String get project1Team => 'فريق المشروع 1';

  @override
  String get project1TeamSubtitle => 'بناء المشروع 1 مع العديد من الأعضاء';

  @override
  String get verify2FASubtitle =>
      'أدخل رمز التحقق المكوّن من 6 أرقام من تطبيق المصادقة.';

  @override
  String get verifyCode => 'تحقق';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get invalidCode => 'رمز التحقق غير صحيح';

  @override
  String get createCourse => 'إنشاء كورس';

  @override
  String get courseTitle => 'عنوان الكورس';

  @override
  String get courseDescription => 'وصف الكورس';

  @override
  String get price => 'السعر';

  @override
  String get public => 'عام';

  @override
  String get private => 'خاص';

  @override
  String get tags => 'التاغات';

  @override
  String get add => 'إضافة';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get fillAllFieldsWarning => 'يرجى تعبئة جميع الحقول المطلوبة';

  @override
  String get ongoingCourses => 'كورسات قيد الإنشاء';

  @override
  String get courseManagement => 'إدارة الكورس';

  @override
  String get company => 'الشركة';

  @override
  String get manageFaq => 'إدارة الأسئلة الشائعة';

  @override
  String get manageSections => 'إدارة الأقسام';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get editCourse => 'تعديل الكورس';

  @override
  String get manageCoursesDescription =>
      'قم بإدارة دوراتك، تحديث تفاصيلها، ومتابعة إنشائها.';

  @override
  String get coursesInProgress => 'دورات قيد الإنشاء';

  @override
  String get noSectionsYet => 'لا يوجد أقسام بعد';

  @override
  String get addLesson => 'إضافة درس';

  @override
  String get noLessonsYet => 'لا توجد دروس بعد';

  @override
  String get questionsBank => 'بنك الأسئلة';

  @override
  String get renameSection => 'إعادة تسمية القسم';

  @override
  String get sectionName => 'اسم القسم';

  @override
  String get save => 'حفظ';

  @override
  String get deleteSection => 'حذف القسم';

  @override
  String get deleteSectionConfirmation =>
      'هل أنت متأكد من حذف هذا القسم؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get createLesson => 'إضافة درس';

  @override
  String get lessonVideo => 'فيديو الدرس';

  @override
  String get uploadLessonVideo => 'رفع فيديو الدرس';

  @override
  String get lessonTitle => 'عنوان الدرس';

  @override
  String get enterLessonTitle => 'أدخل عنوان الدرس';

  @override
  String get lessonDescription => 'وصف الدرس';

  @override
  String get enterLessonDescription => 'أدخل وصف الدرس';

  @override
  String get lessonAttachments => 'ملحقات الدرس';

  @override
  String get addAttachment => 'إضافة ملحق';

  @override
  String get attachmentName => 'اسم الملحق';

  @override
  String get editAttachment => 'تعديل الملحق';

  @override
  String get deleteAttachment => 'حذف الملحق';

  @override
  String get deleteAttachmentConfirmation => 'هل أنت متأكد من حذف هذا الملحق؟';

  @override
  String get noAttachments => 'لا توجد ملحقات بعد';

  @override
  String get saveLesson => 'حفظ الدرس';

  @override
  String get delete => 'حذف';

  @override
  String get lessonManagement => 'إدارة الدرس';

  @override
  String get editLesson => 'تعديل الدرس';

  @override
  String get noTagsAvailable => 'لا توجد تاغات متاحة';

  @override
  String get noCoursesFound => 'لا يوجد كورسات';

  @override
  String get free => 'مجاني';

  @override
  String get deleteCourseTitle => 'حذف الكورس';

  @override
  String get deleteCourseConfirmation => 'هل أنت متأكد من حذف هذا الكورس؟';

  @override
  String get failedToUploadImage => 'فشل رفع الصورة';

  @override
  String get demoCourses => 'كورسات الغرفة';

  @override
  String get demoCoursesDescription => 'الكورسات المتاحة في الغرفة الخاص بك';

  @override
  String get availableCourses => 'كورسات متاحة';

  @override
  String get courses => 'الكورسات';

  @override
  String get publish => 'نشر';

  @override
  String get publishCourse => 'نشر الكورس';

  @override
  String get publishCourseConfirmation =>
      'هل أنت متأكد من نشر هذا الكورس؟ بعد النشر لن تتمكن من تعديله.';

  @override
  String get seeMore => 'عرض';

  @override
  String get producedBy => 'تم إعداده بواسطة';

  @override
  String get aboutThisCourse => 'عن هذا الكورس';

  @override
  String get courseContent => 'محتوى الكورس';

  @override
  String get courseDetails => 'تفاصيل الكورس';

  @override
  String get courseCreatedSuccessfully => 'تم إنشاء الدورة بنجاح';

  @override
  String get noSectionsAvailable => 'لا توجد أقسام متاحة';

  @override
  String get demoCreatedSuccessfully => 'تم إنشاء الديمو بنجاح!';

  @override
  String get removeUserPrompt => 'إزالة المستخدم؟';

  @override
  String get areYouSureRemoveUser =>
      'هل أنت متأكد أنك تريد إزالة هذا المستخدم؟';

  @override
  String get testPage => 'صفحة اختبار';

  @override
  String get openDiagram => 'فتح المخطط';

  @override
  String get photopeaEditor => 'محرر Photopea';

  @override
  String get englishLanguage => 'الإنجليزية';

  @override
  String get quizResult => 'نتيجة الاختبار';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get confirmAnswer => 'تأكيد الإجابة';

  @override
  String get usersTab => 'المستخدمون';

  @override
  String get demoStats => 'إحصائيات الغرفة';

  @override
  String get themeDark => 'داكن';

  @override
  String get areYouSureSendInvitation =>
      'هل أنت متأكد أنك تريد إرسال دعوة لهذا المستخدم؟';

  @override
  String get userAlreadyInvited => 'المستخدم مدعو بالفعل إلى هذه الغرفة';

  @override
  String get invitationSentSuccessfully => 'تم إرسال الدعوة بنجاح';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get noNewNotifications => 'لا توجد إشعارات جديدة';

  @override
  String get selectVideoFirst => 'يرجى اختيار فيديو أولاً.';

  @override
  String get operationInProgressTitle => 'عملية جارية';

  @override
  String get operationInProgressMessage =>
      'يوجد رفع فيديو أو إنشاء درس قيد التنفيذ. إذا غادرت الآن، قد يكتمل رفع الفيديو دون ربطه بالدرس. هل تريد المغادرة على أي حال؟';

  @override
  String get stay => 'البقاء';

  @override
  String get leaveAnyway => 'الخروج على أي حال';

  @override
  String get deleteLesson => 'حذف الدرس';

  @override
  String get deleteLessonFailed => 'فشل حذف الدرس.';

  @override
  String get leaveWhileBusyTitle => 'عملية قيد التنفيذ';

  @override
  String get leaveWhileBusyMessage =>
      'في عملية رفع/حفظ شغالة حالياً. إذا خرجت هلق، ممكن تخسر التغييرات. متأكد إنك بدك تطلع؟';

  @override
  String get lessonUpdatedSuccessfully => 'تم حفظ التعديلات بنجاح';

  @override
  String get lessonUpdateFailed => 'فشل حفظ التعديلات';

  @override
  String get deleteLessonConfirmation =>
      'هل أنت متأكد من حذف هذا الدرس؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get pressToSelectVideo => 'اضغط لاختيار فيديو';

  @override
  String get preparingToUpload => 'جاري التحضير للرفع...';

  @override
  String get processingVideo => 'جاري معالجة الفيديو...';

  @override
  String get uploadingVideo => 'جاري رفع الفيديو...';

  @override
  String invitedBy(String firstName, String lastName) {
    return 'تمت دعوتك بواسطة $firstName $lastName';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get quiz => 'اختبار';

  @override
  String get lessons => 'الدروس';

  @override
  String get duration => 'المدة';

  @override
  String get lessonOverview => 'نظرة عامة على الدرس';

  @override
  String get failedToOpenAttachment => 'تعذر فتح المرفق';

  @override
  String get videoLoadFailed => 'تعذر تحميل الفيديو';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get noFaqAvailable => 'لا توجد أسئلة شائعة';

  @override
  String get addFaq => 'إضافة سؤال شائع';

  @override
  String get question => 'السؤال';

  @override
  String get questionIsRequired => 'حقل السؤال مطلوب';

  @override
  String get answer => 'الإجابة';

  @override
  String get answerIsRequired => 'حقل الإجابة مطلوب';

  @override
  String get deleteFaq => 'حذف السؤال الشائع';

  @override
  String deleteFaqConfirmation(Object question) {
    return 'هل أنت متأكد من أنك تريد حذف \"$question\"؟';
  }

  @override
  String get tapToAddFaq => 'اضغط على \"إضافة سؤال شائع\" لإنشاء أول واحد.';

  @override
  String get noFaqsYet => 'لا توجد أسئلة شائعة بعد';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get enterSectionName => 'أدخل اسم القسم';

  @override
  String get sectionDescription => 'وصف القسم';

  @override
  String get enterSectionDescription => 'أدخل وصف القسم';

  @override
  String get manager => 'المدير';

  @override
  String get selectManager => 'اختر المدير';

  @override
  String get pleaseSelectManager => 'الرجاء اختيار مدير';

  @override
  String get departmentAddedSuccessfully => 'تم إضافة القسم بنجاح';

  @override
  String get requiredField => 'قسم مطلوب ';

  @override
  String get departmentMainPage => 'الرئيسية';

  @override
  String get departmentCourses => 'الدورات';

  @override
  String get departmentLeaderboard => 'لوحة الصدارة';

  @override
  String get departmentSendReport => 'إرسال تقرير';

  @override
  String get departmentChat => 'المحادثة';

  @override
  String get departmentMembers => 'الأعضاء';

  @override
  String get noMembersInDepartment => 'لا يوجد أعضاء في هذا القسم بعد.';

  @override
  String get selectJobTitle => 'اختر المسمى الوظيفي';

  @override
  String get jobTitle => 'المسمى الوظيفي';

  @override
  String get intern => 'متدرب';

  @override
  String get junior => 'مبتدئ';

  @override
  String get senior => 'خبير';

  @override
  String get addMember => 'إضافة عضو';

  @override
  String get memberAddedSuccessfully => 'تمت إضافة العضو بنجاح';

  @override
  String get searchDemoMembers => 'البحث عن أعضاء الغرفة';

  @override
  String get searchMembersHint => '...البحث بالاسم أو البريد الإلكتروني';

  @override
  String get noMembersFound => 'لم يتم العثور على أعضاء';

  @override
  String get removeMemberPrompt => 'إزالة العضو';

  @override
  String get areYouSureRemoveMember =>
      'هل أنت تأكد من رغبتك في إزالة هذا العضو من القسم؟';

  @override
  String get editDepartment => 'تعديل القسم';

  @override
  String get removeDepartment => 'حذف القسم';

  @override
  String get departmentUpdatedSuccessfully => 'تم تحديث القسم بنجاح';

  @override
  String get departmentDeletedSuccessfully => 'تم حذف القسم بنجاح';

  @override
  String get departmentLearningPath => 'مسار التعلم';

  @override
  String get departmentJourney => 'رحلة القسم';

  @override
  String get learningPath => 'المسار التعليمي';

  @override
  String get addCourseToPath => 'إضافة دورة للمسار';

  @override
  String get replace => 'استبدال';

  @override
  String get remove => 'إزالة';

  @override
  String get fetchDataPrompt => 'قم بطلب البيانات لعرض المسار';

  @override
  String errorOccurred(Object error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get departmentRoadmap => 'خارطة طريق القسم';

  @override
  String get roadmapSubtitle => 'مسار مهني خطوة بخطوة، مع المهارات والمشاريع.';

  @override
  String get newRoadmap => 'جديد';

  @override
  String get generateRoadmap => 'إنشاء خارطة الطريق';

  @override
  String get generateRoadmapDesc =>
      'أدخل عنواناً أو مساراً مهنياً (مثل: مهندس Flutter، عالم بيانات) لإنشاء مسار تعليمي مخصص:';

  @override
  String get roadmapTitleOrRole => 'عنوان خارطة الطريق / المسمى الوظيفي';

  @override
  String get roadmapTitleHint => 'مثال: مطور تطبيقات الهاتف';

  @override
  String get generate => 'إنشاء';

  @override
  String get noRoadmapYet => 'لا توجد خارطة طريق تعليمية بعد';

  @override
  String get emptyRoadmapDesc =>
      'قم بإنشاء خارطة طريق تعليمية أسبوعية منظمة تتضمن المهارات والمشاريع والمخرجات لهذا القسم.';

  @override
  String get generatingRoadmap => 'جاري إنشاء خارطة الطريق التعليمية...';

  @override
  String get generatingRoadmapSub => 'جاري تنظيم المواضيع والمهارات والمشاريع';

  @override
  String get failedToLoadRoadmap => 'فشل في تحميل خارطة الطريق';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get stepsLabel => 'الخطوات';

  @override
  String get durationLabel => 'المدة';

  @override
  String weeksCount(Object count) {
    return '$count أسابيع';
  }

  @override
  String get skillsCovered => 'المهارات المغطاة';

  @override
  String get practicalProjects => 'المشاريع العملية';

  @override
  String get deliverables => 'المخرجات';

  @override
  String get resources => 'المصادر';

  @override
  String weekPrefix(Object week) {
    return 'أ$week';
  }

  @override
  String get exportPdf => 'تصدير PDF';

  @override
  String get exportingPdf => 'جاري إنشاء ملف PDF...';

  @override
  String get deleteCourse => 'حذف الكورس';

  @override
  String get noCoursesInDepartment => 'لا يوجد كورسات في هذا القسم.';

  @override
  String get publicLibrary => 'المكتبة العامة';

  @override
  String get searchCourses => '..ابحث عن الكورسات أو المهارات';

  @override
  String get allFilters => 'كل الفلاتر';

  @override
  String get beginner => 'مبتدئ';

  @override
  String get intermediate => 'متوسط';

  @override
  String get advanced => 'متقدم';

  @override
  String showingResults(Object count) {
    return 'عرض $count نتيجة للبحث';
  }

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get popularity => 'الأكثر شعبية';

  @override
  String get enrollNow => 'سجل الآن';

  @override
  String get enrollToWatchLesson => 'سجل للتمكن من مشاهدة الدرس';

  @override
  String get exploreNewSkills => 'اكتشف شغفك وتعلّم مهارات جديدة';

  @override
  String get expandYourKnowledge => 'مئات الدورات التدريبية في انتظارك';

  @override
  String get checkoutError => 'حدث خطأ أثناء إنشاء عملية الدفع';

  @override
  String coursePurchaseSuccessMessage(String courseTitle) {
    return 'لقد قمت بشراء كورس \"$courseTitle\" بنجاح، ابدأ تعلمك الآن!';
  }

  @override
  String get alreadyEnrolled => 'مسجّل بالفعل';

  @override
  String get backToLibrary => 'العودة للمكتبة';

  @override
  String get aiAssistantTitle => 'مساعد الذكاء الاصطناعي';

  @override
  String get askQuestionSection => 'اطرح سؤالاً';

  @override
  String get askQuestionHint =>
      'مثال: ما هو الفرق بين Dependency Injection و Singleton؟';

  @override
  String get askButton => 'اسأل المساعد';

  @override
  String get topicQuizSection => 'اختبار لموضوع محدد';

  @override
  String get topicHint => 'مثال: Clean Architecture';

  @override
  String get questionCountHint => 'عدد الأسئلة';

  @override
  String get generateTopicQuizButton => 'إنشاء اختبار للموضوع';

  @override
  String get randomQuizSection => 'اختبار عشوائي للمقرر';

  @override
  String get generateRandomQuizButton => 'إنشاء اختبار عشوائي';

  @override
  String get aiResponseTitle => 'استجابة الذكاء الاصطناعي';

  @override
  String get noDataYet => 'اطرح سؤالاً أو أنشئ اختباراً لرؤية النتائج هنا.';

  @override
  String get errorPrefix => 'حدث خطأ: ';
}

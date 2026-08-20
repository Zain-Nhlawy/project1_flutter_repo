import 'dart:typed_data';

import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/certification/domain/entities/certification_entity.dart';
import 'package:project1/features/course/domain/entities/checkout_session_entity.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/department_course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/features/demo/domain/entities/invitation_entity.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/department/domain/entities/department_entity.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/features/department/domain/entities/leaderboard_member_entity.dart';
import 'package:project1/features/department/domain/entities/roadmap_entity.dart';
import 'package:project1/features/department_chat/domain/entities/department_attachment_file_entity.dart';
import 'package:project1/features/department_chat/domain/entities/department_attachment_upload_entity.dart';
import 'package:project1/features/department_chat/domain/entities/department_message_entity.dart';
import 'package:project1/features/department_chat/domain/entities/department_message_page_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_attachment_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_reply_preview_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_sender_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_type.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';
import 'package:project1/features/notifications/domain/entities/notification_payload_entity.dart';
import 'package:project1/features/Q&A/domain/entities/discussion_answer_entity.dart';
import 'package:project1/features/Q&A/domain/entities/discussion_question_entity.dart';
import 'package:project1/features/questions_bank/domain/entities/question_bank_entity.dart';
import 'package:project1/features/questions_bank/domain/entities/question_choice_entity.dart';
import 'package:project1/features/quiz/domain/entities/exam_Attempt_question_entity.dart';
import 'package:project1/features/quiz/domain/entities/exam_attempt_choice_entity.dart';
import 'package:project1/features/quiz/domain/entities/exam_attempt_entity.dart';
import 'package:project1/features/quiz/domain/entities/exam_entity.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';

// ---------------- Lesson ----------------

final dummyLessonAttachment = LessonAttachmentEntity(
  id: '1',
  name: 'Attachment file name',
  path: '',
  lessonId: '1',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// ---------------- User ----------------

final dummyUser = UserEntity(
  id: '1',
  firstName: 'First',
  lastName: 'Last',
  email: 'user@example.com',
  birthDate: '',
  imagePath: '',
  role: 'USER',
  isEmailVerified: false,
  isTwoFactorEnabled: false,
);

// ---------------- Certification ----------------

final dummyCertification = CertificationEntity(
  id: '1',
  courseId: '1',
  score: 0,
  demoName: 'Company name',
  userName: 'User name',
  logoImagePath: '',
  courseName: 'Course title placeholder',
  signature: '',
  issuedAt: DateTime.now(),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// ---------------- Course ----------------

final dummyCourse = CourseEntity(
  id: '1',
  title: 'Course title placeholder',
  description: 'Description placeholder text goes here for skeleton',
  visibility: 'PUBLIC',
  price: 0,
  imagePath: '',
  demoId: '1',
  assetId: '1',
  tagIds: const ['1', '2'],
  tags: const ['Tag one', 'Tag two'],
  demo: null,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  sectionsCount: 3,
  totalLessons: 10,
  totalDuration: 3600,
  isPublished: true,
);

final dummyDepartmentCourseInfo = DepartmentCourseInfoEntity(
  id: '1',
  title: 'Course title placeholder',
  visibility: 'PUBLIC',
  price: 0,
  description: 'Description placeholder text goes here for skeleton',
  imagePath: '',
  isPublished: true,
  sectionsCount: 3,
  lessonCount: 10,
  totalDuration: 3600,
);

final dummyDepartmentCourseAsset = DepartmentCourseAssetEntity(
  id: '1',
  demoId: '1',
  accessMethod: 'PURCHASED',
  acquiredAt: DateTime.now(),
  updatedAt: DateTime.now(),
  course: dummyDepartmentCourseInfo,
);

final dummyDepartmentCourse = DepartmentCourseEntity(
  id: '1',
  departmentId: '1',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  asset: dummyDepartmentCourseAsset,
);

// ---------------- Tag / Checkout ----------------

final dummyTag = TagEntity(id: '1', name: 'Tag name');

final dummyCheckoutSession = CheckoutSessionEntity(url: '');

// ---------------- Demo (Company) ----------------

final dummyDemo = DemoEntity(
  id: '1',
  name: 'Company name',
  description: 'Description placeholder text',
  imagePath: '',
  signatureImagePath: '',
  ownerName: 'Owner name',
  isOwner: false,
  plan: 'FREE',
  membersCount: 10,
  createdAt: DateTime.now(),
);

final dummyMember = MembersEntity(
  id: '1',
  demoId: '1',
  memberIdInDemo: '1',
  firstName: 'First',
  lastName: 'Last',
  email: 'member@example.com',
  imagePath: '',
  role: 'MEMBER',
);

final dummyInquiry = InquiryEntity(
  id: '1',
  subject: 'Subject placeholder',
  message: 'Message placeholder text goes here',
  demoId: '1',
  status: 'PENDING',
  creator: dummyMember,
  reply: null,
);

final dummyInvitation = InvitationEntity(
  id: '1',
  demoName: 'Company name',
  demoImagePath: '',
  senderFirstName: 'First',
  senderLastName: 'Last',
);

// ---------------- Department ----------------

final dummyDepartment = DepartmentEntity(
  id: '1',
  name: 'Department name',
  managerId: '1',
  description: 'Description placeholder text',
  memberCount: 5,
  isJoined: true,
  isGroup: false,
);

final dummyDepartmentMember = DepartmentMemberEntity(
  id: '1',
  departmentId: '1',
  jobTitle: 'Job title placeholder',
  demoMemberId: '1',
  userId: '1',
  firstName: 'First',
  lastName: 'Last',
  email: 'member@example.com',
  imagePath: '',
  role: 'MEMBER',
);

final dummyLeaderboardMember = LeaderboardMemberEntity(
  rank: 1,
  userId: '1',
  departmentMemberId: '1',
  firstName: 'First',
  lastName: 'Last',
  imagePath: '',
  jobTitle: 'Job title placeholder',
  totalScore: 100,
);

final dummyLeaderboardMembers = List<LeaderboardMemberEntity>.generate(
  5,
  (index) => LeaderboardMemberEntity(
    rank: index + 1,
    userId: 'user-${index + 1}',
    departmentMemberId: 'member-${index + 1}',
    firstName: 'First',
    lastName: 'Last',
    imagePath: '',
    jobTitle: 'Job title placeholder',
    totalScore: 100 - (index * 5),
  ),
  growable: false,
);

// ---------------- Department Attachments ----------------

final dummyDepartmentAttachmentFile = DepartmentAttachmentFileEntity(
  fileName: 'file.png',
  mimeType: 'image/png',
  bytes: Uint8List(0),
);

final dummyDepartmentAttachmentUpload = DepartmentAttachmentUploadEntity(
  fileName: 'file.png',
  uploadUrl: '',
  fileKey: '',
  isPublic: true,
  cdnUrl: '',
);

// ---------------- Department Messages ----------------

final dummyMessageSender = MessageSenderEntity(
  id: '1',
  firstName: 'First',
  lastName: 'Last',
  imagePath: '',
);

final dummyMessageAttachment = MessageAttachmentEntity(
  fileUrl: '',
  fileName: 'file.png',
  mimeType: 'image/png',
  fileSize: 0,
);

final dummyMessageReplyPreview = MessageReplyPreviewEntity(
  id: '1',
  content: 'Reply preview text',
  type: MessageType.text,
);

final dummyDepartmentMessage = DepartmentMessageEntity(
  id: '1',
  departmentId: '1',
  type: MessageType.text,
  content: 'Message placeholder text goes here',
  isEdited: false,
  isDeleted: false,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  sender: dummyMessageSender,
  attachment: null,
  replyTo: null,
);

final dummyDepartmentMessagePage = DepartmentMessagePageEntity(
  messages: [dummyDepartmentMessage],
  hasNextPage: false,
  endCursor: null,
);

// ---------------- Roadmap ----------------

final dummyRoadmapStep = RoadmapStepEntity(
  week: 1,
  topic: 'Topic placeholder',
  goal: 'Goal placeholder text',
  skills: const ['Skill one', 'Skill two'],
  projects: const ['Project one'],
  deliverables: const ['Deliverable one'],
  resources: const ['Resource one'],
);

final dummyRoadmap = RoadmapEntity(
  title: 'Roadmap title placeholder',
  description: 'Description placeholder text',
  duration: '4 weeks',
  difficulty: 'Beginner',
  prerequisites: const ['Prerequisite one'],
  careerOutcomes: const ['Outcome one'],
  steps: [dummyRoadmapStep],
);

// ---------------- Course FAQ ----------------

final dummyCourseFaq = CourseFaqEntity(
  id: '1',
  question: 'Question placeholder text?',
  answer: 'Answer placeholder text goes here for skeleton',
  courseId: '1',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// ---------------- Lesson ----------------

final dummyLesson = LessonEntity(
  id: '1',
  title: 'Lesson title placeholder',
  order: 1,
  videoUrl: '',
  subTitleUrl: null,
  sectionId: '1',
  duration: 600,
  description: 'Description placeholder text goes here',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// ---------------- Live Stream ----------------

final dummyLiveStream = LiveStreamEntity(
  id: '1',
  title: 'Live stream title placeholder',
  description: 'Description placeholder text goes here',
  scheduledAt: DateTime.now(),
  startedAt: null,
  endedAt: null,
  status: 'SCHEDULED',
  departmentId: '1',
  hostId: '1',
  roomName: '',
  createdAt: DateTime.now(),
);

final dummyLiveStreamToken = LiveStreamTokenEntity(
  token: '',
  serverUrl: '',
  roomName: '',
  appId: '',
);

// ---------------- Notification ----------------

final dummyNotificationPayload = NotificationPayloadEntity(
  title: 'Notification title placeholder',
  body: 'Notification body placeholder text',
  type: 'GENERAL',
  data: const {},
);

// ---------------- Discussion ----------------

final dummyDiscussionAnswer = DiscussionAnswerEntity(
  id: '1',
  questionId: '1',
  content: 'Answer placeholder text goes here',
  authorName: 'Author name',
  authorAvatarUrl: '',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  authorId: '1',
);

final dummyDiscussionQuestion = DiscussionQuestionEntity(
  id: '1',
  lessonId: '1',
  content: 'Question placeholder text goes here',
  authorName: 'Author name',
  authorAvatarUrl: '',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  authorId: '1',
);

// ---------------- Questions Bank ----------------

final dummyQuestionChoice = QuestionChoiceEntity(
  choice: 'Choice placeholder',
  isCorrect: false,
);

final dummyQuestionBank = QuestionBankEntity(
  id: '1',
  sectionId: '1',
  question: 'Question placeholder text?',
  note: 'Note placeholder text',
  choices: [dummyQuestionChoice, dummyQuestionChoice],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// ---------------- Quiz / Exam ----------------

final dummyExamAttemptChoice = ExamAttemptChoiceEntity(
  id: '1',
  choice: 'Choice placeholder',
  isCorrect: null,
);

final dummyExamAttempt = ExamAttemptEntity(
  id: '1',
  demoMemberId: '1',
  examId: '1',
  score: 0,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final dummyExamAttemptQuestion = ExamAttemptQuestionEntity(
  id: '1',
  question: 'Question placeholder text?',
  note: 'Note placeholder text',
  choices: [dummyExamAttemptChoice, dummyExamAttemptChoice],
);

final dummyExam = ExamEntity(
  id: '1',
  sectionId: '1',
  title: 'Exam title placeholder',
  numberOfQuestions: 10,
  durationMinutes: 30,
  passingScore: 60,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

final dummyGeneratedExam = GeneratedExamEntity(
  id: '1',
  sectionId: '1',
  title: 'Exam title placeholder',
  durationMinutes: 30,
  numberOfQuestions: 10,
  passingScore: 60,
  questions: [dummyExamAttemptQuestion],
);

// ---------------- Section ----------------

final dummySection = SectionEntity(
  id: '1',
  courseId: '1',
  title: 'Section title placeholder',
  order: 1,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

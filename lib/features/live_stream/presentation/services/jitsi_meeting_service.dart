import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class JitsiMeetingService {
  final JitsiMeet _jitsiMeet = JitsiMeet();

  Future<void> joinMeeting({
    required String roomName,
    required String token,
    required String displayName,
    String? email,
    String? avatarUrl,
    required String subject,
    required bool isHost,
    String? serverUrl,
    JitsiMeetEventListener? eventListener,
  }) async {
    final targetServer = (serverUrl != null && serverUrl.isNotEmpty) ? serverUrl : "https://meet.jit.si";

    final options = JitsiMeetConferenceOptions(
      serverURL: targetServer.startsWith('http') ? targetServer : 'https://$targetServer',
      room: roomName,
      token: token,
      configOverrides: {
        "startWithAudioMuted": !isHost,
        "startWithVideoMuted": !isHost,
        "subject": subject,
      },
      featureFlags: {
        FeatureFlags.welcomePageEnabled: false,
        FeatureFlags.preJoinPageEnabled: isHost,
        FeatureFlags.unsafeRoomWarningEnabled: false,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: displayName,
        email: email,
        avatar: avatarUrl,
      ),
    );

    await _jitsiMeet.join(
      options,
      eventListener ?? JitsiMeetEventListener(),
    );
  }

  Future<void> hangUp() async {
    await _jitsiMeet.hangUp();
  }
}

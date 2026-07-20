import 'package:project1/features/demo/domain/entities/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  InvitationModel({
    required super.id,
    required super.demoName,
    required super.demoImagePath,
    required super.senderFirstName,
    required super.senderLastName,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'] ?? '',
      demoName: json['demo']?['name'] ?? '',
      demoImagePath: json['demo']?['imagePath'] ?? '',
      senderFirstName: json['sender']?['firstName'] ?? '',
      senderLastName: json['sender']?['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'demo': {'name': demoName, 'imagePath': demoImagePath},
      'sender': {'firstName': senderFirstName, 'lastName': senderLastName},
    };
  }
}

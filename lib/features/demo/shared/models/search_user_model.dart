import 'package:project1/features/demo/shared/entities/user_entity.dart';

class SearchUserModel extends MembersEntity {
  const SearchUserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.imagePath,
  });

  factory SearchUserModel.fromJson(Map<String, dynamic> json) {
    return SearchUserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'imagePath': imagePath,
    };
  }
}
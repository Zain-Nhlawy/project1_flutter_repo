import 'package:project1/features/course/domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  const TagModel({required super.id, required super.name});

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(id: json['id']?.toString() ?? '', name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  TagEntity toEntity() {
    return TagEntity(id: id, name: name);
  }
}

import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class DemoModel extends DemoEntity {
  DemoModel({
     super.id, 
    required super.name,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      id: json['id'] as String?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
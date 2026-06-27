import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class DemoModel extends DemoEntity {
  DemoModel({

    required super.name,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
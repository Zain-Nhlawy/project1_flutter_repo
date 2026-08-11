import 'package:flutter/material.dart';

class AddDemoState {
  final int currentPage;
  final List<Map<String, dynamic>> availableFeatures;
  final List<int> selectedFeatureIndices;
  final String demoName;
  final String demoDescription;
  final String demoImagePath;
  final String signatureImagePath;
  final String selectedPlan;

  AddDemoState({
    this.currentPage = 0,
    this.availableFeatures = const [
      {
        "title": "API Tester",
        "description":
            "Built-in tool to test endpoints directly inside the demo room.",
        "icon": Icons.api_rounded,
        "color": Colors.purple,
      },
      {
        "title": "Custom Drawer",
        "description":
            "Add a fully customizable side drawer for quick navigation.",
        "icon": Icons.view_sidebar_rounded,
        "color": Colors.blue,
      },
      {
        "title": "Advanced Analytics",
        "description": "Track user interactions and get detailed reports.",
        "icon": Icons.analytics_rounded,
        "color": Colors.teal,
      },
    ],
    this.selectedFeatureIndices = const [0],
    this.demoName = '',
    this.demoDescription = '',
    this.demoImagePath = '',
    this.signatureImagePath = '',
    this.selectedPlan = 'STARTER',
  });

  AddDemoState copyWith({
    int? currentPage,
    List<int>? selectedFeatureIndices,
    String? demoName,
    String? demoDescription,
    String? demoImagePath,
    String? signatureImagePath,
    String? selectedPlan,
  }) {
    return AddDemoState(
      currentPage: currentPage ?? this.currentPage,
      availableFeatures: availableFeatures,
      selectedFeatureIndices:
          selectedFeatureIndices ?? this.selectedFeatureIndices,
      demoName: demoName ?? this.demoName,
      demoDescription: demoDescription ?? this.demoDescription,
      demoImagePath: demoImagePath ?? this.demoImagePath,
      signatureImagePath: signatureImagePath ?? this.signatureImagePath,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}

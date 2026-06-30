import 'package:flutter/material.dart';

class AddDemoState {
  final int currentPage;
  final List<Map<String, dynamic>> availableFeatures;
  final List<int> selectedFeatureIndices;
  final String demoName;
  final String demoDescription;
  final String demoImagePath;
  final String selectedPlan;

  AddDemoState({
    this.currentPage = 0,
    this.availableFeatures = const [
      {
        "title": "API Tester",
        "description": "Built-in tool to test endpoints directly inside the demo room.",
        "price": 15.0,
        "icon": Icons.api_rounded,
        "color": Colors.purple,
      },
      {
        "title": "Custom Drawer",
        "description": "Add a fully customizable side drawer for quick navigation.",
        "price": 8.0,
        "icon": Icons.view_sidebar_rounded,
        "color": Colors.blue,
      },
      {
        "title": "Advanced Analytics",
        "description": "Track user interactions and get detailed reports.",
        "price": 25.0,
        "icon": Icons.analytics_rounded,
        "color": Colors.teal,
      },
    ],
    this.selectedFeatureIndices = const [0],
    this.demoName = '',
    this.demoDescription = '',
    this.demoImagePath = '',
    this.selectedPlan = 'STARTER',
  });

  double get planPrice {
    switch (selectedPlan) {
      case 'PRO':
        return 100.0;
      case 'ENTERPRISE':
        return 200.0;
      case 'STARTER':
      default:
        return 20.0;
    }
  }

  double get totalPrice {
    double total = planPrice;
    for (int index in selectedFeatureIndices) {
      total += availableFeatures[index]["price"];
    }
    return total;
  }

  AddDemoState copyWith({
    int? currentPage,
    List<int>? selectedFeatureIndices,
    String? demoName,
    String? demoDescription,
    String? demoImagePath,
    String? selectedPlan,
  }) {
    return AddDemoState(
      currentPage: currentPage ?? this.currentPage,
      availableFeatures: availableFeatures,
      selectedFeatureIndices: selectedFeatureIndices ?? this.selectedFeatureIndices,
      demoName: demoName ?? this.demoName,
      demoDescription: demoDescription ?? this.demoDescription,
      demoImagePath: demoImagePath ?? this.demoImagePath,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}
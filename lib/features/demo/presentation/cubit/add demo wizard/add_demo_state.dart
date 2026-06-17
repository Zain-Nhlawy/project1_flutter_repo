import 'package:flutter/material.dart' show Colors, Icons;



class AddDemoState {
  final int currentPage;
  final double basePrice;
  final List<Map<String, dynamic>> availableFeatures;
  final List<int> selectedFeatureIndices;

  AddDemoState({
    this.currentPage = 0,
    this.basePrice = 50.0,
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
  });

  double get totalPrice {
    double total = basePrice;
    for (int index in selectedFeatureIndices) {
      total += availableFeatures[index]["price"];
    }
    return total;
  }

  AddDemoState copyWith({
    int? currentPage,
    List<int>? selectedFeatureIndices,
  }) {
    return AddDemoState(
      currentPage: currentPage ?? this.currentPage,
      basePrice: basePrice,
      availableFeatures: availableFeatures,
      selectedFeatureIndices: selectedFeatureIndices ?? this.selectedFeatureIndices,
    );
  }
}
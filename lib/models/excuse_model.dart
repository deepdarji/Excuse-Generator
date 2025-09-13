import 'dart:math';
import 'package:flutter/material.dart';
import '../data/excuses.dart'; // Import excuses from separate file

class ExcuseModel extends ChangeNotifier {
  final Map<String, List<String>> _excusesByCategory = excusesByCategory;

  String currentExcuse = '';
  String currentCategory = 'All';
  List<String> history = []; // Add history for generated excuses

  List<String> get categories => ['All', ..._excusesByCategory.keys];

  void setCategory(String category) {
    if (categories.contains(category)) {
      currentCategory = category;
      notifyListeners();
    }
  }

  void generateExcuse() {
    String selectedCategory = currentCategory;
    if (selectedCategory == 'All') {
      final categoryKeys = _excusesByCategory.keys.toList();
      selectedCategory = categoryKeys[Random().nextInt(categoryKeys.length)];
    }

    final excuses = _excusesByCategory[selectedCategory] ?? [];
    if (excuses.isEmpty) {
      currentExcuse = 'No excuses found for this category!';
    } else {
      currentExcuse = excuses[Random().nextInt(excuses.length)];
    }
    history.add(currentExcuse); // Add to history
    if (history.length > 10) history.removeAt(0); // Limit history to 10
    notifyListeners();
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
  }
}

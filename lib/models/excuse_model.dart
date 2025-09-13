import 'dart:math';
import 'package:flutter/material.dart';
import '../data/excuses.dart'; // file where excuses data is stored

// Beginner style excuse model
class ExcuseModel extends ChangeNotifier {
  // store all excuses by category
  Map<String, List<String>> allExcuses = excusesByCategory;

  // current selected excuse and category
  String currentExcuse = "";
  String currentCategory = "All";

  // keep old excuses (like history)
  List<String> history = [];

  // get list of categories
  List<String> get categories {
    return ["All", ...allExcuses.keys];
  }

  // change the category
  void setCategory(String newCategory) {
    if (categories.contains(newCategory)) {
      currentCategory = newCategory;
      notifyListeners();
    }
  }

  // generate a random excuse
  void generateExcuse() {
    String selected = currentCategory;

    // if category is "All", pick random category first
    if (selected == "All") {
      var keys = allExcuses.keys.toList();
      selected = keys[Random().nextInt(keys.length)];
    }

    // get excuses of that category
    List<String> list = allExcuses[selected] ?? [];

    // if no excuse is found
    if (list.isEmpty) {
      currentExcuse = "No excuses found for this category!";
    } else {
      // pick random excuse
      currentExcuse = list[Random().nextInt(list.length)];
    }

    // add in history
    history.add(currentExcuse);

    // keep only last 10 excuses
    if (history.length > 10) {
      history.removeAt(0);
    }

    notifyListeners();
  }

  // clear all history
  void clearHistory() {
    history.clear();
    notifyListeners();
  }
}

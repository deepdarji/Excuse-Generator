import 'dart:math';

import 'package:flutter/material.dart';

class ExcuseModel extends ChangeNotifier {
  final Map<String, List<String>> _excusesByCategory = {
    'Work': [
      "Sorry, I can’t come. My fridge challenged me to a staring contest.",
      "My alarm clock and I had a fight this morning. It won.",
      "I’m stuck in a time loop from watching too many reruns.",
      "My coffee machine went on strike demanding better beans.",
      "Aliens borrowed my car keys last night.",
      "I accidentally joined a cult of productivity haters.",
      "My shadow quit and I’m waiting for a replacement.",
      "The dog ate my motivation.",
      "I’m allergic to Mondays.",
      "My WiFi is holding my laptop hostage.",
    ],
    'Friends': [
      "Can’t make it, my pet rock is feeling under the weather.",
      "I’m in the middle of a heated debate with my socks.",
      "My imaginary friend is throwing a party.",
      "I got lost in my own backyard.",
      "My phone autocorrected 'yes' to 'no' and I’m committed now.",
      "I’m training my goldfish to do tricks.",
      "The voices in my head scheduled a meeting.",
      "I’m boycotting social events until pizza is free.",
      "My couch won’t let me go.",
      "I’m auditioning for a role as a hermit.",
    ],
    'Parents': [
      "Sorry, I’m busy teaching my cat quantum physics.",
      "My homework spontaneously combusted.",
      "I’m on a secret mission to find the end of the rainbow.",
      "The internet ate my chores.",
      "I’m in witness protection from my siblings.",
      "My room cleaned itself... in my dreams.",
      "I’m protesting bedtime laws.",
      "Aliens needed help with their homework.",
      "I got stuck in a video game level.",
      "My teddy bear is having an existential crisis.",
    ],
  };

  String currentExcuse = '';
  String currentCategory = 'All';

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
    notifyListeners();
  }
}

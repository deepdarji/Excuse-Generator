import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/excuse_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isDarkMode = false; // Simplified toggle; in production, use provider for global theme

  @override
  Widget build(BuildContext context) {
    final excuseModel = Provider.of<ExcuseModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Excuse Generator'),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              // To actually toggle theme, you'd update ThemeMode in a provider
              // For simplicity, this just demonstrates the UI
            },
          ),
          const Icon(Icons.brightness_6), // Theme icon
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: excuseModel.currentCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    excuseModel.setCategory(newValue);
                  }
                },
                items: excuseModel.categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: excuseModel.generateExcuse,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Generate Excuse'),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: excuseModel.currentExcuse.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  excuseModel.currentExcuse,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              if (excuseModel.currentExcuse.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    Share.share(excuseModel.currentExcuse);
                  },
                  child: const Text('Share Excuse'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
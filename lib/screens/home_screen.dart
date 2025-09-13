import 'dart:ui'; // For BackdropFilter
import 'package:confetti/confetti.dart'; // For confetti
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart'; // Cool fonts
import 'package:flutter_animate/flutter_animate.dart'; // Advanced animations
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Ads

import '../models/excuse_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;
  late ConfettiController _confettiController;
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-3940256099942544/6300978111', // Test ID, replace with real
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final excuseModel = Provider.of<ExcuseModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Excuse Generator',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              // Note: For real theme toggle, use a ThemeProvider
            },
          ),
          const Icon(Icons.brightness_6),
        ],
      ),
      body: Stack(
        children: [
          // Gradient background for cool look
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.grey[800]!, Colors.black]
                    : [Colors.blue[100]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SegmentedButton for categories (Material 3 modern)
                    SegmentedButton<String>(
                      segments: excuseModel.categories
                          .map((cat) =>
                              ButtonSegment(value: cat, label: Text(cat)))
                          .toList(),
                      selected: {excuseModel.currentCategory},
                      onSelectionChanged: (Set<String> newSelection) {
                        excuseModel.setCategory(newSelection.first);
                      },
                    )
                        .animate()
                        .slideY(duration: 500.ms, curve: Curves.easeInOut),
                    const SizedBox(height: 20),
                    // Generate button with neumorphism
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.5)
                                : Colors.grey.withOpacity(0.3),
                            offset: const Offset(5, 5),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: isDark ? Colors.grey[800]! : Colors.white,
                            offset: const Offset(-5, -5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          excuseModel.generateExcuse();
                          _confettiController.play(); // Confetti on generate
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark ? Colors.grey[700] : Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text('Generate Excuse',
                            style:
                                GoogleFonts.poppins(color: Colors.green[700])),
                      ),
                    )
                        .animate()
                        .scale(duration: 300.ms, curve: Curves.bounceOut),
                    const SizedBox(height: 20),
                    // Excuse display with glassmorphism
                    if (excuseModel.currentExcuse.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Text(
                              excuseModel.currentExcuse,
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: isDark ? Colors.white : Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .shake(curve: Curves.easeInOut),
                    const SizedBox(height: 20),
                    if (excuseModel.currentExcuse.isNotEmpty)
                      ElevatedButton(
                        onPressed: () => Share.share(excuseModel.currentExcuse),
                        child:
                            Text('Share Excuse', style: GoogleFonts.poppins()),
                      ).animate().slideX(duration: 400.ms),
                    const SizedBox(height: 20),
                    // History list
                    if (excuseModel.history.isNotEmpty)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ListTile(
                                title: Text('Recent Excuses',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold))),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: excuseModel.history.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(excuseModel.history[index],
                                      style: GoogleFonts.roboto(fontSize: 14)),
                                ).animate().fadeIn(delay: (100 * index).ms);
                              },
                            ),
                            TextButton(
                              onPressed: excuseModel.clearHistory,
                              child: Text('Clear History',
                                  style:
                                      GoogleFonts.poppins(color: Colors.red)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd?.size.height.toDouble(),
              width: _bannerAd?.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox(),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../models/excuse_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  ConfettiController? confettiController;
  BannerAd? bannerAd;
  bool adLoaded = false;

  @override
  void initState() {
    super.initState();
    // confetti for celebration
    confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // load ad
    loadBannerAd();
  }

  void loadBannerAd() {
    try {
      bannerAd = BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111', // test id
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print("Ad Loaded");
            setState(() {
              adLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            print("Ad Failed ${error.message}");
            ad.dispose();
            setState(() {
              adLoaded = false;
            });
          },
          onAdImpression: (ad) {
            print("Ad Impression");
          },
        ),
      );
      bannerAd?.load();
    } catch (e) {
      print("Ad Error $e");
      adLoaded = false;
    }
  }

  @override
  void dispose() {
    confettiController?.dispose();
    bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var excuseModel = Provider.of<ExcuseModel>(context);
    var isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Excuse Generator",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // simple gradient background
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // categories
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: excuseModel.categories.length,
                        itemBuilder: (context, i) {
                          var category = excuseModel.categories[i];
                          var selected =
                              category == excuseModel.currentCategory;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(
                                category,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: selected
                                      ? Colors.white
                                      : isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                ),
                              ),
                              selected: selected,
                              onSelected: (val) {
                                if (val) {
                                  excuseModel.setCategory(category);
                                }
                              },
                              selectedColor: Colors.blue[700],
                              backgroundColor:
                                  isDark ? Colors.grey[700] : Colors.grey[200],
                            ).animate().fadeIn(delay: (100 * i).ms),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // generate button
                    ElevatedButton(
                      onPressed: () {
                        excuseModel.generateExcuse();
                        confettiController?.play();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            isDark ? Colors.grey[700] : Colors.white,
                      ),
                      child: Text(
                        "Generate Excuse",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    )
                        .animate()
                        .scale(duration: 300.ms, curve: Curves.bounceOut),

                    const SizedBox(height: 20),

                    // excuse text
                    if (excuseModel.currentExcuse.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
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
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .shake(curve: Curves.easeInOut),

                    const SizedBox(height: 20),

                    // share button
                    if (excuseModel.currentExcuse.isNotEmpty)
                      ElevatedButton(
                        onPressed: () {
                          Share.share(excuseModel.currentExcuse);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          "Share Excuse",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ).animate().slideX(duration: 400.ms),

                    const SizedBox(height: 20),

                    // history
                    if (excuseModel.history.isNotEmpty)
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Recent Excuses",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: excuseModel.history.length,
                              itemBuilder: (context, i) {
                                return ListTile(
                                  title: Text(
                                    excuseModel.history[i],
                                    style: GoogleFonts.roboto(fontSize: 14),
                                  ),
                                ).animate().fadeIn(delay: (100 * i).ms);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                excuseModel.clearHistory();
                              },
                              child: Text(
                                "Clear History",
                                style: GoogleFonts.poppins(color: Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController!,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          )
        ],
      ),

      // ad at bottom
      bottomNavigationBar: adLoaded && bannerAd != null
          ? SizedBox(
              height: bannerAd!.size.height.toDouble(),
              width: bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          : const SizedBox(),
    );
  }
}

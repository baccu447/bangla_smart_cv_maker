import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // Hero Animation or Logo
                    SizedBox(
                      height: 250,
                      child: Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_u4jjb9bd.json', // Placeholder Resume Animation
                        errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.description_outlined, size: 100, color: Theme.of(context).primaryColor),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(),
                    
                    SizedBox(height: 30),
                    
                    Text(
                      'Build Your Career',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                      textAlign: TextAlign.center,
                    ).animate().slideY(begin: 0.3, end: 0, delay: 200.ms).fadeIn(),
                    
                    SizedBox(height: 10),
                    
                    Text(
                      'Create a professional CV in minutes with our smart templates.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ).animate().slideY(begin: 0.3, end: 0, delay: 300.ms).fadeIn(),
                    
                    SizedBox(height: 50),
                    
                    // Action Buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Get.toNamed('/editor'),
                        style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit_document),
                            SizedBox(width: 10),
                            Text('Create New CV', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ).animate().slideY(begin: 0.5, end: 0, delay: 400.ms).fadeIn(),

                    SizedBox(height: 20),

                    OutlinedButton(
                      onPressed: () {
                        Get.snackbar("Coming Soon", "Saved CVs feature is under development!");
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text('My Saved CVs', style: TextStyle(color: Theme.of(context).primaryColor)),
                    ).animate().slideY(begin: 0.5, end: 0, delay: 500.ms).fadeIn(),
                  ],
                ),
              ),
            ),
            
            if (_isLoaded)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}

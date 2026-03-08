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
                    // Animated Logo
                    SizedBox(
                      height: 220,
                      child: Lottie.network(
                        'https://assets9.lottiefiles.com/packages/lf20_u4jjb9bd.json', // CV Animation
                        errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.description_outlined, size: 100, color: Theme.of(context).primaryColor),
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(),
                    
                    SizedBox(height: 30),
                    
                    Text(
                      'Bangla Smart CV Maker',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ).animate().slideY(begin: 0.3, end: 0, delay: 200.ms).fadeIn(),
                    
                    SizedBox(height: 10),
                    
                    Text(
                      'চাকরির জন্য প্রফেশনাল সিভি তৈরি করুন ১ মিনিটে!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                      textAlign: TextAlign.center,
                    ).animate().slideY(begin: 0.3, end: 0, delay: 300.ms).fadeIn(),
                    
                    SizedBox(height: 40),

                    // Feature Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildFeatureCard(
                          context, 
                          icon: Icons.edit_document, 
                          title: 'Create CV', 
                          color: Color(0xFF6C63FF),
                          onTap: () => Get.toNamed('/editor'),
                        ),
                        _buildFeatureCard(
                          context, 
                          icon: Icons.folder_open, 
                          title: 'My CVs', 
                          color: Color(0xFFFF6584),
                          onTap: () => Get.snackbar("Coming Soon", "Saved CVs feature is under development!"),
                        ),
                        _buildFeatureCard(
                          context, 
                          icon: Icons.lightbulb_outline, 
                          title: 'Tips', 
                          color: Color(0xFF4DB6AC),
                          onTap: () => Get.snackbar("Tips", "Use professional summary and clear fonts."),
                        ),
                        _buildFeatureCard(
                          context, 
                          icon: Icons.settings, 
                          title: 'Settings', 
                          color: Color(0xFFFFD54F),
                          onTap: () {},
                        ),
                      ],
                    ).animate().slideY(begin: 0.5, end: 0, delay: 400.ms).fadeIn(),
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

  Widget _buildFeatureCard(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            SizedBox(height: 12),
            Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

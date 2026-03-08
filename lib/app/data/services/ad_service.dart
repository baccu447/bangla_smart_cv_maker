import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdService extends GetxService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Test Ad Unit IDs
  final String _bannerAdUnitId = kDebugMode 
      ? 'ca-app-pub-3940256099942544/6300978111' 
      : 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx'; // Replace with real ID
  final String _interstitialAdUnitId = kDebugMode 
      ? 'ca-app-pub-3940256099942544/1033173712' 
      : 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  final String _rewardedAdUnitId = kDebugMode 
      ? 'ca-app-pub-3940256099942544/5224354917' 
      : 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    return this;
  }

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitial(); // Reload for next time
    } else {
      loadInterstitial();
    }
  }

  void loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showRewarded(Function onRewardEarned) {
    if (_rewardedAd != null) {
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewardEarned();
      });
      _rewardedAd = null;
      loadRewarded(); // Reload
    } else {
      loadRewarded();
      Get.snackbar('Ad not ready', 'Please try again in a moment');
    }
  }
}

//
//  GoogleAdsViewModel.swift
//  한들
//
//  Created by 강희영 on 2022/04/25.
//

import UIKit
import GoogleMobileAds

class SomeViewController: UIViewController, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
    }
    
    func doSomething(_ sender: Any) {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            if interstitial != nil {
                let root = UIApplication.shared.windows.first?.rootViewController
                interstitial!.present(fromRootViewController: root!)
            } else {
                print("Ad wasn't ready")
            }
        }
        )
    }
}

class RewardedADViewController: UIViewController, GADFullScreenContentDelegate {
    let adUnitID = "ca-app-pub-3940256099942544/6978759866"
    let adUnitReleaseID = "ca-app-pub-3856199712576441/1416812814"
    var rewardedInterstitialAD: GADRewardedInterstitialAd?
    
    func loadAD() {
        GADRewardedInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            rewardedInterstitialAD = ad
            rewardedInterstitialAD?.fullScreenContentDelegate = self
        }
    }
    
    func doSomething(completionHandler: @escaping (Bool) -> ()) {
            if rewardedInterstitialAD != nil {
                let root = UIApplication.shared.windows.first?.rootViewController
                rewardedInterstitialAD?.present(fromRootViewController: root!, userDidEarnRewardHandler: {
                    print("earn reward")
                    completionHandler(true)
                })
            } else {
                print("AD wasn't ready")
                completionHandler(false)
            }
    }
    
    func didRewardUser(with reward: GADAdReward) -> Bool {
        print("didRewardUser")
        return true
    }
    
    func didStartVideo() {
        print("didStartVideo")
    }
    
    func didEndVideo() {
        print("didEndVideo")
        loadAD()
    }
    
    func reportImpression() {
        print("reportImpression")
    }
    
    func reportClick() {
        print("reportClick")
    }
    
    func willPresentFullScreenView() {
        print("willPresentFullScreenView")
    }
    
    func didFailToPresentWithError(_ error: Error) {
        print("didFailToPresentWithError")
        loadAD()
    }
    
    func willDismissFullScreenView() {
        print("willDismissFullScreenView")
    }
    
    func didDismissFullScreenView() {
        print("didDismissFullScreenView")
    }
}

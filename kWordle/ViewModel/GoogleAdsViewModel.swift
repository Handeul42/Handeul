//
//  GoogleAdsViewModel.swift
//  한들
//
//  Created by 강희영 on 2022/04/25.
//

import UIKit
import GoogleMobileAds

//// 구글에서 제공하는 테스트용 광고단위 ID
//let interstitialID = "ca-app-pub-3940256099942544/4411468910"
//
//// 전면광고 객체의 Delegate설정을 위해 GADInterstitialDelegate 상속
//class SomeViewController: UIViewController, GADFullScreenContentDelegate {
//    var interstitial : GADInterstitialAd? = nil // 전면 광고 객체 생성
//    //
//    //    override func viewDidLoad() {
//    //
//    //
//    ////        DispatchQueue.main.async { // view생성시 함수를 통해 전면광고 호출
//    //            self.createAndLoadInterstitial()
//    ////        }
//    ////        // qos로 전면광고 객체를 먼저 불러온 이후에 전면 광고 노출 조건 확인
//    ////        if checkAdsPopup() == false {
//    ////            self.interestitial.present(fromRootViewController: self)
//    ////        }
//    //    }
//    //
//    func checkAdsPopup() -> Bool {
//        return true
//        // 광고 노출 여부 판단을 위한 코드
//    }
//
//    func showAD() {
//        if interstitial != nil {
//            interstitial?.present(fromRootViewController: self)
//        } else {
//            print("Ad wasn't ready")
//        }
//    }
//
//    // 전면광고를 로드하여 반환하는 함수
//    func createAndLoadInterstitial(completionHandler: @escaping (Bool) -> ()) {
//        GADRewardBasedVideoAd.sharedInstance().delegate = self
//        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
//            withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
//    }
//
//
//    // 전면광고를 닫았을때(즉 광고가 끝나는 시점을 트래킹하는 함수) 끝나는 시점을 기준으로 신규 전면광고 생성
//    //    func interstitialDidDismissScreen(_ ad: GADInterstitialAd) {
//    //        print("play interestitial is finished")
//    //        createAndLoadInterstitial()
//    //    }
//}

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

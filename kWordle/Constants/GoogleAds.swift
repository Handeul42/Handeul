//
//  GoogleAds.swift
//  한들
//
//  Created by 강희영 on 2022/04/25.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeBanner)
        let viewController = UIViewController()
        //    view.adUnitID = "ca-app-pub-3940256099942544/2934735716" // 배너 광고
        view.adUnitID = "ca-app-pub-3940256099942544/5135589807" // 전면 동영상 광고
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        view.load(GADRequest())
        return viewController
    }
    
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context) {
            
        }
}

//
//struct GADFullScreenViewController: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let view = GADFullScreenPresentingAd()
//        let viewContorller = UIViewController()
//        
//        
//        
//    }
//}
